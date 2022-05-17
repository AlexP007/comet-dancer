package Schema::Auth::ResultSet::User;

use strict;
use warnings FATAL => 'all';

use base 'DBIx::Class::ResultSet';

sub users_with_roles {
    my ($self, %args) = @_;

    my $page = $args{page} || 1;
    my $size = $args{size} || 10;

    return $self->search({}, {
        prefetch => { user_roles => 'role' },
        select   => [ qw(username name lastlogin email deleted) ],
        page     => $page,
        rows     => $size,
    })->all;
}

1;