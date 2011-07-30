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
    test_open();
    test_init();
    test_database();
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
    my $oid = Git2::Oid->fromstr($sha1hex);
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

    my $oid2 = Git2::Oid->fromstr('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
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

	my $oid4 = Git2::Odb->hash("Hello world", Git2::GIT_OBJ_BLOB);
	isa_ok($oid4, 'Git2::Oid');
	is($oid4->fmt, "70c379b63ffa0795fdbfbc128e5a2818397b7ef8", "Class::hash returns the right oid");

	my $oid5 = $odb->hash("Hello world", Git2::GIT_OBJ_BLOB);
	isa_ok($oid5, 'Git2::Oid');
	is($oid5->fmt, "70c379b63ffa0795fdbfbc128e5a2818397b7ef8", "Obj->hash returns the right oid");
}


exit main() unless caller;
