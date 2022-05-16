package Admin::Http::Forms::RoleForm;

use strict; use warnings;

use Moo;

with 'Dancer2::Plugin::FormValidator::Role::Profile';


sub profile {
    no warnings 'qw';

    return {
        role => [ qw(required alpha_num length_max:32 unique:Role,role) ],
    };
};

1;
