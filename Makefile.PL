use 5.010001;
use ExtUtils::MakeMaker;
use ExtUtils::Depends;

my $pkg = ExtUtils::Depends->new("Git2", "XS::Object::Magic");
$pkg->set_inc('-Ixs -I/opt/local/include -I/usr/local/include');
$pkg->set_libs('-lgit2 -L/opt/local/lib -L/usr/local/lib');

WriteMakefile(
    NAME              => 'Git2',
    VERSION_FROM      => 'lib/Git2.pm', # finds $VERSION

    mm_args(),
    $pkg->get_makefile_vars(),

    # Compile with debug symbols
    OPTIMIZE => '-g -O0',
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


{
package MY;

use Config;

sub const_cccmd {
    my $ret = shift->SUPER::const_cccmd(@_);
    return q{} unless $ret;

    if ($Config{cc} =~ /^cl\b/i) {
        warn 'you are using MSVC... my condolences.';
        $ret .= ' /Fo$@';
    }
    else {
        $ret .= ' -o $@';
    }

    return $ret;
}

}
