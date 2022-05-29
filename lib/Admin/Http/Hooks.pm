package Admin::Http::Hooks;

use Dancer2 appname  =>'Admin';

use Constant;
use Utils;
use Dancer2::Plugin::CSRF;
use Dancer2::Plugin::Auth::Extensible;

### Check CSRF token ###
hook before => \&Utils::check_csrf_token;

### Processing forbidden message ###
hook after_authenticate_user => sub { \&Utils::auth_forbidden_handler(app, $_[0]) };

### Processing permission denied message + logout  ###
hook permission_denied => sub { \&Utils::permission_denied_handler(app) };

### Set routes ###
hook before => sub {
    routes {
        dashboard       => '/dashboard',
            users           => '/users',
            user_create     => '/users/create',
            user_store      => '/users/store',
            user_deactivate => '/users/%s/deactivate',
            user_activate   => '/users/%s/activate',
            user_edit       => '/users/%s/edit',
            user_update     => '/users/%s/update',
            roles           => '/users/roles',
            role_create     => '/users/roles/create',
            role_store      => '/users/roles/store',
            role_delete     => '/users/roles/%s/delete',
            role_edit       => '/users/roles/%s/edit',
            role_update     => '/users/roles/%s/update',
    };

    return;
};

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
