package Admin::Http::Controllers::Dashboard::UserRoles;

use Dancer2 appname  =>'Admin';

use Constant;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::FormValidator;
use Admin::Http::Forms::RoleForm;

use feature 'try';
no warnings 'experimental::try';

sub index {
    my @roles = rset('Role')->all;
    my @rows  = map {
        {
            id      => $_->role,
            data    => [
                { value => $_->role, type => 'text' }
            ],
            actions => [
                { name => 'edit',   type => 'link', confirm => 0, route => route('role_edit',   $_->role) },
                { name => 'delete', type => 'form', confirm => 1, route => route('role_delete', $_->role) },
            ],
        }
    } @roles;

    my $table = {
        name     => 'role',
        headings => [ qw(Role) ],
        rows     => \@rows,
    };

    template 'admin/dashboard/user_roles/index' , {
        title  => 'Roles',
        table  => $table,
        routes => {
            role_create => route('role_create'),
        }
    }
}

sub create {
    template 'admin/dashboard/user_roles/form', {
        title  => 'Create Role',
        button => 'Create',
        action => route('role_store'),
    }
}

sub store {
    if (validate profile => Admin::Http::Forms::RoleForm->new) {
        my $v = validated;

        try {
            rset('Role')->create({ role => $v->{role} });

            my $message = sprintf('Role: %s created', $v->{role});

            info          $message;
            flash_success $message;
            redirect      route('roles');
        } catch ($e) {
            error         $e;
            flash_error   $e;
        }
    }

    redirect back;
}

sub edit {
    my $role_name = route_parameters->{role};

    my $role = rset('Role')->single({
        role => $role_name,
    });

    if ($role) {
        template 'admin/dashboard/user_roles/form', {
            title  => 'Update Role',
            role   => $role,
            button => 'Update',
            action => route('role_update', $role->role),
        }
    }
    else {
        my $message = sprintf('Route: %s not found', $role_name);

        warning    $message;
        send_error $message => 404;
    }
}

sub update {
    my $role = route_parameters->{role};

    if (validate profile => Admin::Http::Forms::RoleForm->new) {
        my $new_role = validated->{role};

        try {
            rset('Role')->single({ role => $role })->update({ role => $new_role });

            my $message = sprintf('Role: %s updated to %s', $role, $new_role);

            info          $message;
            flash_success $message;
            redirect      route('roles');
        } catch ($e) {
            error         $e;
            flash_error   $e;
        }
    }

    redirect back;
}

sub delete {
    my $role = route_parameters->{role};

    try {
        rset('Role')->single({ role => $role })->delete;

        my $message = sprintf('Role: %s deleted', $role);

        info          $message;
        flash_success $message;
        redirect      route('roles');
    } catch ($e) {
        error         $e;
        flash_error   $e;
        redirect      back;
    }
}

true;
