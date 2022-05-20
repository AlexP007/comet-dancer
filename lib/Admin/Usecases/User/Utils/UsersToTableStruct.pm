package Admin::Usecases::User::Utils::UsersToTableStruct;

use strict; use warnings;
use feature qw(signatures);

use Moo;
use Types::Standard qw(ArrayRef InstanceOf CodeRef);
no warnings qw(experimental::signatures);
use namespace::clean;

has users => (
    is       => 'ro',
    isa      => ArrayRef[InstanceOf['Schema::Auth::Result::User']],
    required => 1,
);

has route => (
    is       => 'ro',
    isa      => CodeRef,
    required => 1,
);

sub invoke($self) {
    my @rows = map {
        {
            id      => $_->username,
            data    => [
                { value => $_->username,   type => 'text'   },
                { value => $_->email,      type => 'text'   },
                { value => $_->name,       type => 'text'   },
                { value => $_->active,     type => 'toggle' },
                { value => $_->role_names, type => 'list'   },
            ],
            actions => $_->active ? [
                {
                    name    => 'edit',
                    type    => 'link',
                    route   => $self->route->('user_edit', $_->username)
                },
                {
                    name    => 'deactivate',
                    type    => 'form',
                    confirm => {
                        heading => 'Are you sure?',
                        message => sprintf('User: %s will be deactivated.', $_->username),
                    },
                    route   => $self->route->('user_deactivate', $_->username)
                },
            ] : [
                {
                    name    => 'activate',
                    type    => 'form',
                    confirm => {
                        heading => 'Are you sure?',
                        message => sprintf('User: %s will be activated.', $_->username),
                    },
                    route   => $self->route->('user_activate', $_->username)
                },
            ],
        }
    } @{ $self->users };

    return \@rows
}

1;
