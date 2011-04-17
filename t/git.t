#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

BEGIN {
    use_ok('Git2');
}


sub main {
    my $repo = Git2::Repository->open(".git");
    isa_ok($repo, 'Git2::Repository');
    return 0;
}


exit main() unless caller;
