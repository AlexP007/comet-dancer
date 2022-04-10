package Admin::Http::Controllers::Dashboard;

use Dancer2 appname  =>'Admin';
use Dancer2::Plugin::DBIC;

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

get '/dashboard/users/groups' => sub {
    my @roles = rset('Role')->all;

    template 'admin/dashboard/users_roles' , {
        title => 'Roles',
        roles => \@roles,
    }
};

true;
