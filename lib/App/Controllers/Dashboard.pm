package App::Controllers::Dashboard;

use v5.36;
use Dancer2 appname => 'App';

sub index {
    template 'app/dashboard', {
        title => 'Dashboard',
    };
}

true;
