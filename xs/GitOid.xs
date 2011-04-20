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

	OUTPUT:
		RETVAL


SV*
git_oid_mkraw(SV *class, SV *raw_sv);
    PREINIT:
        git_oid *oid;
        const unsigned char *raw;

    CODE:
        raw = (const unsigned char *) SvPV_nolen(raw_sv);
        Newxz(oid, 1, git_oid);
        /* FIXME there's probably a memory leak or memory corruption here as
           git_oid_mkraw() expects a const string. I suspect that the library
           will simply point to the 'raw' pointer which will be freed by Perl.
         */
        git_oid_mkraw(oid, raw);
        GIT2PERL_BLESS(oid);

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
