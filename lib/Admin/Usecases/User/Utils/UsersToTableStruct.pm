package Admin::Usecases::User::Utils::UsersToTableStruct;

use strict; use warnings;
use feature qw(signatures);

use Moo;
use Types::Standard qw(ArrayRef InstanceOf Dict Str);
no warnings qw(experimental::signatures);
use namespace::clean;

has users => (
    is       => 'ro',
    isa      => ArrayRef[InstanceOf['Schema::Auth::Result::User']],
    required => 1,
);

has routes => (
    is       => 'ro',
    isa      => Dict[
        user_edit       => Str,
        user_activate   => Str,
        user_deactivate => Str,
    ],
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
                    route   => $self->_route('user_edit', $_->username)
                },
                {
                    name    => 'deactivate',
                    type    => 'form',
                    confirm => {
                        heading => 'Are you sure?',
                        message => sprintf('User: %s will be deactivated.', $_->username),
                    },
                    route   => $self->_route('user_deactivate', $_->username)
                },
            ] : [
                {
                    name    => 'activate',
                    type    => 'form',
                    confirm => {
                        heading => 'Are you sure?',
                        message => sprintf('User: %s will be activated.', $_->username),
                    },
                    route   => $self->_route('user_activate', $_->username)
                },
            ],
        }
    } @{ $self->users };

    return \@rows
}

sub _route($self, $route, $id) {
    return sprintf($self->routes->{$route}, $id);
}

1;
