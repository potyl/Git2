use strict;
use warnings;

use ExtUtils::MakeMaker;


sub main {
    mkdir 'build', 0777;

    WriteMakefile(
        NAME          => 'Git',
        VERSION_FROM  => 'lib/Git.pm',
        INC           => '-Ixs -I.',
        LIBS          => ['-lgit2'],
        DEFINE        => '',
    );
}


exit main() unless caller;
