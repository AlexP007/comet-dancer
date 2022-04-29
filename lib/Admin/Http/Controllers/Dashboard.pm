package Admin::Http::Controllers::Dashboard;

use feature 'try';
use Dancer2 appname  =>'Admin';
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Deferred;
use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Forms::UserForm;
use Admin::Http::Forms::RoleForm;

my %routes = (
    'roles'       => '/admin/dashboard/users/roles',
    'role_create' => '/admin/dashboard/users/roles/store',
    'role_delete' => '/admin/dashboard/users/roles/%s/delete',
    'role_update' => '/admin/dashboard/users/roles/%s/update',
    'user_create' => '/admin/dashboard/users/store',
);

hook before_template_render => sub {
    my $tokens = shift;

    my %merged_routes = (%routes, %{ $tokens->{routes} // {} });
    $tokens->{routes} = \%merged_routes;

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
        users => [ rset('User')->users_with_roles ],
    }
};

get '/dashboard/users/create' => sub {
    my @roles_result = rset('Role')->all;
    my @roles = ();

    for my $role (@roles_result) {
        push @roles => { text => $role->role, value => $role->role },
    }

    template 'admin/dashboard/user_create', {
        title => 'Create user',
        roles => \@roles,
    }
};

post '/dashboard/users/store' => sub {
    if (validate profile => Admin::Http::Forms::UserForm->new) {
        my $v = validated;

        try {
            my @roles = ref $v->{roles} eq 'ARRAY' ? @{ $v->{roles} } : ($v->{roles});
            my $roles = {};

            for my $role (@roles) {
                $roles->{$role} = 1;
            }

            my $user = create_user(
                username => $v->{username},
                name     => $v->{name},
                email    => $v->{email},
                roles    => $roles,
            );

            if ($user) {
                user_password(
                    username     => $user->username,
                    new_password => $v->{password},
                );

                my $message = "User: $v->{username} created.";

                info $message;
                deferred success => $message;

                redirect '/dashboard/users'
            }
        } catch ($e) {
            error $e;
            deferred error => $e;
        };
    }

    redirect request->referer;
};

get '/dashboard/users/roles' => sub {
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

    template 'admin/dashboard/users_roles' , {
        title => 'Roles',
        table => $table,
    }
};

post '/dashboard/users/roles/store' => sub {
    if (validate profile => Admin::Http::Forms::RoleForm->new) {
        my $v = validated;

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

post '/dashboard/users/roles/:role/update' => sub {
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
};

post '/dashboard/users/roles/:role/delete' => sub {
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
};

true;
