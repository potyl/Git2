#include "git2-perl.h"


MODULE = Git2::Oid  PACKAGE = Git2::Oid  PREFIX = git_oid_


SV*
git_oid_mkstr(SV *class, const char *hex)
    PREINIT:
        git_oid *oid;
        int code;

    CODE:
        Newxz(oid, 1, git_oid);
        code = git_oid_mkstr(oid, hex);
        GIT2PERL_CROAK(code);
        GIT2PERL_BLESS(oid);


void
DESTROY(git_oid *oid)
    CODE:
        Safefree(oid);
