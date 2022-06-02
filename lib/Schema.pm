package Schema;

use v5.36;

use parent qw(DBIx::Class::Schema);

our $VERSION = 2;

__PACKAGE__->load_namespaces(
    result_namespace    => [ 'User::Result' ],
    resultset_namespace => [ 'User::ResultSet' ],
);

1;
