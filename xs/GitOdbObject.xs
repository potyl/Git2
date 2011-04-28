#include "git2-perl.h"


MODULE = Git2::Odb::Object  PACKAGE = Git2::Odb::Object  PREFIX = git_odb_object_


void
git_odb_object_close(git_odb_object *obj)


SV*
git_odb_object_id(git_odb_object *obj)
	PREINIT:
		git_oid *oid;

	CODE:
		oid = git_odb_object_id(obj);
		GIT2PERL_BLESS_FROM_CLASSNAME(oid, "Git2::Oid::NoFree");

	OUTPUT:
		RETVAL