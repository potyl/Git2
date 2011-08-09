#include "git2-perl.h"


MODULE = Git2::Object  PACKAGE = Git2::Object  PREFIX = git_object_


const git_oid*
git_object_id(git_object *object)


int
git_object_type(git_object *object)


const git_repository*
git_object_owner(git_object *object)


char*
git_object_type2string(class, int type)
    C_ARGS: type


int
git_object_string2type(class, char *str)
    C_ARGS: str


int
git_object_typeisloose(class, int type)
    C_ARGS: type

int
git_object__size(class, int type)
    C_ARGS: type


void
DESTROY(git_object *object)
    CODE:
        git_object_close(object);