#include "git2-perl.h"


MODULE = Git2::Commit  PACKAGE = Git2::Commit  PREFIX = git_commit_


const char*
git_commit_message_short(git_commit *commit)


git_time_t
git_commit_time (git_commit *commit)


int
git_commit_time_offset (git_commit *commit)


const git_oid*
git_commit_tree_oid (git_commit *commit)


unsigned int
git_commit_parentcount (git_commit *commit)


const git_oid*
git_commit_parent_oid  (git_commit *commit, unsigned int n)


const git_oid*
git_commit_id (git_commit *commit)


const char *
git_commit_message (git_commit *commit)


SV*
git_commit_parent (git_commit *commit, unsigned int n)
	PREINIT:
		git_commit *parent = NULL;
		int code;

	CODE:
		code = git_commit_parent(&parent, commit, n);
		GIT2PERL_CROAK(code);
		GIT2PERL_BLESS_FROM_CLASSNAME(parent, "Git2::Commit");

	OUTPUT:
		RETVAL


void
DESTROY (git_commit *commit)
	CODE:
		git_commit_close(commit);
