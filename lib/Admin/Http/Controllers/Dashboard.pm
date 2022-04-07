package Admin::Http::Controllers::Dashboard;

use Dancer2 appname  =>'Admin';

get '/dashboard' => sub {
    template 'admin/dashboard/index', {
        title => 'Dashboard',
    }
};

true;
