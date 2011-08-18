#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
#use Test::More tests => 2;
use File::Temp 'tempdir';
use File::Spec::Functions 'catdir', 'catfile';
use FindBin '$RealBin';

use Data::Dumper;
use Digest::SHA1  qw(sha1 sha1_hex);


BEGIN {
	use_ok('Git2');
}


my $DIR = catdir($RealBin, '..', 'sample-repo');

sub main {
	my $repo = Git2::Repository->open($DIR);
	test_blob($repo);
	return 0;
}


sub test_blob {
	my ($repo) = @_;

	my $sha1hex = '92ea28161c72a03696172f99af96fcac1b35faea';
	my $oid = Git2::Oid->fromstr($sha1hex);
	my $blob = $repo->lookup($oid, Git2::GIT_OBJ_BLOB);
	isa_ok($blob, 'Git2::Object', "A blob is an object");
	isa_ok($blob, 'Git2::Blob', "A blob is a blob");

	my $id = $blob->id;
	isa_ok($id, "Git2::Oid");
	is($id->fmt, $sha1hex, "Oid sha1hex matches");

	is($blob->type, Git2::GIT_OBJ_BLOB, "Blob type is as expected");

	isa_ok($blob->owner, "Git2::Repository", "Blob's owner is a repo");

	is($blob->rawcontent, "Fake repo used for unit tests.\n\n", "Blob raw content matches");
	is($blob->rawsize, 32, "Blob raw size matches");

	# This test doesn't work with a bare repo
	if ($ENV{ALL_TESTS}) {
		# Clone the bare depo
		my $dir_copy = tempdir('git2-tests-XXXXXXXXX', CLEANUP => 1);
		system('git', 'clone', '--quiet', $DIR, $dir_copy);

		# Create a blob file
		open my $handle, '>'. catfile($dir_copy, 'blob') or die "Can't write blob: $!";
		print $handle "hello world\n";
		close $handle;

		# Add the blob to the repo
		my $repo = Git2::Repository->open(catdir($dir_copy, '.git'));
		$oid = $repo->create_blob_fromfile("blob");
		isa_ok($oid, "Git2::Oid");
		is($oid->fmt, "3b18e512dba79e4c8300dd08aeb37f8e728b8dad", "Blob from file has the right OID");
	}

	$oid = $repo->create_blob_frombuffer("hello world");
	isa_ok($oid, "Git2::Oid");
	is($oid->fmt, "95d09f2b10159347eece71399a7e2e907ea3df4f", "Blob from buffer has the right OID");
}


exit main() unless caller;
