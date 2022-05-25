package Schema::Auth::Result::User;

use strict; use warnings;
use Constant;

use parent qw(DBIx::Class::Core);

__PACKAGE__->table('users');

### Components ###
__PACKAGE__->load_components("TimeStamp");

### Columns ###

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
        size          => 64,
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
        is_nullable   => 1,
        default_value => undef,
    },

    deleted => {
        data_type     => 'tinyint',
        size          => 1,
        default_value => 0,
    },

    registered => {
        data_type     => 'datetime',
        set_on_create => 1,
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

### Constrains ###

__PACKAGE__->set_primary_key(qw(id));

__PACKAGE__->add_unique_constraint([qw(username)]);

__PACKAGE__->add_unique_constraint([qw(email)]);

### Relationships ###

__PACKAGE__->has_many(
    user_roles => 'Schema::Auth::Result::UserRoles', 'user_id',
    {
        cascade_copy   => 0,
        cascade_delete => 0,
    }
);

__PACKAGE__->many_to_many(roles => 'user_roles', 'role');

### Methods ###

sub admin {
    my ($self) = @_;

    return $self->has_role(Constant::role_admin);
}

sub inactive {
    my ($self) = @_;

    return $self->deleted == 1;
}

sub active {
    my ($self) = @_;

    return $self->deleted == 0;
}

sub has_role {
    my ($self, $role_name) = @_;

    my $role = $self->roles->search({
        role => $role_name,
    })->single;

    return $role ? $role->role eq $role_name : undef;
}

sub role_names {
    my ($self) = @_;

    my @roles = map { $_->role } ( $self->roles->all );
    return \@roles;
}

sub get_timestamp {
    my ($self) = @_;

    return $self->SUPER::get_timestamp->set_time_zone('local');
}

1;
