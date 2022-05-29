package Admin::Http::Routes;

use Dancer2 appname  => 'Admin';

use Constant;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Controllers::Login;
use Admin::Http::Controllers::Dashboard;
use Admin::Http::Controllers::Dashboard::User;
use Admin::Http::Controllers::Dashboard::UserRoles;

get '/login' => \&Admin::Http::Controllers::Login::index;

get '/' => require_any_role Constant::roles_admin_access => sub {
    redirect '/dashboard';
};

get '/dashboard'
    => require_any_role Constant::roles_admin_access
    => \&Admin::Http::Controllers::Dashboard::index;

prefix '/users' => sub {

    get  ''
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::User::index;

    get  '/create'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::User::create;

    get  '/:user/edit'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::User::edit;

    post '/store'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::User::store;

    post '/:user/update'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::User::update;

    post '/:user/deactivate'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::User::deactivate;

    post '/:user/activate'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::User::activate;
};

prefix '/users/roles' => sub {

    get  ''
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::UserRoles::index;

    get  '/create'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::UserRoles::create;

    get  '/:role/edit'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::UserRoles::edit;

    post '/store'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::UserRoles::store;

    post '/:role/update'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::UserRoles::update;

    post '/:role/delete'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::Dashboard::UserRoles::delete;
};

true;
