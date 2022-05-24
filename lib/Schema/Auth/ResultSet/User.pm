package Schema::Auth::ResultSet::User;

use strict; use warnings;

use base 'DBIx::Class::ResultSet';

sub users_by_role {
    my ($self, $role) = @_;

    return $self->search_rs(
        { 'role.role' => $role },
        { join        => { user_roles => 'role' },
    });
}

sub users_with_roles {
    my ($self, $search) = @_;

    return $self->search_rs(
        $search,
        { prefetch => { user_roles => 'role' } },
    );
}

1;