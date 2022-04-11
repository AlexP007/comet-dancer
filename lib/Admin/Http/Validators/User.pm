package Admin::Http::Validators::User;

use strict;
use warnings;
use Moo;

with 'Dancer2::Plugin::FormValidator::Role::ProfileHasMessages';

sub profile {
    return {
        username     => [ qw(required alpha_num_ascii length_min:4 length_max:32 unique:User,username) ],
        name         => [ qw(length_min:1 length_max:128) ],
        email        => [ qw(required email length_max:127 unique:User,email) ],
        password     => [ qw(required password_simple length_max:40) ],
        password_cnf => [ qw(required same:password) ],
        roles        => [ qw(required) ]
    };
};

sub messages {
    return {
        email => {
            unique => {
                'en' => 'This email is not allowed, please use another one'
            }
        },
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
