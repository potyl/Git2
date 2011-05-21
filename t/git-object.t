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


sub main {
	my $repo = Git2::Repository->open(catdir($RealBin, '..', 'sample-repo'));
	test_blob($repo);
	test_commit($repo);
	return 0;
}


sub test_blob {
	my ($repo) = @_;

	my $sha1hex = '92ea28161c72a03696172f99af96fcac1b35faea';
	my $oid = Git2::Oid->mkstr($sha1hex);
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
}


sub test_commit {
	my ($repo) = @_;

	my $sha1hex = '9e50c4af90e4a175bffba6683fd1ec2f9085d541';
	my $oid = Git2::Oid->mkstr($sha1hex);
	my $commit = $repo->lookup($oid, Git2::GIT_OBJ_COMMIT);
	isa_ok($commit, 'Git2::Object', "A commit is an object");
	isa_ok($commit, 'Git2::Commit', "A commit is a blob");

	my $id = $commit->id;
	isa_ok($id, "Git2::Oid");
	is($id->fmt, $sha1hex, "Oid sha1hex matches");

	is($commit->type, Git2::GIT_OBJ_COMMIT, "Type matches");

	isa_ok($commit->owner, "Git2::Repository", "Owner is a repo");

	is($commit->message_short, "Import", "Commit's message short matches");
	is($commit->parentcount, 0, "Parentcount matches");
	is($commit->time, 1304768126, "Time matches");
	is($commit->time_offset, 120, "Timezone matches");

	$id = $commit->parent_oid(0);
	is($id, undef, "No parent");
}


exit main() unless caller;
