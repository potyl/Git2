#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
#use Test::More tests => 2;
use File::Temp 'tempdir';
use File::Spec::Functions 'catdir';
use FindBin '$RealBin';

use Data::Dumper;
use Digest::SHA1  qw(sha1 sha1_hex);


BEGIN {
    use_ok('Git2');
}


my $SAMPLE_REPO_DIR = catdir($RealBin, '..', 'sample-repo');


sub main {
    test_version();
    test_constants();
    test_strerror();
    test_open();
    test_init();
    test_database();
    test_oid();
    test_oid_shorten();
    test_signature();
    return 0;
}


sub test_open {
    my $repo = Git2::Repository->open($SAMPLE_REPO_DIR);
    isa_ok($repo, 'Git2::Repository');
}


sub test_init {
    my $dir = tempdir( CLEANUP => 1 );

    my $repo = Git2::Repository->init($dir, 1);
    isa_ok($repo, 'Git2::Repository', 'construct repository object with init()');
    
    my $repo2 = Git2::Repository->open($dir);
    isa_ok($repo2, 'Git2::Repository', 'construct repository object with open() on the same folder');
}


sub test_database {
    my $dir = tempdir( CLEANUP => 1 );
    my $repo = Git2::Repository->init($dir, 1);
    
    my $database = $repo->database();
    isa_ok($database, 'Git2::Odb', 'getting database object from the repository');

    # Test $odb->exists()
    $repo = Git2::Repository->open($SAMPLE_REPO_DIR);
    my $odb = $repo->database;
    my $sha1hex = '9e50c4af90e4a175bffba6683fd1ec2f9085d541';
    my $oid = Git2::Oid->mkstr($sha1hex);
    is($odb->exists($oid), 1, "Found first commit");

	# Test $odb->read();
    my $obj = $odb->read($oid);
    isa_ok($obj, 'Git2::Odb::Object');

	my $data = <<'__OBJECT__';
tree 8202e50b78a406275c6a15053cf269a3b6d021ca
author Emmanuel Rodriguez <emmanuel.rodriguez@gmail.com> 1304768126 +0200
committer Emmanuel Rodriguez <emmanuel.rodriguez@gmail.com> 1304768126 +0200

Import
__OBJECT__
	is($obj->data, $data, "Object's data matches");
	is($obj->size, length($data), "Object's size matches");
	is($obj->type, Git2::GIT_OBJ_COMMIT, "Object's type matches");

	my @headers = $odb->read_header($oid);
	is_deeply(\@headers, [length($data), Git2::GIT_OBJ_COMMIT], "read_header matches");

    isa_ok($obj->id, "Git2::Oid");
    is($obj->id->fmt, $sha1hex, "Oid hex matches");

    my $oid2 = Git2::Oid->mkstr('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    is($odb->exists($oid2), 0, "Can't find an object that doesn't exist");

	@headers = $odb->read_header($oid2);
	is_deeply(\@headers, [], "read_header in list context for an oid that doesn't exist");

	my $oid3 = $odb->write("Hello world", Git2::GIT_OBJ_BLOB);
	isa_ok($oid3, 'Git2::Oid');
	is($oid3->fmt, "70c379b63ffa0795fdbfbc128e5a2818397b7ef8", "Write returns the right oid");
    is($odb->exists($oid3), 1, "Found new object exist");
    $obj = $odb->read($oid3);
    isa_ok($obj, 'Git2::Odb::Object');
	is($obj->data, "Hello world", "Object's data matches");
	is($obj->size, 11, "New object's size matches");
	is($obj->type, Git2::GIT_OBJ_BLOB, "New object's type matches");
}


sub test_oid {
    my $sha1hex = sha1_hex('Amsterdam QA Hackathon');
    my $oid = Git2::Oid->mkstr($sha1hex);
    isa_ok($oid, 'Git2::Oid', 'oid constructed from a hex string');
	is($oid->fmt, $sha1hex, 'fmt from hex string matches');
	is($oid->pathfmt, 'a7/14613980e7ea3aa88062b66c9220b9cd446d49', 'pathfmt from hex string matches');
	is($oid->allocfmt, $sha1hex, 'allocfmt from hex string matches');
	is($oid->to_string(1), '', 'to_string(1) from hex string matches');
	is($oid->to_string(2), 'a', 'to_string(2) from hex string matches');
	is($oid->to_string(10), 'a71461398', 'to_string(10) from hex string matches');
	is($oid->to_string(40), 'a714613980e7ea3aa88062b66c9220b9cd446d4', 'to_string(40) from hex string matches');
	is($oid->to_string(41), 'a714613980e7ea3aa88062b66c9220b9cd446d49', 'to_string(41) from hex string matches');

    my $sha1raw = sha1('I can haz bin string');
    my $oid2 = Git2::Oid->mkraw($sha1raw);
    isa_ok($oid2, 'Git2::Oid', 'oid constructed from a bin string');
	is($oid2->fmt, '2a98d8f0cb57dadaa9be5527bf540c4adc6f2ba6', 'fmt from bin string matches');
	is($oid2->pathfmt, '2a/98d8f0cb57dadaa9be5527bf540c4adc6f2ba6', 'pathfmt from hex string matches');
	is($oid2->allocfmt, '2a98d8f0cb57dadaa9be5527bf540c4adc6f2ba6', 'allocfmt from bin string matches');
	is($oid2->to_string(1), '', 'to_string(1) from bin string matches');
	is($oid2->to_string(2), '2', 'to_string(2) from bin string matches');
	is($oid2->to_string(10), '2a98d8f0c', 'to_string(10) from bin string matches');
	is($oid2->to_string(40), '2a98d8f0cb57dadaa9be5527bf540c4adc6f2ba', 'to_string(40) from bin string matches');
	is($oid2->to_string(41), '2a98d8f0cb57dadaa9be5527bf540c4adc6f2ba6', 'to_string(41) from bin string matches');

	ok($oid->cmp($oid2) > 0, "cmp a > b 0");
	ok($oid2->cmp($oid) < 0, "cmp b < a 0");
	ok($oid->cmp($oid) == 0, "cmp a == a");
	ok($oid2->cmp($oid2) == 0, "cmp b == b");

	my $oid_copy = $oid->cpy;
	isa_ok($oid_copy, 'Git2::Oid');
	is($oid_copy->fmt, $sha1hex, 'fmt from hex string matches');
	is($oid_copy->pathfmt, 'a7/14613980e7ea3aa88062b66c9220b9cd446d49', 'pathfmt from hex string matches');
}


sub test_version {
    ok(Git2::VERSION =~ /^[0-9]+\.[0-9]+.[0-9]+$/, "VERSION is a string");
    ok(Git2::VER_MAJOR    >= 0, "VER_MAJOR is a number");
    ok(Git2::VER_MINOR    >= 0, "VER_MINOR is a number");
    ok(Git2::VER_REVISION >= 0, "VER_REVISION is a number");

    # You might be tempted at testing that:
    #    VERSION == VER_MAJOR.VER_MINOR.VER_REVISION
    # but this is not always true, at least not with version 0.11.0!
}


sub test_constants {
    my $code = 0;
    is(Git2::GIT_SUCCESS, $code--, "GIT_SUCCESS is ok");
    is(Git2::GIT_ERROR, $code--, "GIT_ERROR is ok");
    is(Git2::GIT_ENOTOID, $code--, "GIT_ENOTOID is ok");
	is(Git2::GIT_ENOTFOUND, $code--, "GIT_ENOTFOUND is ok");
	is(Git2::GIT_ENOMEM, $code--, "GIT_ENOMEM is ok");
	is(Git2::GIT_EOSERR, $code--, "GIT_EOSERR is ok");
	is(Git2::GIT_EOBJTYPE, $code--, "GIT_EOBJTYPE is ok");
	is(Git2::GIT_EOBJCORRUPTED, $code--, "GIT_EOBJCORRUPTED is ok");
	is(Git2::GIT_ENOTAREPO, $code--, "GIT_ENOTAREPO is ok");
	is(Git2::GIT_EINVALIDTYPE, $code--, "GIT_EINVALIDTYPE is ok");
	is(Git2::GIT_EMISSINGOBJDATA, $code--, "GIT_EMISSINGOBJDATA is ok");
	is(Git2::GIT_EPACKCORRUPTED, $code--, "GIT_EPACKCORRUPTED is ok");
	is(Git2::GIT_EFLOCKFAIL, $code--, "GIT_EFLOCKFAIL is ok");
	is(Git2::GIT_EZLIB, $code--, "GIT_EZLIB is ok");
	is(Git2::GIT_EBUSY, $code--, "GIT_EBUSY is ok");
	is(Git2::GIT_EBAREINDEX, $code--, "GIT_EBAREINDEX is ok");
	is(Git2::GIT_EINVALIDREFNAME, $code--, "GIT_EINVALIDREFNAME is ok");
	is(Git2::GIT_EREFCORRUPTED , $code--, "GIT_EREFCORRUPTED  is ok");
	is(Git2::GIT_ETOONESTEDSYMREF, $code--, "GIT_ETOONESTEDSYMREF is ok");
	is(Git2::GIT_EPACKEDREFSCORRUPTED, $code--, "GIT_EPACKEDREFSCORRUPTED is ok");
	is(Git2::GIT_EINVALIDPATH, $code--, "GIT_EINVALIDPATH is ok");
	is(Git2::GIT_EREVWALKOVER, $code--, "GIT_EREVWALKOVER is ok");
	is(Git2::GIT_EINVALIDREFSTATE, $code--, "GIT_EINVALIDREFSTATE is ok");
	is(Git2::GIT_ENOTIMPLEMENTED, $code--, "GIT_ENOTIMPLEMENTED is ok");
	is(Git2::GIT_EEXISTS, $code--, "GIT_EEXISTS is ok");
	is(Git2::GIT_EOVERFLOW, $code--, "GIT_EOVERFLOW is ok");
	is(Git2::GIT_ENOTNUM, $code--, "GIT_ENOTNUM is ok");


	$code = -2;
	is(Git2::GIT_OBJ_ANY, $code++, "GIT_OBJ_ANY is ok");
	is(Git2::GIT_OBJ_BAD, $code++, "GIT_OBJ_BAD is ok");
	is(Git2::GIT_OBJ__EXT1, $code++, "GIT_OBJ__EXT1 is ok");
	is(Git2::GIT_OBJ_COMMIT, $code++, "GIT_OBJ_COMMIT is ok");
	is(Git2::GIT_OBJ_TREE, $code++, "GIT_OBJ_TREE is ok");
	is(Git2::GIT_OBJ_BLOB, $code++, "GIT_OBJ_BLOB is ok");
	is(Git2::GIT_OBJ_TAG, $code++, "GIT_OBJ_TAG is ok");
	is(Git2::GIT_OBJ__EXT2, $code++, "GIT_OBJ__EXT2 is ok");
	is(Git2::GIT_OBJ_OFS_DELTA, $code++, "GIT_OBJ_OFS_DELTA is ok");
	is(Git2::GIT_OBJ_REF_DELTA, $code++, "GIT_OBJ_REF_DELTA is ok");
}


sub test_strerror {
    ok(Git2->strerror(Git2::GIT_ERROR), "strerror GIT_ERROR");
    ok(Git2->strerror(Git2::GIT_ENOTOID), "strerror GIT_ENOTOID");
    ok(Git2->strerror(Git2::GIT_ENOTFOUND), "strerror GIT_ENOTFOUND");
    ok(Git2->strerror(Git2::GIT_ENOMEM), "strerror GIT_ENOMEM");
    ok(Git2->strerror(Git2::GIT_EOSERR), "strerror GIT_EOSERR");
    ok(Git2->strerror(Git2::GIT_EOBJTYPE), "strerror GIT_EOBJTYPE");
    ok(Git2->strerror(Git2::GIT_EOBJCORRUPTED), "strerror GIT_EOBJCORRUPTED");
    ok(Git2->strerror(Git2::GIT_ENOTAREPO), "strerror GIT_ENOTAREPO");
    ok(Git2->strerror(Git2::GIT_EINVALIDTYPE), "strerror GIT_EINVALIDTYPE");
    ok(Git2->strerror(Git2::GIT_EMISSINGOBJDATA), "strerror GIT_EMISSINGOBJDATA");
    ok(Git2->strerror(Git2::GIT_EPACKCORRUPTED), "strerror GIT_EPACKCORRUPTED");
    ok(Git2->strerror(Git2::GIT_EFLOCKFAIL), "strerror GIT_EFLOCKFAIL");
    ok(Git2->strerror(Git2::GIT_EZLIB), "strerror GIT_EZLIB");
    ok(Git2->strerror(Git2::GIT_EBUSY), "strerror GIT_EBUSY");
    ok(Git2->strerror(Git2::GIT_EBAREINDEX), "strerror GIT_EBAREINDEX");
    ok(Git2->strerror(Git2::GIT_EINVALIDREFNAME), "strerror GIT_EINVALIDREFNAME");
    ok(Git2->strerror(Git2::GIT_EREFCORRUPTED ), "strerror GIT_EREFCORRUPTED ");
    ok(Git2->strerror(Git2::GIT_ETOONESTEDSYMREF), "strerror GIT_ETOONESTEDSYMREF");
    ok(Git2->strerror(Git2::GIT_EPACKEDREFSCORRUPTED), "strerror GIT_EPACKEDREFSCORRUPTED");
    ok(Git2->strerror(Git2::GIT_EINVALIDPATH), "strerror GIT_EINVALIDPATH");
    ok(Git2->strerror(Git2::GIT_EREVWALKOVER), "strerror GIT_EREVWALKOVER");
    ok(Git2->strerror(Git2::GIT_EINVALIDREFSTATE), "strerror GIT_EINVALIDREFSTATE");
    ok(Git2->strerror(Git2::GIT_ENOTIMPLEMENTED), "strerror GIT_ENOTIMPLEMENTED");
    ok(Git2->strerror(Git2::GIT_EEXISTS), "strerror GIT_EEXISTS");
    ok(Git2->strerror(Git2::GIT_EOVERFLOW), "strerror GIT_EOVERFLOW");
    ok(Git2->strerror(Git2::GIT_ENOTNUM), "strerror GIT_ENOTNUM");
}


sub test_oid_shorten {
    my ($os, $len, $sha1);

    $os = Git2::Oid::Shorten->new(5);
    isa_ok($os, 'Git2::Oid::Shorten');

    $sha1 = 'a' x 40;
    $len = $os->add($sha1);
    is($len, 5, "Shorten of 5, first oid");

    $len = $os->add(++$sha1);
    is($len, 41, "Shorten of 5 last char differs");


    undef $os;
    $os = Git2::Oid::Shorten->new(1);
    isa_ok($os, 'Git2::Oid::Shorten');

    $len = $os->add('0' . 'a' x 39);
    is($len, 1, "Shorten of 1, first oid");

    $len = $os->add('1' . 'a' x 39);
    is($len, 1, "Shorten of 1, first char differs");

    $len = $os->add('10' . 'a' x 38);
    is($len, 2, "Shorten of 1, second char differs");
}


sub test_signature {
    my $signature = Git2::Signature->now("Emo", 'emo@example.org');
    isa_ok($signature, 'Git2::Signature');
    isa_ok($signature->dup, 'Git2::Signature', "Signature->now->dup is a signature");

    my $signature2 = Git2::Signature->new("Potyl", 'potyl@example.org', time, 0);
    isa_ok($signature2, 'Git2::Signature');
    isa_ok($signature->dup, 'Git2::Signature', "Signature->new->dup is a signature");
}


exit main() unless caller;
