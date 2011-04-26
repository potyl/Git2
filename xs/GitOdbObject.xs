#include "git2-perl.h"


MODULE = Git2::Odb::Object  PACKAGE = Git2::Odb::Object  PREFIX = git_odb_object_


void
git_odb_object_close(git_odb_object *obj)
