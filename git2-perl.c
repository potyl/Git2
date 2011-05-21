#include "git2-perl.h"

#include <string.h>
#include <errno.h>


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
git2perl_sv2time (SV *sv) {
#ifdef USE_64_BIT_ALL
	return SvIV(sv);
#else
	return PORTABLE_STRTOLL(SvPV_nolen(sv), NULL, 10);
#endif
}


SV*
git2perl_time2sv (git_time_t value) {
#ifdef USE_64_BIT_ALL
	return newSViv(value);
#else
	char string[25];
	STRLEN length;
	SV *sv;

	length = sprintf(string, PORTABLE_LL_FORMAT, value);
	sv = newSVpv(string, length);

	return sv;
#endif
}


void
git2perl_call_xs (pTHX_ XSPROTO(subaddr), CV *cv, SV **mark)
{
    dSP;
    PUSHMARK(mark);
    (*subaddr)(aTHX_ cv);
    PUTBACK;
}


void
git2perl_croak_error (signed char code) {
    croak("Git library error: %s (code: %d)", git_strerror(code), code);
}
