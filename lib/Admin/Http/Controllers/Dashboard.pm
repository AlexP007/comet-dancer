package Admin::Http::Controllers::Dashboard;

use Dancer2 appname  =>'Admin';

get '/dashboard' => sub {
    template 'admin/dashboard/index', {
        title => 'Dashboard',
    }
};

get '/dashboard/users' => sub {
    template 'admin/dashboard/users', {
        title => 'Users',
    }
};

get '/dashboard/users/create' => sub {
    template 'admin/dashboard/users_create', {
        title => 'Create user',
    }
};

true;
