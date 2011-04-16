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
            croak("Error with code %d", code);
            repo = NULL;
        }
        obj = (SV *)newHV();
        RETVAL = newRV_noinc(obj);
        sv_bless(RETVAL, gv_stashsv(class, 0));
        xs_object_magic_attach_struct(aTHX_ obj, repo);

	OUTPUT:
		RETVAL



void
DESTROY(git_repository *repo)
    CODE:
        git_repository_free(repo);
