use 5.010001;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Git',
    VERSION_FROM      => 'lib/Git.pm', # finds $VERSION
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
    LIBS              => ['-lgit2'], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'

    mm_args(),

);

sub mm_args {
    my ( @object, %xs );

    for my $xs ( glob "xs/*.xs" ) {
        ( my $c = $xs ) =~ s/\.xs$/.c/i;
        ( my $o = $xs ) =~ s/\.xs$/\$(OBJ_EXT)/i;

        $xs{$xs} = $c;
        push @object, $o;
    }

    for my $c ( glob "*.c" ) {
        ( my $o = $c ) =~ s/\.c$/\$(OBJ_EXT)/i;
        push @object, $o;
    }

    return (
        clean   => { FILES => join( q{ }, @object ) },
        OBJECT => join( q{ }, @object ),
        XS     => \%xs,
    );
}
