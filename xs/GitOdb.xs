#include "git2-perl.h"


MODULE = Git2::Odb  PACKAGE = Git2::Odb  PREFIX = git_odb_


SV*
git_odb_new(SV *class)
	PREINIT:
		git_odb *odb = NULL;
        int code;
        SV *self;

	CODE:
        code = git_odb_new(&odb);
        GIT2PERL_CROAK(code);
        GIT2PERL_BLESS_FROM_CLASS_SV(odb, class);

	OUTPUT:
		RETVAL


SV*
git_odb_open(SV *class, const char *objects_dir)
	PREINIT:
		git_odb *odb = NULL;
        int code;

	CODE:
        code = git_odb_open(&odb, objects_dir);
        GIT2PERL_CROAK(code);
        GIT2PERL_BLESS_FROM_CLASS_SV(odb, class);

	OUTPUT:
		RETVAL


void
git_odb_close(git_odb *odb)
