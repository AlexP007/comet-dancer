package App::Http::Validators::RegisterForm;

use strict;
use warnings;
use Moo;

with 'Dancer2::Plugin::FormValidator::Role::ProfileHasMessages';

sub profile {
    return {
        username     => [ qw(required alpha_num_ascii length_min:4 length_max:32 unique:User,username) ],
        email        => [ qw(required email length_max:127) ],
        password     => [ qw(required password_simple length_max:40) ],
        password_cnf => [ qw(required same:password) ],
        confirm      => [ qw(required accepted) ],
    };
};

sub messages {
    return {
        password_cnf => {
            required => {
                en   => 'Confirm Password is required',
            },
            same     => {
                en => 'Confirm Password must be the same as Password',
            },
        }
    }
}

1;
