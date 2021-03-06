package Admin::Forms::UserSearch;

use v5.36;

use Moo;

with 'Dancer2::Plugin::FormValidator::Role::Profile';

sub profile {
    no warnings 'qw';

    return {
        role   => [ qw(exist:Role,role) ],
        active => [ qw(boolean) ],
        q      => [ qw(length_max:128) ],
        page   => [ qw(integer) ]
    };
}

1;
