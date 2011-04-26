#include "git2-perl.h"


MODULE = Git2::Object  PACKAGE = Git2::Object  PREFIX = git_object_


SV*
git_object_id(git_object *obj)
	PREINIT:
		const git_oid *oid;

	CODE:
		oid = git_object_id(obj);
		GIT2PERL_BLESS_FROM_CLASSNAME(oid, "Git2::Oid");
