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
    test_version();
    test_constants();
    test_strerror();
    return 0;
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


sub test_constants {

    my @constants =
	qw( ERROR ENOTOID ENOTFOUND ENOMEM EOSERR EOBJTYPE
	    EOBJCORRUPTED ENOTAREPO EINVALIDTYPE EMISSINGOBJDATA
	    EPACKCORRUPTED EFLOCKFAIL EZLIB EBUSY EBAREINDEX
	    EINVALIDREFNAME EREFCORRUPTED ETOONESTEDSYMREF
	    EPACKEDREFSCORRUPTED EINVALIDPATH EREVWALKOVER
	    EINVALIDREFSTATE ENOTIMPLEMENTED EEXISTS EOVERFLOW ENOTNUM
	    ESTREAM EINVALIDARGS EAMBIGUOUSOIDPREFIX EPASSTHROUGH
	    ENOMATCH ESHORTBUFFER
	    );

    is(Git2::GIT_SUCCESS, 0, "GIT_SUCCESS (0) is OK");
    no strict 'refs';
    my %seen;
    for my $constant ( @constants ) {
	my $val = &{"Git2::GIT_$constant"};
	ok(($val<0) && !$seen{$val}++, "$constant is <0 and unique");
    }

    my $code = -2;
	is(Git2::GIT_OBJ_ANY, $code++, "GIT_OBJ_ANY is ok");
	is(Git2::GIT_OBJ_BAD, $code++, "GIT_OBJ_BAD is ok");
	is(Git2::GIT_OBJ__EXT1, $code++, "GIT_OBJ__EXT1 is ok");
	is(Git2::GIT_OBJ_COMMIT, $code++, "GIT_OBJ_COMMIT is ok");
	is(Git2::GIT_OBJ_TREE, $code++, "GIT_OBJ_TREE is ok");
	is(Git2::GIT_OBJ_BLOB, $code++, "GIT_OBJ_BLOB is ok");
	is(Git2::GIT_OBJ_TAG, $code++, "GIT_OBJ_TAG is ok");
	is(Git2::GIT_OBJ__EXT2, $code++, "GIT_OBJ__EXT2 is ok");
	is(Git2::GIT_OBJ_OFS_DELTA, $code++, "GIT_OBJ_OFS_DELTA is ok");
	is(Git2::GIT_OBJ_REF_DELTA, $code++, "GIT_OBJ_REF_DELTA is ok");
}


sub test_strerror {
    ok(Git2->strerror(Git2::GIT_ERROR), "strerror GIT_ERROR");
    ok(Git2->strerror(Git2::GIT_ENOTOID), "strerror GIT_ENOTOID");
    ok(Git2->strerror(Git2::GIT_ENOTFOUND), "strerror GIT_ENOTFOUND");
    ok(Git2->strerror(Git2::GIT_ENOMEM), "strerror GIT_ENOMEM");
    ok(Git2->strerror(Git2::GIT_EOSERR), "strerror GIT_EOSERR");
    ok(Git2->strerror(Git2::GIT_EOBJTYPE), "strerror GIT_EOBJTYPE");
    ok(Git2->strerror(Git2::GIT_EOBJCORRUPTED), "strerror GIT_EOBJCORRUPTED");
    ok(Git2->strerror(Git2::GIT_ENOTAREPO), "strerror GIT_ENOTAREPO");
    ok(Git2->strerror(Git2::GIT_EINVALIDTYPE), "strerror GIT_EINVALIDTYPE");
    ok(Git2->strerror(Git2::GIT_EMISSINGOBJDATA), "strerror GIT_EMISSINGOBJDATA");
    ok(Git2->strerror(Git2::GIT_EPACKCORRUPTED), "strerror GIT_EPACKCORRUPTED");
    ok(Git2->strerror(Git2::GIT_EFLOCKFAIL), "strerror GIT_EFLOCKFAIL");
    ok(Git2->strerror(Git2::GIT_EZLIB), "strerror GIT_EZLIB");
    ok(Git2->strerror(Git2::GIT_EBUSY), "strerror GIT_EBUSY");
    ok(Git2->strerror(Git2::GIT_EBAREINDEX), "strerror GIT_EBAREINDEX");
    ok(Git2->strerror(Git2::GIT_EINVALIDREFNAME), "strerror GIT_EINVALIDREFNAME");
    ok(Git2->strerror(Git2::GIT_EREFCORRUPTED ), "strerror GIT_EREFCORRUPTED ");
    ok(Git2->strerror(Git2::GIT_ETOONESTEDSYMREF), "strerror GIT_ETOONESTEDSYMREF");
    ok(Git2->strerror(Git2::GIT_EPACKEDREFSCORRUPTED), "strerror GIT_EPACKEDREFSCORRUPTED");
    ok(Git2->strerror(Git2::GIT_EINVALIDPATH), "strerror GIT_EINVALIDPATH");
    ok(Git2->strerror(Git2::GIT_EREVWALKOVER), "strerror GIT_EREVWALKOVER");
    ok(Git2->strerror(Git2::GIT_EINVALIDREFSTATE), "strerror GIT_EINVALIDREFSTATE");
    ok(Git2->strerror(Git2::GIT_ENOTIMPLEMENTED), "strerror GIT_ENOTIMPLEMENTED");
    ok(Git2->strerror(Git2::GIT_EEXISTS), "strerror GIT_EEXISTS");
    ok(Git2->strerror(Git2::GIT_EOVERFLOW), "strerror GIT_EOVERFLOW");
    ok(Git2->strerror(Git2::GIT_ENOTNUM), "strerror GIT_ENOTNUM");
}


exit main() unless caller;
