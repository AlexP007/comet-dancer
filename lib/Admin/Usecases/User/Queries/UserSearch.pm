package Admin::Usecases::User::Queries::UserSearch;

use strict; use warnings;

use Moo;
use Types::Standard qw(InstanceOf Maybe Str Bool);
use namespace::clean;

has rset => (
    is       => 'ro',
    isa      => InstanceOf['Schema::Auth::ResultSet::User'],
    required => 1,
);

has role => (
    is       => 'ro',
    isa      => Maybe[Str],
);

has active => (
    is       => 'ro',
    isa      => Maybe[Bool],
);

has search_phrase => (
    is       => 'ro',
    isa      => Maybe[Str],
);

sub invoke {
    my ($self) = @_;

    my $rset = $self->rset->users_with_roles;

    if ($self->role) {
        my $username_rset = $self->rset->search_rs({
                'role.role' => $self->role,
            }, {
                join => { user_roles => 'role' },
            }
        );

        $rset = $rset->search_rs({
            username =>  {
                -in => $username_rset->get_column('username')->as_query,
            },
        });
    }

    if ($self->active eq '1' or $self->active eq '0') {
        $rset = $rset->search_rs({
            deleted => not $self->active,
        });
    }

    if (my $phrase = $self->search_phrase) {
        $rset = $rset->search_rs([
            { username => { -like => "%$phrase%" } },
            { name     => { -like => "%$phrase%" } },
            { email    => { -like => "%$phrase%" } },
        ]);
    }

    return $rset;
}

1;
