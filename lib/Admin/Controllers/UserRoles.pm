package Admin::Controllers::UserRoles;

use v5.36;
use Dancer2 appname => 'Admin';

use Constant;
use Utils;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Syntax::ParamKeywords;
use Admin::Forms::Role;

use feature 'try';
no warnings 'experimental::try';

sub index {
    my @roles = rset('Role')->all;
    my @rows  = map {
        {
            id      => $_->role,
            data    => [
                Utils::table_row_data(value => $_->role, type => 'text'),
            ],
            actions => [
                Utils::table_row_action(
                    name    => 'edit',
                    type    => 'link',
                    show    => 1,
                    route   => route('role_edit', $_->role),
                ),
                Utils::table_row_action(
                    name    => 'delete',
                    type    => 'form',
                    show    => 1,
                    route   => route('role_delete', $_->role),
                    confirm => {
                        heading => 'Are you sure?',
                        message => sprintf('Role: %s will be deleted permanently.', $_->role),
                    },
                ),
            ],
        }
    } @roles;

    my $table = Utils::table(
        name     => 'role',
        headings => [ qw(Role) ],
        rows     => \@rows,
    );

    template 'admin/user_roles/index' , {
        title  => 'Roles',
        table  => $table,
        routes => {
            role_create => route('role_create'),
        }
    }
}

sub create {
    template 'admin/user_roles/form', {
        title  => 'Create Role',
        button => 'Create',
        action => route('role_store'),
    }
}

sub store {
    my $form = Admin::Forms::Role->new;

    if (validate profile => $form) {
        try {
            my $role    = $form->save(validated());
            my $message = sprintf('Role: %s created', $role->role);

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
    my $role_name = route_param 'role';

    my $role = rset('Role')->find({ role => $role_name });

    if ($role) {
        template 'admin/user_roles/form', {
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
    my $role_name = route_param 'role';
    my $form      = Admin::Forms::Role->new;

    if (validate profile => $form) {
        try {
            my $role    = $form->save(validated(), $role_name);
            my $message = sprintf('Role: %s updated to %s', $role_name, $role->role);

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
    my $role = route_param 'role';

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
