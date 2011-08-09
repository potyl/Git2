#include "git2-perl.h"


MODULE = Git2::Oid  PACKAGE = Git2::Oid  PREFIX = git_oid_


SV*
git_oid_fromstr(SV *class, const char *hex)
    PREINIT:
        git_oid *oid;
        int code;

    CODE:
        Newxz(oid, 1, git_oid);
        code = git_oid_fromstr(oid, hex);
        GIT2PERL_CROAK(code);
        GIT2PERL_BLESS_FROM_CLASS_SV(oid, class);

    OUTPUT:
        RETVAL


SV*
git_oid_fromraw(SV *class, SV *raw_sv);
    PREINIT:
        git_oid *oid;
        const unsigned char *raw;

    CODE:
        raw = (const unsigned char *) SvPV_nolen(raw_sv);
        Newxz(oid, 1, git_oid);
        git_oid_fromraw(oid, raw);
        GIT2PERL_BLESS_FROM_CLASS_SV(oid, class);

    OUTPUT:
        RETVAL


SV*
git_oid_fmt(git_oid *oid)
    PREINIT:
        char str[GIT_OID_HEXSZ];

    CODE:
        git_oid_fmt(str, oid);
        RETVAL = newSVpv(str, GIT_OID_HEXSZ);

    OUTPUT:
        RETVAL


SV*
git_oid_pathfmt(git_oid *oid)
    PREINIT:
        char str[GIT_OID_HEXSZ + 1];

    CODE:
        git_oid_pathfmt(str, oid);
        RETVAL = newSVpv(str, GIT_OID_HEXSZ + 1);

    OUTPUT:
        RETVAL


SV*
git_oid_allocfmt(git_oid *oid)
    PREINIT:
        char *str = NULL;

    CODE:
        str = git_oid_allocfmt(oid);
        if (str != NULL) {
        RETVAL = newSVpv(str, 0);
        free(str);
    }
    else {
        RETVAL = &PL_sv_undef;
    }

    OUTPUT:
        RETVAL


SV*
git_oid_to_string(git_oid *oid, size_t n)
    PREINIT:
        char *str = NULL;

    CODE:
        Newxz(str, n, char);
        git_oid_to_string(str, n, oid);
        if (str != NULL) {
        RETVAL = newSVpv(str, n - 1);
        free(str);
    }
    else {
        RETVAL = &PL_sv_undef;
    }

    OUTPUT:
        RETVAL


SV*
git_oid_cpy(git_oid *src)
    PREINIT:
        git_oid *oid;

    CODE:
        Newxz(oid, 1, git_oid);
        git_oid_cpy(oid, src);
        GIT2PERL_BLESS_FROM_SV(oid, ST(0));

    OUTPUT:
        RETVAL


int
git_oid_cmp(git_oid *a, git_oid *b)
    CODE:
        RETVAL = git_oid_cmp(a, b);

    OUTPUT:
        RETVAL


void
DESTROY(git_oid *oid)
    CODE:
        Safefree(oid);
