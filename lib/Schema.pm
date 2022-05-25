package Schema;

use strict; use warnings;
use parent qw(DBIx::Class::Schema);

our $VERSION = 2;

__PACKAGE__->load_namespaces(
    result_namespace    => [ 'Auth::Result' ],
    resultset_namespace => [ 'Auth::ResultSet' ],
);

1;
