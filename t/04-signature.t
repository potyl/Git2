#!/usr/bin/perl

# in the libgit2 test suite, tests for signatures mostly appear in
# 04-commit.t

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


my $SAMPLE_REPO_DIR = catdir($RealBin, '..', 'sample-repo');


sub main {
    test_signature();
    return 0;
}


sub test_signature {
    my $signature = Git2::Signature->now("Emo", 'emo@example.org');
    isa_ok($signature, 'Git2::Signature');
    isa_ok($signature->dup, 'Git2::Signature', "Signature->now->dup is a signature");

    my $signature2 = Git2::Signature->new("Potyl", 'potyl@example.org', time, 0);
    isa_ok($signature2, 'Git2::Signature');
    isa_ok($signature->dup, 'Git2::Signature', "Signature->new->dup is a signature");
}


exit main() unless caller;
