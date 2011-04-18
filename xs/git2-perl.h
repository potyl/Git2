#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <xs_object_magic.h>

#include <git2.h>

#define GIT2PERL_CALL_BOOT(name)  git2perl_call_xs(aTHX_ name, cv, mark);

void
git2perl_call_xs (pTHX_ XSPROTO(subaddr), CV *cv, SV **mark);

void
git2perl_croak_error (signed char code);

const char*
git2perl_message_error (signed char code);

#define git_repository_class git_repository
#define git_odb_class        git_odb
#define git_oid_class        git_oid


#define GIT2PERL_BLESS(obj)                         \
do {                                                \
    SV *self;                                       \
                                                    \
    self = (SV *)newHV();                           \
    RETVAL = newRV_noinc(self);                     \
    sv_bless(RETVAL, gv_stashsv(class, 0));         \
    xs_object_magic_attach_struct(aTHX_ self, obj); \
} while (0)

#define GIT2PERL_CROAK(code) if (code) { git2perl_croak_error(code); }
