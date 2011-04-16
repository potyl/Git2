use strict;
use warnings;

use ExtUtils::MakeMaker;


sub main {
    mkdir 'build', 0777;

    WriteMakefile(
        AUTHOR     => 'Emo',
        NAME       => 'Git',
        XSPROTOARG => '-noprototypes ',
        TYPEMAPS   => ['typemap'],
        INC        => '',
        LIBS       => '-lgit2',
        
    );
}


exit main() unless caller;
