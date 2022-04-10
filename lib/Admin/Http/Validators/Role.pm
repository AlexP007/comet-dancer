package Admin::Http::Validators::Role;

use strict;
use warnings;
use Moo;

with 'Dancer2::Plugin::FormValidator::Role::Profile';

sub profile {
    return {
        role => [ qw(required alpha_num_ascii length_max:32 unique:Role,role) ],
    };
};

1;
