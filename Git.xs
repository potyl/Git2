#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <git2.h>

MODULE = Git  PACKAGE = Git::Repository  PREFIX = git_repository_


SV*
git_repository_open(const char *path)
    
	PREINIT:
		git_repository *repo = NULL;
        int code;

	CODE:
		
        code = git_repository_open(&repo, path);
        if (code) {
            croak("Error with code %d", code);
            repo = NULL;
        }
        RETVAL = repo;

	OUTPUT:
		RETVAL



void
DESTROY(git_repository *repo)
    CODE:
        git_repository_free(repo);
