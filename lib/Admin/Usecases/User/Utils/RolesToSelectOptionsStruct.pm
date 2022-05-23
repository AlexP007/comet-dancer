package Admin::Usecases::User::Utils::RolesToSelectOptionsStruct;

use strict; use warnings;
use feature qw(signatures);

use Moo;
use Types::Standard qw(InstanceOf ArrayRef);
use List::Util qw(any);
no warnings qw(experimental::signatures);
use namespace::clean;

has roles => (
    is        => 'ro',
    isa       => ArrayRef[InstanceOf['Schema::Auth::Result::Role']],
    required  => 1,
);

has selected => (
    is        => 'ro',
    isa       => ArrayRef,
    predicate => 1,
);

sub invoke($self) {
    my @roles = map {
        {
            text     => $_->role,
            value    => $_->role,
            selected => $self->_set_selected($_->role),
        }
    } @{ $self->roles };

    return \@roles;
}

sub _set_selected($self, $role) {
    return $self->has_selected
        ? any { $_ eq $role } @{ $self->selected }
        : undef;
}

1;