#include "git2-perl.h"

EXTERN_C XS(boot_Git2__Repository);
EXTERN_C XS(boot_Git2__Odb);
EXTERN_C XS(boot_Git2__Oid);
EXTERN_C XS(boot_Git2__Oid__Shorten);
EXTERN_C XS(boot_Git2__Signature);
EXTERN_C XS(boot_Git2__Odb__Object);
EXTERN_C XS(boot_Git2__Object);
EXTERN_C XS(boot_Git2__Blob);
EXTERN_C XS(boot_Git2__Commit);


#define SWITCH_VALUE(val) case val: RETVAL = val; break


MODULE = Git2  PACKAGE = Git2 PREFIX = git_


BOOT:
    GIT2PERL_CALL_BOOT (boot_Git2__Repository);
    GIT2PERL_CALL_BOOT (boot_Git2__Odb);
    GIT2PERL_CALL_BOOT (boot_Git2__Oid);
    GIT2PERL_CALL_BOOT (boot_Git2__Oid__Shorten);
    GIT2PERL_CALL_BOOT (boot_Git2__Signature);
    GIT2PERL_CALL_BOOT (boot_Git2__Odb__Object);
    GIT2PERL_CALL_BOOT (boot_Git2__Object);
    GIT2PERL_CALL_BOOT (boot_Git2__Blob);
    GIT2PERL_CALL_BOOT (boot_Git2__Commit);


char*
VERSION ()
    CODE:
        RETVAL = LIBGIT2_VERSION;

    OUTPUT:
        RETVAL


int
VER_MAJOR ()
    ALIAS:
        VER_MAJOR    = 0
        VER_MINOR    = 1
        VER_REVISION = 2

    CODE:
        switch (ix) {
            case  0: RETVAL = LIBGIT2_VER_MAJOR; break;
            case  1: RETVAL = LIBGIT2_VER_MINOR; break;
            case  2: RETVAL = LIBGIT2_VER_REVISION; break;
            default:
                croak("Unknow value %d", ix);
            break;
        }

    OUTPUT:
        RETVAL


