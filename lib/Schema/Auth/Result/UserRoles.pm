package Schema::Auth::Result::UserRoles;

use v5.36;

use parent qw(DBIx::Class::Core);

__PACKAGE__->table("user_roles");

### Columns ###

__PACKAGE__->add_columns(
    user_id => {
        data_type => 'integer',
    },

    role_id => {
        data_type => 'integer',
    },
);

### Constrains ###

__PACKAGE__->set_primary_key(qw(user_id role_id));

### Relationships ###

__PACKAGE__->belongs_to(user => 'Schema::Auth::Result::User', 'user_id');

__PACKAGE__->belongs_to(role => 'Schema::Auth::Result::Role', 'role_id');

1;
