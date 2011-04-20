#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
#use Test::More tests => 2;
use File::Temp 'tempdir';

BEGIN {
    use_ok('Git2');
}


sub main {
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
    my $sha1hex = "a" x 40;
    my $oid = Git2::Oid->mkstr($sha1hex);

    my $sha1raw = pack 'a20', 'a' x 20;
    my $oid2 = Git2::Oid->mkraw($sha1raw);

	print Dumper($oid2);
	my $sha1hex2 = $oid2->fmt();
	print "hex: $sha1hex2\n";

    isa_ok($oid, 'Git2::Oid');
}


exit main() unless caller;
