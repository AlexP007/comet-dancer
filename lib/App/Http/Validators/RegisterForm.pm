package App::Http::Validators::RegisterForm;

use strict;
use warnings;
use Moo;
use Data::FormValidator::Constraints qw(:closures);

with 'Dancer2::Plugin::FormValidator::Role::HasProfile', 'Dancer2::Plugin::FormValidator::Role::HasMessages';

sub profile {
    return {
        required => [qw(username email password password_cnf)],
        constraint_methods => {
            username => FV_length_between(4, 25),
            email    => email,
            password => FV_eq_with('password_cnf')
        },
    };
};

sub messages {
    return {
        username => '%s length should be 4 to 25 characters',
        email    => '%s should be a valid email address',
        password => '%s and password confirmation should match',
    };
}

1;
