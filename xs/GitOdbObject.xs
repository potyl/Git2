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


SV*
git_odb_object_data(git_odb_object *object)
	PREINIT:
		char *data_str;
		void *data;
		size_t size;

	CODE:
		data = git_odb_object_data(object);
		size = git_odb_object_size(object);
		RETVAL = newSVpv(data, size);

	OUTPUT:
		RETVAL


size_t
git_odb_object_size(git_odb_object *object)


int
git_odb_object_type(git_odb_object *object)
