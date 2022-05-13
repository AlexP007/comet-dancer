package Admin::Http::Hooks;

use Dancer2 appname  =>'Admin';

use Constant;
use Utils;
use Dancer2::Plugin::CSRF;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Hooks::Auth;

### Protect admin space ###
hook before => \&Admin::Http::Hooks::Auth::admin_only;

### Processing authentication ###
hook after_authenticate_user => \&Admin::Http::Hooks::Auth::login_process;

### Check CSRF token ###
hook before => \&Utils::check_csrf_token;

### Set routes var ###
hook before => sub {
    var routes => {
        'dashboard'   => '/dashboard',
        'users'       => '/dashboard/users',
        'user_create' => '/dashboard/users/store',
        'roles'       => '/dashboard/users/roles',
        'role_create' => '/dashboard/users/roles/create',
        'role_store'  => '/dashboard/users/roles/store',
        'role_delete' => '/dashboard/users/roles/%s/delete',
        'role_edit'   => '/dashboard/users/roles/%s/edit',
        'role_update' => '/dashboard/users/roles/%s/update',
    };

    return;
};

hook before_template_render => sub {
    my ($tokens) = @_;

    ### Logged in user ###
    $tokens->{user} = logged_in_user;

    ### CSRF token ###
    $tokens->{csrf_token} = get_csrf_token;

    ### Routes full-qualified ###
    my %routes = %{ var 'routes' };

    foreach my $route (keys %routes) {
        my $path = $routes{$route};
        $routes{$route} = uri_for $path;
    }

    ### Set them as template tokens ###
    my %merged_routes = (%routes, %{ $tokens->{routes} // {} });
    $tokens->{routes} = \%merged_routes;

    ### Sidebar menu ###
    my $sidebar = [
        { name => 'Dashboard', path => $routes{dashboard}, icon => 'chart_pie'  },
        { name => 'Users',     path => $routes{users},     icon => 'user_group' },
        { name => 'Roles',     path => $routes{roles},     icon => 'user_roles' },
    ];

    $tokens->{sidebar} = Utils::set_active_menu_item($sidebar, request->path);

    return;
};

true;
