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
git_odb_object_close(git_odb *odb)
	PREINIT:
//		git_odb *odb;
        int code;

	INIT:
//        odb = (git_odb *) xs_object_magic_get_struct_rv(aTHX_ self);

	CODE:
        git_odb_object_close(odb);
