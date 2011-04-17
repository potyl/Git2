#include "git2-perl.h"


MODULE = Git2::Repository  PACKAGE = Git2::Repository  PREFIX = git_repository_


SV*
git_repository_open(SV *class, const char *path)
	PREINIT:
		git_repository *repo = NULL;
        int code;
        SV *obj;

	CODE:
        code = git_repository_open(&repo, path);
        if (code) {
            git2perl_croak_error(code);
        }
        obj = (SV *)newHV();
        RETVAL = newRV_noinc(obj);
        sv_bless(RETVAL, gv_stashsv(class, 0));
        xs_object_magic_attach_struct(aTHX_ obj, repo);

	OUTPUT:
		RETVAL


NO_OUTPUT int
git_repository_init(SV *class, OUTLIST git_repository *repo, const char *path, unsigned is_bare)
    C_ARGS: &repo, path, is_bare

	POSTCALL:
        if (RETVAL) {
            git2perl_croak_error(RETVAL);
        }


void
DESTROY(git_repository *repo)
    CODE:
        git_repository_free(repo);
