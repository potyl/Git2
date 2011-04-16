#include "git2-perl.h"

EXTERN_C XS(boot_Git2__Repository);

MODULE = Git2  PACKAGE = Git2


BOOT:
    GIT2PERL_CALL_BOOT (boot_Git2__Repository);
