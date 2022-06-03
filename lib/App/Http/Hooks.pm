package App::Http::Hooks;

use v5.36;
use Dancer2 appname => 'App';

hook before => sub {
    routes {
        login    => '/login',
        forget   => '/forget',
        register => '/register',
    };

    return;
};

true;
