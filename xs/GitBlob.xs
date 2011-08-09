#include "git2-perl.h"


MODULE = Git2::Blob  PACKAGE = Git2::Blob  PREFIX = git_blob_


SV*
git_blob_rawcontent(git_blob *blob)
    PREINIT:
        const void *data;
        int size;

    CODE:
        data = git_blob_rawcontent(blob);
        size = git_blob_rawsize(blob);
        RETVAL = newSVpv(data, size);

    OUTPUT:
        RETVAL


int
git_blob_rawsize(git_blob *blob)
