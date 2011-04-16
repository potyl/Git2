use 5.010001;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Git',
    VERSION_FROM      => 'lib/Git.pm', # finds $VERSION
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
    LIBS              => [''], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
);
