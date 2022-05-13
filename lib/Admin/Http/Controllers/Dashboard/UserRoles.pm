package Admin::Http::Controllers::Dashboard::UserRoles;

use Dancer2 appname  =>'Admin';

use Constant;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Deferred;
use Admin::Http::Forms::RoleForm;

use feature 'try';
no warnings 'experimental::try';

sub index {
    my @roles = rset('Role')->all;
    my @rows  = map {
        {
            id       => $_->role,
                data     => [
                    { value => $_->role, name => 'role' },
                ],
        }
    } @roles;

    my $table = {
        headings => [ qw(Role) ],
        rows     => \@rows,
    };

    template 'admin/dashboard/user_roles/index' , {
        title => 'Roles',
        table => $table,
    }
}

sub create {
    template 'admin/dashboard/user_roles/create', {
        title => 'Create Role',
    }
}

sub store {
    if (validate profile => Admin::Http::Forms::RoleForm->new) {
        my $v = validated;

        try {
            rset('Role')->create({ role => $v->{role} });

            my $message = "Role: $v->{role} created";

            info $message;
            deferred success => $message;

            my $routes = var 'routes';
            redirect $routes->{roles};
        } catch ($e) {
            error $e;
            deferred error => $e;
        };
    }

    redirect request->referer;
}

sub update {
    my $role     = route_parameters->{role};
    my $new_role = body_parameters->{role};

    try {
        rset('Role')->single({ role => $role })->update({ role => $new_role });

        my $message = "Role: $role updated to $new_role.";

        info $message;
        deferred success => $message;
    } catch ($e) {
        error $e;
        deferred error => $e;
    };

    redirect request->referer;
}

sub delete {
    my $role = route_parameters->{role};

    try {
        rset('Role')->single({ role => $role })->delete;

        my $message = "Role: $role deleted.";

        info $message;
        deferred success => $message;
    } catch ($e) {
        error $e;
        deferred error => $e;
    };

    redirect request->referer;
}

true;
