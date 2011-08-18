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
	test_signature();
	test_commit_1($repo);
	test_commit_2($repo);
	test_commit_3($repo);
	return 0;
}


sub test_signature {
    my $signature = Git2::Signature->now("Emo", 'emo@example.org');
    isa_ok($signature, 'Git2::Signature');
    isa_ok($signature->dup, 'Git2::Signature', "Signature->now->dup is a signature");

    is($signature->name, "Emo", "Signature name matches");
    $signature->name("Test");
    is($signature->name, "Test", "Signature name changed");

    is($signature->email, 'emo@example.org', "Signature email matches");
    $signature->email('test@example.org');
    is($signature->email, 'test@example.org', "Signature email changed");

    my $signature2 = Git2::Signature->new("Potyl", 'potyl@example.org', time, 0);
    isa_ok($signature2, 'Git2::Signature');
    isa_ok($signature->dup, 'Git2::Signature', "Signature->new->dup is a signature");
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
	isa_ok($id, 'Git2::Oid', "Got a parent id for (0)");
	is($id->fmt, '9e50c4af90e4a175bffba6683fd1ec2f9085d541', "Parent's oid sha1hex matches");

	my $parent = $commit->parent(0);
	isa_ok($parent, 'Git2::Commit', "Got a parent for (0)");
	is($parent->id->fmt, $id->fmt, "Parent id matches");
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
