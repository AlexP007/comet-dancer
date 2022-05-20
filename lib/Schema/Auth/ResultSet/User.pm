package Schema::Auth::ResultSet::User;

use strict;
use warnings FATAL => 'all';

use base 'DBIx::Class::ResultSet';

sub users_with_roles {
    my ($self, %args) = @_;

    return $self->search_rs(
        $args{search},
        {
            prefetch => { user_roles => 'role' },
            page     => $args{page},
            rows     => $args{size},
        }
    );
}

1;