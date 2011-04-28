#include "git2-perl.h"


MODULE = Git2::Object  PACKAGE = Git2::Object  PREFIX = git_object_


git_oid*
git_object_id(git_object *obj)
