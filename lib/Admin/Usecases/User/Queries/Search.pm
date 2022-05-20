package Admin::Usecases::User::Queries::Search;

use strict; use warnings;

use Dancer2 appname  =>'Admin';

use Moo;
use Types::Standard qw(Maybe Str Bool);
use Dancer2::Plugin::DBIC;
use namespace::clean;

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

    my $rset = rset('User')->users_with_roles;

    if ($self->role) {
        my $username_rset = rset('User')->search_rs({
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

    if ($self->active) {
        my $deleted = $self->active != 1;

        $rset = $rset->search_rs({
            deleted => $deleted,
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
