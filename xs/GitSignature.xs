#include "git2-perl.h"


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
