#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

BEGIN {
    use_ok('Git2');
}


sub main {
    test_open();
    test_init();
    return 0;
}


sub test_open {
    my $dir = '.git';
    my $repo = Git2::Repository->open($dir);
    isa_ok($repo, 'Git2::Repository');
}


sub test_init {
    my $dir = 'tmp';

    my $repo = Git2::Repository->init($dir, 1);
    isa_ok($repo, 'Git2::Repository');
}


exit main() unless caller;
