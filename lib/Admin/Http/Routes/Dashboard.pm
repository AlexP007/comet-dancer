package Admin::Http::Routes::Dashboard;

use feature 'try';
use Dancer2 appname  =>'Admin';
use Admin::Http::Controllers::Dashboard::User;
use Admin::Http::Controllers::Dashboard::UserRoles;

hook before_template_render => sub {
    my $tokens = shift;

    my %routes = (
        'roles'       => '/admin/dashboard/users/roles',
        'role_create' => '/admin/dashboard/users/roles/store',
        'role_delete' => '/admin/dashboard/users/roles/%s/delete',
        'role_update' => '/admin/dashboard/users/roles/%s/update',
        'user_create' => '/admin/dashboard/users/store',
    );

    my %merged_routes = (%routes, %{ $tokens->{routes} // {} });
    $tokens->{routes} = \%merged_routes;

    return;
};

prefix '/dashboard' => sub {
    get '' => sub {
        template 'admin/dashboard/index', {
            title => 'Dashboard',
        }
    };

    prefix '/users' => sub {
        get ''         => \&Admin::Http::Controllers::Dashboard::User::index;
        get  '/create' => \&Admin::Http::Controllers::Dashboard::User::create;
        post '/store'  => \&Admin::Http::Controllers::Dashboard::User::store;
    };

    prefix '/users/roles' => sub {
        get ''               => \&Admin::Http::Controllers::Dashboard::UserRoles::index;
        post '/store'        => \&Admin::Http::Controllers::Dashboard::UserRoles::store;
        post '/:role/update' => \&Admin::Http::Controllers::Dashboard::UserRoles::update;
        post '/:role/delete' => \&Admin::Http::Controllers::Dashboard::UserRoles::delete;
    };
};

true;
