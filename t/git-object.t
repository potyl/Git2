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
	test_commit_1($repo);
	test_commit_2($repo);
	test_commit_3($repo);
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


sub test_commit_1 {
	my ($repo) = @_;

	my $sha1hex = '9e50c4af90e4a175bffba6683fd1ec2f9085d541';
	my $oid = Git2::Oid->fromstr($sha1hex);
	my $commit = $repo->lookup($oid, Git2::GIT_OBJ_COMMIT);
	isa_ok($commit, 'Git2::Object', "A commit is an object");
	isa_ok($commit, 'Git2::Commit', "A commit is a blob");

	my $id = $commit->id;
	isa_ok($id, "Git2::Oid");
	is($id->fmt, $sha1hex, "Oid sha1hex matches");

	is($commit->type, Git2::GIT_OBJ_COMMIT, "Type matches");

	isa_ok($commit->owner, "Git2::Repository", "Owner is a repo");

	is($commit->message_short, "Import", "Commit's short message matches");
	is($commit->message, "Import\n", "Commit's message matches");
	is($commit->parentcount, 0, "Parentcount matches");
	is($commit->time, 1304768126, "Time matches");
	is($commit->time_offset, 120, "Timezone matches");

	$id = $commit->parent_oid(0);
	is($id, undef, "No parent");
}


sub test_commit_2 {
	my ($repo) = @_;

	my $sha1hex = '0dac239f796b57e58faaeb80125ff1607eefd3bc';
	my $oid = Git2::Oid->fromstr($sha1hex);
	my $commit = $repo->lookup($oid, Git2::GIT_OBJ_COMMIT);
	isa_ok($commit, 'Git2::Object', "A commit is an object");
	isa_ok($commit, 'Git2::Commit', "A commit is a blob");

	my $id = $commit->id;
	isa_ok($id, "Git2::Oid");
	is($id->fmt, $sha1hex, "Oid sha1hex matches");

	is($commit->type, Git2::GIT_OBJ_COMMIT, "Type matches");

	isa_ok($commit->owner, "Git2::Repository", "Owner is a repo");

	is($commit->message_short, "Updates", "Commit's message short matches");
	is($commit->parentcount, 1, "Parentcount matches");
	is($commit->time, 1306011477, "Time matches");
	is($commit->time_offset, 120, "Timezone matches");

	$id = $commit->parent_oid(1);
	is($id, undef, "No parent for (1)");

	$id = $commit->parent_oid(0);
	isa_ok($id, 'Git2::Oid', "Got a parent for (0)");
	is($id->fmt, '9e50c4af90e4a175bffba6683fd1ec2f9085d541', "Parent's oid sha1hex matches");
}


sub test_commit_3 {
	my ($repo) = @_;

	my $sha1hex = '0dac239f796b57e58faaeb80125ff1607eefd3bc';
	my $oid = Git2::Oid->fromstr($sha1hex);
	my $commit = $repo->lookup_prefix($oid, length($sha1hex), Git2::GIT_OBJ_COMMIT);
	isa_ok($commit, 'Git2::Object', "A commit is an object");
	isa_ok($commit, 'Git2::Commit', "A commit is a blob");

	my $id = $commit->id;
	isa_ok($id, "Git2::Oid");
	is($id->fmt, $sha1hex, "Oid sha1hex matches");

	is($commit->type, Git2::GIT_OBJ_COMMIT, "Type matches");

	isa_ok($commit->owner, "Git2::Repository", "Owner is a repo");

	is($commit->message_short, "Updates", "Commit's message short matches");
	is($commit->parentcount, 1, "Parentcount matches");
	is($commit->time, 1306011477, "Time matches");
	is($commit->time_offset, 120, "Timezone matches");

	$id = $commit->parent_oid(1);
	is($id, undef, "No parent for (1)");

	$id = $commit->parent_oid(0);
	isa_ok($id, 'Git2::Oid', "Got a parent for (0)");
	is($id->fmt, '9e50c4af90e4a175bffba6683fd1ec2f9085d541', "Parent's oid sha1hex matches");
}


exit main() unless caller;
