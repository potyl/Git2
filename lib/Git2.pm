package Git2;

use strict;
use warnings;
use XS::Object::Magic;

our $VERSION = '1.0';

require XSLoader;
XSLoader::load('Git2', $VERSION);

1;
