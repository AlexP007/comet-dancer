package Admin::Http::Routes;

use Dancer2 appname  => 'Admin';

use Constant;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Controllers::Login;
use Admin::Http::Controllers::Profile;
use Admin::Http::Controllers::Dashboard;
use Admin::Http::Controllers::User;
use Admin::Http::Controllers::UserRoles;

get '/login' => \&Admin::Http::Controllers::Login::index;

get '/'
    => require_any_role Constant::roles_admin_access
    => sub { redirect '/dashboard' };

get '/profile'
    => require_any_role Constant::roles_admin_access
    => \&Admin::Http::Controllers::Profile::index;

get '/dashboard'
    => require_any_role Constant::roles_admin_access
    => \&Admin::Http::Controllers::Dashboard::index;

prefix '/users' => sub {

    get  ''
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::User::index;

    get  '/create'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::User::create;

    get  '/:user/edit'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::User::edit;

    post '/store'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::User::store;

    post '/:user/update'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::User::update;

    post '/:user/deactivate'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::User::deactivate;

    post '/:user/activate'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::User::activate;
};

prefix '/users/roles' => sub {

    get  ''
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::UserRoles::index;

    get  '/create'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::UserRoles::create;

    get  '/:role/edit'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::UserRoles::edit;

    post '/store'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::UserRoles::store;

    post '/:role/update'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::UserRoles::update;

    post '/:role/delete'
        => require_role Constant::role_admin
        => \&Admin::Http::Controllers::UserRoles::delete;
};

true;
