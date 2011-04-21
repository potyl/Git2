#include "git2-perl.h"

EXTERN_C XS(boot_Git2__Repository);
EXTERN_C XS(boot_Git2__Odb);
EXTERN_C XS(boot_Git2__Oid);


MODULE = Git2  PACKAGE = Git2


BOOT:
    GIT2PERL_CALL_BOOT (boot_Git2__Repository);
    GIT2PERL_CALL_BOOT (boot_Git2__Odb);
    GIT2PERL_CALL_BOOT (boot_Git2__Oid);


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
                RETVAL = &PL_sv_undef;
                croak("Unknow value %d", ix);
            break;
        }

    OUTPUT:
        RETVAL


int
GIT_SUCCESS ()
    ALIAS:
        GIT_SUCCESS = 0
        GIT_ERROR = 1
        GIT_ENOTOID = 2
        GIT_ENOTFOUND = 3
        GIT_ENOMEM = 4
        GIT_EOSERR = 5
        GIT_EOBJTYPE = 6
        GIT_EOBJCORRUPTED = 7
        GIT_ENOTAREPO = 8
        GIT_EINVALIDTYPE = 9
        GIT_EMISSINGOBJDATA = 10
        GIT_EPACKCORRUPTED = 11
        GIT_EFLOCKFAIL = 12
        GIT_EZLIB = 13
        GIT_EBUSY = 14
        GIT_EBAREINDEX = 15
        GIT_EINVALIDREFNAME = 16
        GIT_EREFCORRUPTED  = 17
        GIT_ETOONESTEDSYMREF = 18
        GIT_EPACKEDREFSCORRUPTED = 19
        GIT_EINVALIDPATH = 20
        GIT_EREVWALKOVER = 21
        GIT_EINVALIDREFSTATE = 22
        GIT_ENOTIMPLEMENTED = 23
        GIT_EEXISTS = 24
        GIT_EOVERFLOW = 25
        GIT_ENOTNUM = 26

    CODE:
        switch (ix) {
            case  0: RETVAL = GIT_SUCCESS; break;
            case  1: RETVAL = GIT_ERROR; break;
            case  2: RETVAL = GIT_ENOTOID; break;
            case  3: RETVAL = GIT_ENOTFOUND; break;
            case  4: RETVAL = GIT_ENOMEM; break;
            case  5: RETVAL = GIT_EOSERR; break;
            case  6: RETVAL = GIT_EOBJTYPE; break;
            case  7: RETVAL = GIT_EOBJCORRUPTED; break;
            case  8: RETVAL = GIT_ENOTAREPO; break;
            case  9: RETVAL = GIT_EINVALIDTYPE; break;
            case 10: RETVAL = GIT_EMISSINGOBJDATA; break;
            case 11: RETVAL = GIT_EPACKCORRUPTED; break;
            case 12: RETVAL = GIT_EFLOCKFAIL; break;
            case 13: RETVAL = GIT_EZLIB; break;
            case 14: RETVAL = GIT_EBUSY; break;
            case 15: RETVAL = GIT_EBAREINDEX; break;
            case 16: RETVAL = GIT_EINVALIDREFNAME; break;
            case 17: RETVAL = GIT_EREFCORRUPTED ; break;
            case 18: RETVAL = GIT_ETOONESTEDSYMREF; break;
            case 19: RETVAL = GIT_EPACKEDREFSCORRUPTED; break;
            case 20: RETVAL = GIT_EINVALIDPATH; break;
            case 21: RETVAL = GIT_EREVWALKOVER; break;
            case 22: RETVAL = GIT_EINVALIDREFSTATE; break;
            case 23: RETVAL = GIT_ENOTIMPLEMENTED; break;
            case 24: RETVAL = GIT_EEXISTS; break;
            case 25: RETVAL = GIT_EOVERFLOW; break;
            case 26: RETVAL = GIT_ENOTNUM; break;
            default:
                RETVAL = &PL_sv_undef;
                croak("Unknow value %d", ix);
            break;
        }

    OUTPUT:
        RETVAL
