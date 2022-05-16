package Admin::Http::Forms::UserForm;

use strict; use warnings;

use Moo;
use Types::Standard qw(Str Bool);
use namespace::clean;

with 'Dancer2::Plugin::FormValidator::Role::ProfileHasMessages';

has require_username => (
    is       => 'ro',
    isa      => Bool,
    required => 1,
);

has require_password => (
    is       => 'ro',
    isa      => Bool,
    required => 1,
);

has current_email => (
    is        => 'ro',
    isa       => Str,
    predicate => 1,
);

sub profile {
    my ($self) = @_;

    no warnings 'qw';

    my %profile = (
        username     => [ qw(alpha_num length_min:4 length_max:32 unique:User,username) ],
        name         => [ qw(length_min:1 length_max:128) ],
        email        => [ qw(required email length_max:127) ],
        password     => [ qw(password_simple length_max:40) ],
        password_cnf => [ qw(required_with:password same:password) ],
        roles        => [ qw(required) ]
    );

    if ($self->require_username) {
        unshift @{ $profile{username} }, 'required';
    }

    if ($self->require_password) {
        unshift @{ $profile{password} }, 'required';
    }

    return \%profile;
};

around hook_before => sub {
    my ($orig, $self, $profile, $input) = @_;

    # User creation.
    # If email not equals current user email, add unique validator for it.
    if (
        $self->has_current_email
        and $input->{email} ne $self->current_email
    ) {
        push @{ $profile->{email} }, 'unique:User,email';
    }

    return $orig->($self, $profile, $input);
};

sub messages {
    return {
        email => {
            unique => {
                'en' => 'This email is not allowed, please try another one'
            }
        },
        password_cnf => {
            required_with => {
                en => 'Confirm Password is required',
            },
            same => {
                en => 'Confirm Password must be the same as Password',
            },
        }
    }
}

1;
