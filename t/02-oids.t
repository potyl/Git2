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


my $SAMPLE_REPO_DIR = catdir($RealBin, '..', 'sample-repo');


sub main {
    test_oid();
    test_oid_shorten();
    return 0;
}


sub test_oid {
    my $sha1hex = sha1_hex('Amsterdam QA Hackathon');
    my $oid = Git2::Oid->fromstr($sha1hex);
    isa_ok($oid, 'Git2::Oid', 'oid constructed from a hex string');
	is($oid->fmt, $sha1hex, 'fmt from hex string matches');
	is($oid->pathfmt, 'a7/14613980e7ea3aa88062b66c9220b9cd446d49', 'pathfmt from hex string matches');
	is($oid->allocfmt, $sha1hex, 'allocfmt from hex string matches');
	is($oid->to_string(1), '', 'to_string(1) from hex string matches');
	is($oid->to_string(2), 'a', 'to_string(2) from hex string matches');
	is($oid->to_string(10), 'a71461398', 'to_string(10) from hex string matches');
	is($oid->to_string(40), 'a714613980e7ea3aa88062b66c9220b9cd446d4', 'to_string(40) from hex string matches');
	is($oid->to_string(41), 'a714613980e7ea3aa88062b66c9220b9cd446d49', 'to_string(41) from hex string matches');

    my $sha1raw = sha1('I can haz bin string');
    my $oid2 = Git2::Oid->fromraw($sha1raw);
    isa_ok($oid2, 'Git2::Oid', 'oid constructed from a bin string');
	is($oid2->fmt, '2a98d8f0cb57dadaa9be5527bf540c4adc6f2ba6', 'fmt from bin string matches');
	is($oid2->pathfmt, '2a/98d8f0cb57dadaa9be5527bf540c4adc6f2ba6', 'pathfmt from hex string matches');
	is($oid2->allocfmt, '2a98d8f0cb57dadaa9be5527bf540c4adc6f2ba6', 'allocfmt from bin string matches');
	is($oid2->to_string(1), '', 'to_string(1) from bin string matches');
	is($oid2->to_string(2), '2', 'to_string(2) from bin string matches');
	is($oid2->to_string(10), '2a98d8f0c', 'to_string(10) from bin string matches');
	is($oid2->to_string(40), '2a98d8f0cb57dadaa9be5527bf540c4adc6f2ba', 'to_string(40) from bin string matches');
	is($oid2->to_string(41), '2a98d8f0cb57dadaa9be5527bf540c4adc6f2ba6', 'to_string(41) from bin string matches');

	ok($oid->cmp($oid2) > 0, "cmp a > b 0");
	ok($oid2->cmp($oid) < 0, "cmp b < a 0");
	ok($oid->cmp($oid) == 0, "cmp a == a");
	ok($oid2->cmp($oid2) == 0, "cmp b == b");

	my $oid_copy = $oid->cpy;
	isa_ok($oid_copy, 'Git2::Oid');
	is($oid_copy->fmt, $sha1hex, 'fmt from hex string matches');
	is($oid_copy->pathfmt, 'a7/14613980e7ea3aa88062b66c9220b9cd446d49', 'pathfmt from hex string matches');
}


sub test_oid_shorten {
    my ($os, $len, $sha1);

    $os = Git2::Oid::Shorten->new(5);
    isa_ok($os, 'Git2::Oid::Shorten');

    $sha1 = 'a' x 40;
    $len = $os->add($sha1);
    is($len, 5, "Shorten of 5, first oid");

    $len = $os->add(++$sha1);
    is($len, 41, "Shorten of 5 last char differs");


    undef $os;
    $os = Git2::Oid::Shorten->new(1);
    isa_ok($os, 'Git2::Oid::Shorten');

    $len = $os->add('0' . 'a' x 39);
    is($len, 1, "Shorten of 1, first oid");

    $len = $os->add('1' . 'a' x 39);
    is($len, 1, "Shorten of 1, first char differs");

    $len = $os->add('10' . 'a' x 38);
    is($len, 2, "Shorten of 1, second char differs");
}


exit main() unless caller;