int
GIT_SUCCESS ()
    ALIAS:
        GIT_SUCCESS              = GIT_SUCCESS
        GIT_ERROR                = GIT_ERROR
        GIT_ENOTOID              = GIT_ENOTOID
        GIT_ENOTFOUND            = GIT_ENOTFOUND
        GIT_ENOMEM               = GIT_ENOMEM
        GIT_EOSERR               = GIT_EOSERR
        GIT_EOBJTYPE             = GIT_EOBJTYPE
        GIT_ENOTAREPO            = GIT_ENOTAREPO
        GIT_EINVALIDTYPE         = GIT_EINVALIDTYPE
        GIT_EMISSINGOBJDATA      = GIT_EMISSINGOBJDATA
        GIT_EPACKCORRUPTED       = GIT_EPACKCORRUPTED
        GIT_EFLOCKFAIL           = GIT_EFLOCKFAIL
        GIT_EZLIB                = GIT_EZLIB
        GIT_EBUSY                = GIT_EBUSY
        GIT_EBAREINDEX           = GIT_EBAREINDEX
        GIT_EINVALIDREFNAME      = GIT_EINVALIDREFNAME
        GIT_EREFCORRUPTED        = GIT_EREFCORRUPTED
        GIT_ETOONESTEDSYMREF     = GIT_ETOONESTEDSYMREF
        GIT_EPACKEDREFSCORRUPTED = GIT_EPACKEDREFSCORRUPTED
        GIT_EINVALIDPATH         = GIT_EINVALIDPATH
        GIT_EREVWALKOVER         = GIT_EREVWALKOVER
        GIT_EINVALIDREFSTATE     = GIT_EINVALIDREFSTATE
        GIT_ENOTIMPLEMENTED      = GIT_ENOTIMPLEMENTED
        GIT_EEXISTS              = GIT_EEXISTS
        GIT_EOVERFLOW            = GIT_EOVERFLOW
        GIT_ENOTNUM              = GIT_ENOTNUM
        GIT_ESTREAM              = GIT_ESTREAM
        GIT_EINVALIDARGS         = GIT_EINVALIDARGS
        GIT_EOBJCORRUPTED        = GIT_EOBJCORRUPTED
        GIT_EAMBIGUOUSOIDPREFIX  = GIT_EAMBIGUOUSOIDPREFIX
        GIT_EPASSTHROUGH         = GIT_EPASSTHROUGH
        GIT_ENOMATCH             = GIT_ENOMATCH
        GIT_ESHORTBUFFER         = GIT_ESHORTBUFFER

    CODE:
        switch (ix) {
            SWITCH_VALUE(GIT_SUCCESS);
            SWITCH_VALUE(GIT_ERROR);
            SWITCH_VALUE(GIT_ENOTOID);
            SWITCH_VALUE(GIT_ENOTFOUND);
            SWITCH_VALUE(GIT_ENOMEM);
            SWITCH_VALUE(GIT_EOSERR);
            SWITCH_VALUE(GIT_EOBJTYPE);
            SWITCH_VALUE(GIT_ENOTAREPO);
            SWITCH_VALUE(GIT_EINVALIDTYPE);
            SWITCH_VALUE(GIT_EMISSINGOBJDATA);
            SWITCH_VALUE(GIT_EPACKCORRUPTED);
            SWITCH_VALUE(GIT_EFLOCKFAIL);
            SWITCH_VALUE(GIT_EZLIB);
            SWITCH_VALUE(GIT_EBUSY);
            SWITCH_VALUE(GIT_EBAREINDEX);
            SWITCH_VALUE(GIT_EINVALIDREFNAME);
            SWITCH_VALUE(GIT_EREFCORRUPTED);
            SWITCH_VALUE(GIT_ETOONESTEDSYMREF);
            SWITCH_VALUE(GIT_EPACKEDREFSCORRUPTED);
            SWITCH_VALUE(GIT_EINVALIDPATH);
            SWITCH_VALUE(GIT_EREVWALKOVER);
            SWITCH_VALUE(GIT_EINVALIDREFSTATE);
            SWITCH_VALUE(GIT_ENOTIMPLEMENTED);
            SWITCH_VALUE(GIT_EEXISTS);
            SWITCH_VALUE(GIT_EOVERFLOW);
            SWITCH_VALUE(GIT_ENOTNUM);
            SWITCH_VALUE(GIT_ESTREAM);
            SWITCH_VALUE(GIT_EINVALIDARGS);
            SWITCH_VALUE(GIT_EOBJCORRUPTED);
            SWITCH_VALUE(GIT_EAMBIGUOUSOIDPREFIX);
            SWITCH_VALUE(GIT_EPASSTHROUGH);
            SWITCH_VALUE(GIT_ENOMATCH);
            SWITCH_VALUE(GIT_ESHORTBUFFER);
            default:
                croak("Unknow value %d", ix);
            break;
        }

    OUTPUT:
        RETVAL


int
GIT_OBJ_ANY ()
    ALIAS:
        GIT_OBJ_ANY        = GIT_OBJ_ANY
        GIT_OBJ_BAD        = GIT_OBJ_BAD
        GIT_OBJ__EXT1      = GIT_OBJ__EXT1
        GIT_OBJ_COMMIT     = GIT_OBJ_COMMIT
        GIT_OBJ_TREE       = GIT_OBJ_TREE
        GIT_OBJ_BLOB       = GIT_OBJ_BLOB
        GIT_OBJ_TAG        = GIT_OBJ_TAG
        GIT_OBJ__EXT2      = GIT_OBJ__EXT2
        GIT_OBJ_OFS_DELTA  = GIT_OBJ_OFS_DELTA
        GIT_OBJ_REF_DELTA  = GIT_OBJ_REF_DELTA

    CODE:
        switch (ix) {
            SWITCH_VALUE(GIT_OBJ_ANY);
            SWITCH_VALUE(GIT_OBJ_BAD);
            SWITCH_VALUE(GIT_OBJ__EXT1);
            SWITCH_VALUE(GIT_OBJ_COMMIT);
            SWITCH_VALUE(GIT_OBJ_TREE);
            SWITCH_VALUE(GIT_OBJ_BLOB);
            SWITCH_VALUE(GIT_OBJ_TAG);
            SWITCH_VALUE(GIT_OBJ__EXT2);
            SWITCH_VALUE(GIT_OBJ_OFS_DELTA);
            SWITCH_VALUE(GIT_OBJ_REF_DELTA);
            default:
                croak("Unknow value %d", ix);
            break;
        }

    OUTPUT:
        RETVAL


char*
git_strerror (class, int code)
    C_ARGS: code
