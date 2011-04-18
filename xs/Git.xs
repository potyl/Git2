#include "git2-perl.h"

EXTERN_C XS(boot_Git2__Repository);
EXTERN_C XS(boot_Git2__Odb);
EXTERN_C XS(boot_Git2__Oid);

MODULE = Git2  PACKAGE = Git2


BOOT:
    GIT2PERL_CALL_BOOT (boot_Git2__Repository);
    GIT2PERL_CALL_BOOT (boot_Git2__Odb);
    GIT2PERL_CALL_BOOT (boot_Git2__Oid);
