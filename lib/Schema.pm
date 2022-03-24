package Schema;

use strict;
use warnings;
use parent qw(DBIx::Class::Schema);

our $VERSION = '0.1';

__PACKAGE__->load_namespaces(
    result_namespace => ['Auth::Result']
);

1;
