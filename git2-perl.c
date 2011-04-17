#include "git2-perl.h"

#include <string.h>
#include <errno.h>


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
            message = "Input was not a properly formatted Git object id.";
        break;

        case GIT_ENOTFOUND:
            message = "Input does not exist in the scope searched.";
        break;

        case GIT_ENOMEM:
            message = "Not enough space available.";
        break;

        case GIT_EOSERR:
            if (errno > sys_nerr - 1) {
                message = "Consult the OS error information.";
            }
            else {
                message = strerror(errno);
            };
        break;

        case GIT_EOBJTYPE:
            message = "The specified object is of invalid type.";
        break;

        case GIT_EOBJCORRUPTED:
            message = "The specified object has its data corrupted.";
        break;

        case GIT_ENOTAREPO:
            message = "The specified repository is invalid.";
        break;

        case GIT_EINVALIDTYPE:
            message = "The object type is invalid or doesn't match.";
        break;

        case GIT_EMISSINGOBJDATA:
            message = "The object cannot be written because it's missing internal data.";
        break;

        case GIT_EPACKCORRUPTED:
            message = "The packfile for the ODB is corrupted.";
        break;

        case GIT_EFLOCKFAIL:
            message = "Failed to acquire or release a file lock.";
        break;

        case GIT_EZLIB:
            message = "The Z library failed to inflate/deflate an object's data.";
        break;

        case GIT_EBUSY:
            message = "The queried object is currently busy.";
        break;

        case GIT_EBAREINDEX:
            message = "The index file is not backed up by an existing repository.";
        break;

        case GIT_EINVALIDREFNAME:
            message = "The name of the reference is not valid.";
        break;

        case GIT_EREFCORRUPTED:
            message = "The specified reference has its data corrupted.";
        break;

        case GIT_ETOONESTEDSYMREF:
            message = "The specified symbolic reference is too deeply nested.";
        break;

        case GIT_EPACKEDREFSCORRUPTED:
            message = "The pack-refs file is either corrupted or its format is not currently supported.";
        break;

        case GIT_EINVALIDPATH:
            message = "The path is invalid.";
        break;

        case GIT_EREVWALKOVER:
            message = "The revision walker is empty; there are no more commits left to iterate.";
        break;

        case GIT_EINVALIDREFSTATE:
            message = "The state of the reference is not valid.";
        break;

        case GIT_ENOTIMPLEMENTED:
            message = "This feature has not been implemented yet.";
        break;
    }
    return message;
}
