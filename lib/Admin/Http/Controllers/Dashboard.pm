package Admin::Http::Controllers::Dashboard;

use feature 'try';
use Dancer2 appname  =>'Admin';
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Deferred;
use Dancer2::Plugin::FormValidator;

hook before_template_render => sub {
    my $tokens = shift;

    $tokens->{routes} = {
        'roles'        => '/admin/dashboard/users/roles',
        'roles_create' => '/admin/dashboard/users/roles/create',
        'roles_delete' => '/admin/dashboard/users/roles/delete',
        'roles_edit'   => '/admin/dashboard/users/roles/edit',
        'users_create' => '/admin/dashboard/users/store',
    };

    return;
};

get '/dashboard' => sub {
    template 'admin/dashboard/index', {
        title => 'Dashboard',
    }
};

get '/dashboard/users' => sub {
    template 'admin/dashboard/users', {
        title => 'Users',
    }
};

get '/dashboard/users/create' => sub {
    my @roles = rset('Role')->all;

    template 'admin/dashboard/users_create', {
        title => 'Create user',
        roles => \@roles,
    }
};

post '/dashboard/users/store' => sub {
    if (my $v = validate_form 'admin_users_store') {

    }

    redirect request->referer;
};

get '/dashboard/users/roles' => sub {
    my @roles = rset('Role')->all;

    template 'admin/dashboard/users_roles' , {
        title => 'Roles',
        roles => \@roles,
    }
};

post '/dashboard/users/roles/create' => sub {
    if (my $v = validate_form 'admin_users_role') {
        try {
            rset('Role')->create({ role => $v->{role} });

            my $message = "Role: $v->{role} created.";

            info $message;
            deferred success => $message;
        } catch ($e) {
            error $e;
            deferred error => $e;
        };
    }

    redirect request->referer;
};

post '/dashboard/users/roles/edit' => sub {
    my $role     = body_parameters->{role};
    my $new_role = body_parameters->{new_role};

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
};

post '/dashboard/users/roles/delete' => sub {
    my $role = body_parameters->{role};

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
};

true;
