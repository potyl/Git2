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
        if (code) {
            git2perl_croak_error(code);
        }
        self = (SV *)newHV();
        xs_object_magic_attach_struct(aTHX_ self, odb);

        RETVAL = newRV_noinc(self);
        sv_bless(RETVAL, gv_stashsv(class, 0));

	OUTPUT:
		RETVAL


void
git_odb_close(git_odb *odb)
	PREINIT:
        int code;

	CODE:
        git_odb_close(odb);
