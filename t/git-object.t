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


exit main() unless caller;
