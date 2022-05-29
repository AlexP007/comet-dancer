package Admin::Http::Hooks;

use Dancer2 appname  =>'Admin';

use Constant;
use Utils;
use Dancer2::Plugin::CSRF;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Hooks::Auth;
use Admin::Http::Hooks::Routes;

### Check CSRF token ###
hook before => \&Utils::check_csrf_token;

### Processing forbidden message ###
hook after_authenticate_user => \&Admin::Http::Hooks::Auth::auth_forbidden_handler;

hook permission_denied => \&Admin::Http::Hooks::Auth::permission_denied_handler;

### Set routes ###
hook before => \&Admin::Http::Hooks::Routes::set_routes;

hook before_template_render => sub {
    my ($tokens) = @_;

    ### Logged in user ###
    $tokens->{current_user} = logged_in_user;

    ### CSRF token ###
    $tokens->{csrf_token} = get_csrf_token;

    ### Sidebar menu ###
    my $sidebar = [
        { name => 'Dashboard', path => route('dashboard'), icon => 'chart_pie'  },
        { name => 'Users',     path => route('users'),     icon => 'user_group' },
        { name => 'Roles',     path => route('roles'),     icon => 'user_roles' },
    ];

    $tokens->{sidebar} = Utils::set_active_menu_item($sidebar, request->path);

    ### Query ###
    $tokens->{query} = query_parameters->as_hashref_mixed;

    return;
};

true;
