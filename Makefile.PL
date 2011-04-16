use strict;
use warnings;

use ExtUtils::MakeMaker;


sub main {
    mkdir 'build', 0777;

    WriteMakefile(
        NAME          => 'Git',
        VERSION_FROM  => 'lib/Git.pm',
        INC           => '-Ixs',
        LIBS          => '-lgit2',
        DEFINE        => '',
        XS            => {
            'xs/GitRepository.xs' => 'xs/GitRepository.c',
        },
    );
}


exit main() unless caller;
