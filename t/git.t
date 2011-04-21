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

exit main() unless caller;
