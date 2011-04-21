#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
#use Test::More tests => 2;
use File::Temp 'tempdir';
use Data::Dumper;
use Digest::SHA1  qw(sha1 sha1_hex);

BEGIN {
    use_ok('Git2');
}


sub main {
    test_version();
    test_constants();
    test_open();
    test_init();
    test_database();
    test_oid();
    return 0;
}


sub test_open {
    my $dir = '.git';
    my $repo = Git2::Repository->open($dir);
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
}


sub test_oid {
    my $sha1hex = sha1_hex('Amsterdam QA Hackathon');
    my $oid = Git2::Oid->mkstr($sha1hex);
    isa_ok($oid, 'Git2::Oid', 'oid constructed from a hex string');
	is($oid->fmt, $sha1hex, 'fmtt from hex string matches');
	is($oid->pathfmt, 'a7/14613980e7ea3aa88062b66c9220b9cd446d49', 'pathfmt from hex string matches');

    my $sha1raw = sha1('I can haz bin string');
    my $oid2 = Git2::Oid->mkraw($sha1raw);
    isa_ok($oid2, 'Git2::Oid', 'oid constructed from a bin string');
	is($oid2->fmt, '2a98d8f0cb57dadaa9be5527bf540c4adc6f2ba6', 'fmt from bin string matches');
	is($oid2->pathfmt, '2a/98d8f0cb57dadaa9be5527bf540c4adc6f2ba6', 'pathfmt from hex string matches');

	ok($oid->cmp($oid2) > 0);
	ok($oid2->cmp($oid) < 0);
	ok($oid->cmp($oid) == 0);
	ok($oid2->cmp($oid2) == 0);

	my $oid_copy = $oid->cpy;
	isa_ok($oid_copy, 'Git2::Oid');
	is($oid_copy->fmt, $sha1hex, 'fmtt from hex string matches');
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
}

exit main() unless caller;
