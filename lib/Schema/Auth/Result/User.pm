package Schema::Auth::Result::User;

use strict;
use warnings;

use parent qw(DBIx::Class::Core);

__PACKAGE__->table('user');

__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1
    },

    username => {
        data_type     => 'varchar',
        size          => 32,
    },

    password => {
        data_type     => 'varchar',
        size          => 40,
        is_nullable   => 1,
        default_value => undef,
    },

    name => {
        data_type     => 'varchar',
        size          => 128,
        is_nullable   => 1,
        default_value => undef,
    },

    email => {
        data_type     => 'varchar',
        size          => 255,
    },

    deleted => {
        data_type     => 'tinyint',
        size          => 1,
        default_value => 0,
    },

    lastlogin => {
        data_type     => 'datetime',
        is_nullable   => 1,
        default_value => undef,
    },

    pw_changed => {
        data_type     => 'datetime',
        is_nullable   => 1,
        default_value => undef,
    },

    pw_reset_code => {
        data_type     => 'varchar',
        size          => 255,
        is_nullable   => 1,
        default_value => undef,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint([qw(username)]);

__PACKAGE__->add_unique_constraint([qw(email)]);

1;
