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


    my $database = $repo2->database();
    isa_ok($database, 'Git2::Odb');
}

sub test_database {
    my $dir = tempdir( CLEANUP => 1 );
    my $repo = Git2::Repository->init($dir, 1);
    
    my $git_db = Git2::Repository->database($repo);
    isa_ok($git_db, 'Git2::Repository::Database', 'getting database object from the repository');
    
    
    
}


exit main() unless caller;
