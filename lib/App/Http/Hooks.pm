package App::Http::Hooks;

use v5.36;
use Dancer2 appname => 'App';

use Utils;
use Dancer2::Plugin::Auth::Extensible;
use Dancer2::Plugin::Syntax::ParamKeywords;

hook before => sub {
    routes {
        login     => '/login',
        logout    => '/logout',
        forget    => '/forget',
        register  => '/register',
        profile   => '/profile',
        dashboard => '/dashboard',
    };

    return;
};

hook before_template_render => sub($tokens) {
    my $user     = logged_in_user;
    my $is_admin = $user && $user->admin;

    ### Logged in user.
    $tokens->{current_user} = $user;

    ### User menu.
    my $user_menu = [
        { name => 'Profile', link => route('profile') },
        { name => 'Logout',  link => route('logout')  },
    ];

    $tokens->{user_menu} = $user_menu;

    ### Sidebar menu.
    my $sidebar = [
        { name => 'Dashboard', link => route('dashboard'), icon => 'chart_pie',  show => 1 },
    ];

    $tokens->{sidebar} = Utils::set_active_menu_item($sidebar, request->route);

    ### Query.
    $tokens->{query} = query_params->as_hashref_mixed;

    return;
};

true;
