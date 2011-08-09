#include "git2-perl.h"


MODULE = Git2::Oid::Shorten  PACKAGE = Git2::Oid::Shorten  PREFIX = git_oid_shorten_


SV*
git_oid_shorten_new (SV *class, size_t min_length)
    PREINIT:
        git_oid_shorten *os;

    CODE:
        os = git_oid_shorten_new(min_length);
        GIT2PERL_BLESS_FROM_CLASS_SV(os, class);

    OUTPUT:
        RETVAL


int
git_oid_shorten_add (git_oid_shorten *os, const char *text_oid)


void
DESTROY(git_oid_shorten *os)
    CODE:
        git_oid_shorten_free(os);
