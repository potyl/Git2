#include "git2-perl.h"


MODULE = Git2::Repository  PACKAGE = Git2::Repository  PREFIX = git_repository_


NO_OUTPUT int
git_repository_open(SV *class, OUTLIST git_repository_class *repo, const char *path)
    C_ARGS: &repo, path

	POSTCALL:
        if (RETVAL) {
            git2perl_croak_error(RETVAL);
        }


NO_OUTPUT int
git_repository_init(SV *class, OUTLIST git_repository_class *repo, const char *path, unsigned is_bare)
    C_ARGS: &repo, path, is_bare

	POSTCALL:
        if (RETVAL) {
            git2perl_croak_error(RETVAL);
        }


git_odb*
git_repository_database (git_repository *repo)


void
DESTROY(git_repository *repo)
    CODE:
        git_repository_free(repo);
