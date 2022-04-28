package Schema::Auth::Result::Role;

use strict;
use warnings;
use parent qw(DBIx::Class::Core);

__PACKAGE__->table('roles');

### Columns ###

__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1
    },

    role => {
        data_type => 'varchar',
        size      => 32,
    },
);

### Constrains ###

__PACKAGE__->set_primary_key(qw(id));

__PACKAGE__->add_unique_constraint([qw(role)]);

### Relationships ###

__PACKAGE__->has_many(
    user_roles => 'Schema::Auth::Result::UserRoles', 'role_id',
    {
        cascade_copy   => 0,
        cascade_delete => 0
    }
);

__PACKAGE__->many_to_many(users => 'user_roles', 'user');

1;
