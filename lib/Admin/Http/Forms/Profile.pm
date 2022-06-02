package Admin::Http::Forms::Profile;

use v5.36;

use Moo;
use Types::Standard qw(Str Bool);
use namespace::clean;

with 'Dancer2::Plugin::FormValidator::Role::ProfileHasMessages';

has current_email => (
    is        => 'ro',
    isa       => Str,
    predicate => 1,
);

sub profile {
    return {
        name         => [ qw(length_min:1 length_max:127) ],
        email        => [ qw(required email length_max:127) ],
        password     => [ qw(password_simple length_max:40) ],
        password_cnf => [ qw(required_with:password same:password) ],
    };
}

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
