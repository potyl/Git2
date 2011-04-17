#include "git2-perl.h"
#include <string.h>

void
git2perl_call_xs (pTHX_ XSPROTO(subaddr), CV *cv, SV **mark)
{
    dSP;
    PUSHMARK(mark);
    (*subaddr)(aTHX_ cv);
    PUTBACK;
}


void
git2perl_croak_error (signed char code) {
    const char* message = git2perl_message_error(code);
    croak("Git library error: %s (code: %d)", message, code);
}


const char*
git2perl_message_error (signed char code) {

    const char* message;
    switch (code) {
        case GIT_SUCCESS:
            message = "Operation completed successfully.";
        break;

        case GIT_ERROR:
            message = "Operation failed, with unspecified reason.";
        break;

        case GIT_ENOTOID:
            message = "object ID not well formed";
        break;

        case GIT_ENOTFOUND:
            message = "not found";
        break;

        case GIT_ENOMEM:
            message = "out of space";
        break;

        case GIT_EOSERR:
            if (errno > sys_nerr-1) {
	            message = "unknown OS error";
            }
            else {
	            message = strerror(errno);
            };
        break;

        case GIT_EOBJTYPE:
            message = "invalid object type";
        break;

        case GIT_EOBJCORRUPTED:
            message = "object data corrupted";
        break;

        case GIT_ENOTAREPO:
            message = "not a git repo";
        break;

        case GIT_EINVALIDTYPE:
            message = "object type mismatch";
        break;

        case GIT_EMISSINGOBJDATA:
            message = "object required field missing";
        break;

        case GIT_EPACKCORRUPTED:
            message = "packfile corrupt";
        break;

        case GIT_EFLOCKFAIL:
            message = "failed to acquire lock";
        break;

        case GIT_EZLIB:
            message = "zlib failure";
        break;

        case GIT_EBUSY:
            message = "object busy";
        break;

        case GIT_EBAREINDEX:
            message = "The index file is not backed up by an existing repository.";
        break;

        default:
            message = "unknown error";
        break;
    }
    return message;
}
