package App::Http::Validators::RegisterForm;

use strict;
use warnings;
use Moo;
use Data::FormValidator::Constraints qw(:closures);

with 'Dancer2::Plugin::FormValidator::Role::ProfileHasMessages';

sub profile {
    return {
        username     => [ qw(required alpha_num_ascii length_min:4 length_max:32) ],
        email        => [ qw(required email length_max:127) ],
        password     => [ qw(required password_simple length_max:40) ],
        password_cnf => [ qw(required same:password) ],
        confirm      => [ qw(required accepted) ],
    };
};

sub messages {
    return {
        same => {
            'en' => 'Password confirmation must be the same as password'
        }
    }
}

1;
