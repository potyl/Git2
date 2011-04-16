#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <git2.h>

MODULE = Git::Repository  PACKAGE = Git::Repository  PREFIX = git_repository_


int
git_repository_open(git_repository **repository, const char *path)
 	C_ARGS: path
