package Admin;

use Constant;
use Utils;
use Dancer2;
use Dancer2::Plugin::CSRF;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Hooks::Auth;
use Admin::Http::Routes;

our $VERSION = '0.1';

set layout => 'admin';

### Protect admin space ###
hook before => \&Admin::Http::Hooks::Auth::admin_only;

### Processing authentication ###
hook after_authenticate_user => \&Admin::Http::Hooks::Auth::login_process;

### Check CSRF token ###
hook before => \&Utils::check_csrf_token;

hook before_template_render => sub {
    my $tokens = shift;

    ### Logged in user ###
    $tokens->{user} = logged_in_user;

    ### CSRF token ###
    $tokens->{csrf_token} = get_csrf_token;

    ### Sidebar menu ###
    my $sidebar = [
        {name => 'Dashboard', path => '/dashboard'      , icon => 'chart_pie'  },
        {name => 'Users',     path => '/dashboard/users', icon => 'user_group' },
    ];

    $tokens->{sidebar} = Utils::set_active_menu_item($sidebar, request->path);

    ### Routes ###
    my $prefix = '/admin/dashboard';
    my %routes = (
        'roles'       => "$prefix/users/roles",
        'role_create' => "$prefix/users/roles/store",
        'role_delete' => "$prefix/users/roles/%s/delete",
        'role_update' => "$prefix/users/roles/%s/update",
        'user_create' => "$prefix/users/store",
    );

    my %merged_routes = (%routes, %{ $tokens->{routes} // {} });
    $tokens->{routes} = \%merged_routes;

    return;
};

true;
