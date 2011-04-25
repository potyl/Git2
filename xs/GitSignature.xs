#include "git2-perl.h"

/* Taken from perl-Glib */
#if defined(_MSC_VER)
# if _MSC_VER >= 1300
#  define PORTABLE_STRTOLL(str, end, base) _strtoi64 (str, end, base)
# else
#  define PORTABLE_STRTOLL(str, end, base) _atoi64 (str)
# endif
#else
# define PORTABLE_STRTOLL(str, end, base) strtoll (str, end, base)
#endif


git_time_t
SvGitTime (SV *sv) {
#ifdef USE_64_BIT_ALL
	return SvIV(sv);
#else
	return PORTABLE_STRTOLL(SvPV_nolen(sv), NULL, 10);
#endif
}


SV*
newSVGitTime (git_time_t value) {
#ifdef USE_64_BIT_ALL
	return newSViv (value);
#else
	char string[25];
	STRLEN length;
	SV *sv;

	/* newSVpvf doesn't seem to work correctly.
	sv = newSVpvf (PORTABLE_LL_FORMAT, value); */
	length = sprintf(string, PORTABLE_LL_FORMAT, value);
	sv = newSVpv (string, length);

	return sv;
#endif
}


MODULE = Git2::Signature  PACKAGE = Git2::Signature  PREFIX = git_signature_


SV*
git_signature_new (SV *class, const char *name, const char *email, git_time_t time, int offset)
    PREINIT:
        git_signature *sig;

    CODE:
        sig = git_signature_new(name, email, time, offset);
        GIT2PERL_BLESS_FROM_CLASS_SV(sig, class);

	OUTPUT:
		RETVAL


SV*
git_signature_now (SV *class, const char *name, const char *email)
    PREINIT:
        git_signature *sig;

    CODE:
        sig = git_signature_now(name, email);
        GIT2PERL_BLESS_FROM_CLASS_SV(sig, class);

	OUTPUT:
		RETVAL


SV*
git_signature_dup (git_signature *sig)
    PREINIT:
        git_signature *dup;

    CODE:
        dup = git_signature_dup(sig);
        GIT2PERL_BLESS_FROM_SV(dup, ST(0));

	OUTPUT:
		RETVAL


void
DESTROY(git_signature *sig)
    CODE:
        git_signature_free(sig);
