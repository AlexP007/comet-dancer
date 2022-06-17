package Admin::Forms::Profile;

use v5.36;

use Moo;
use Types::Standard qw(Str Bool);
use namespace::clean;

with 'Dancer2::Plugin::FormValidator::Role::ProfileHasMessages';

sub profile {
    return {
        name         => [ qw(length_min:1 length_max:127) ],
        password     => [ qw(password_simple length_max:40) ],
        password_cnf => [ qw(required_with:password same:password) ],
    };
}

sub messages {
    return {
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
