#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include <xs_object_magic.h>
#include <git2.h>

#define GIT2PERL_CALL_BOOT(name)  git2perl_call_xs(aTHX_ name, cv, mark);

#define git_repository_class git_repository
#define git_odb_class        git_odb
#define git_oid_class        git_oid
#define git_oid_nofree       git_oid

#define GIT2PERL_BLESS_FROM_HV(obj, hv)              \
do {                                                 \
    SV *_self;                                       \
                                                     \
    _self = (SV *) newHV();                          \
    RETVAL = newRV_noinc(_self);                     \
    sv_bless(RETVAL, hv);                            \
    xs_object_magic_attach_struct(aTHX_ _self, obj); \
} while (0)
#define GIT2PERL_BLESS_FROM_SV(obj, sv)                GIT2PERL_BLESS_FROM_CLASSNAME(obj, sv_reftype(SvRV(sv), 1))
#define GIT2PERL_BLESS_FROM_CLASSNAME(obj, classname)  GIT2PERL_BLESS_FROM_HV(obj, gv_stashpv(classname, 0))
#define GIT2PERL_BLESS_FROM_CLASS_SV(obj, sv)          GIT2PERL_BLESS_FROM_HV(obj, gv_stashsv(sv, 0))

#define GIT2PERL_CROAK(code) if (code) { git2perl_croak_error(code); }


void
git2perl_call_xs (pTHX_ XSPROTO(subaddr), CV *cv, SV **mark);

void
git2perl_croak_error (signed char code);

const char*
git2perl_message_error (signed char code);

git_time_t
git2perl_sv2time (SV *sv);

SV*
git2perl_time2sv (git_time_t value);
