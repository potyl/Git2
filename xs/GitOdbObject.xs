#include "git2-perl.h"


MODULE = Git2::Odb::Object  PACKAGE = Git2::Odb::Object  PREFIX = git_odb_object_


void
git_odb_object_close(git_odb_object *obj)


SV*
git_odb_object_id(git_odb_object *obj)
	PREINIT:
		const git_oid *oid;
		git_oid *dup;

	CODE:
		oid = git_odb_object_id(obj);
		Newxz(dup, 1, git_oid);
		git_oid_cpy(dup, oid);
		GIT2PERL_BLESS_FROM_CLASSNAME(dup, "Git2::Oid");

	OUTPUT:
		RETVAL