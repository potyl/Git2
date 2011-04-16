#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"


#include <git2.h>

#define GIT2PERL_CALL_BOOT(name)  git2perl_call_xs(aTHX_ name, cv, mark);

void
git2perl_call_xs (pTHX_ XSPROTO(subaddr), CV *cv, SV **mark);
