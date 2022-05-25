package Admin::Http::Routes;

use Dancer2 appname  =>'Admin';

use Admin::Http::Controllers::Login;
use Admin::Http::Controllers::Dashboard;
use Admin::Http::Controllers::Dashboard::User;
use Admin::Http::Controllers::Dashboard::UserRoles;

get '/' => sub {
    redirect '/dashboard';
};

get '/login' => \&Admin::Http::Controllers::Login::index;

prefix '/dashboard' => sub {
    get '' => \&Admin::Http::Controllers::Dashboard::index;

    prefix '/users' => sub {
        get  ''                  => \&Admin::Http::Controllers::Dashboard::User::index;
        get  '/create'           => \&Admin::Http::Controllers::Dashboard::User::create;
        get  '/:user/edit'       => \&Admin::Http::Controllers::Dashboard::User::edit;
        post '/store'            => \&Admin::Http::Controllers::Dashboard::User::store;
        post '/:user/update'     => \&Admin::Http::Controllers::Dashboard::User::update;
        post '/:user/deactivate' => \&Admin::Http::Controllers::Dashboard::User::deactivate;
        post '/:user/activate'   => \&Admin::Http::Controllers::Dashboard::User::activate;
    };

    prefix '/users/roles' => sub {
        get  ''              => \&Admin::Http::Controllers::Dashboard::UserRoles::index;
        get  '/create'       => \&Admin::Http::Controllers::Dashboard::UserRoles::create;
        get  '/:role/edit'   => \&Admin::Http::Controllers::Dashboard::UserRoles::edit;
        post '/store'        => \&Admin::Http::Controllers::Dashboard::UserRoles::store;
        post '/:role/update' => \&Admin::Http::Controllers::Dashboard::UserRoles::update;
        post '/:role/delete' => \&Admin::Http::Controllers::Dashboard::UserRoles::delete;
    };
};

true;
