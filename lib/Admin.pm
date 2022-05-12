package Admin;

use Dancer2;
use Dancer2::Plugin::CSRF;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Hooks::Auth;
use Admin::Http::Routes;
use Constant;
use Utils;

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

    $tokens->{user}       = logged_in_user;
    $tokens->{csrf_token} = get_csrf_token;

    ### Sidebar menu ###
    my $sidebar = [
        {name => 'Dashboard', path => '/dashboard'      , icon => 'chart_pie'  },
        {name => 'Users',     path => '/dashboard/users', icon => 'user_group' },
    ];

    $tokens->{sidebar} = Utils::set_active_menu_item($sidebar, request->path);
};

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

true;
