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
