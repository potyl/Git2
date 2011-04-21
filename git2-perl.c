#include "git2-perl.h"

#include <string.h>
#include <errno.h>


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
