package Admin::Http::Forms::Role;

use v5.36;

use Moo;

with 'Dancer2::Plugin::FormValidator::Role::Profile';


sub profile {
    no warnings 'qw';

    return {
        role => [ qw(required alpha_num length_max:32 unique:Role,role) ],
    };
};

1;
