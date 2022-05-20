package Admin::Usecases::User::Queries::Search;

use strict; use warnings;

use Dancer2 appname  =>'Admin';

use Moo;
use Types::Standard qw(Str Int Bool Maybe);
use Dancer2::Plugin::DBIC;
use namespace::clean;

has page => (
    is       => 'ro',
    isa      => Int,
    required => 1,
);

has size => (
    is       => 'ro',
    isa      => Int,
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


    my $rset = rset('User')->users_with_roles(
        size => $self->size,
        page => $self->page,
    );

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

    if (defined $self->active) {
        my $deleted = not $self->active;

        $rset = $rset->search_rs({
            deleted => $deleted,
        });
    }

    return $rset;
}

1;
