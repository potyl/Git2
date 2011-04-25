#include "git2-perl.h"


MODULE = Git2::Repository  PACKAGE = Git2::Repository  PREFIX = git_repository_


NO_OUTPUT int
git_repository_open(SV *class, OUTLIST git_repository_class *repo, const char *path)
    C_ARGS: &repo, path

	POSTCALL:
        GIT2PERL_CROAK(RETVAL);


NO_OUTPUT int
git_repository_init(SV *class, OUTLIST git_repository_class *repo, const char *path, unsigned is_bare)
    C_ARGS: &repo, path, is_bare

	POSTCALL:
        GIT2PERL_CROAK(RETVAL);


git_odb*
git_repository_database (git_repository *repo)


void
DESTROY(git_repository *repo)
    CODE:
        git_repository_free(repo);
