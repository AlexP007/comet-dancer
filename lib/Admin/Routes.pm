package Admin::Routes;

use v5.36;
use Dancer2 appname  => 'Admin';

use Constant;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Controllers::Login;
use Admin::Controllers::Profile;
use Admin::Controllers::Dashboard;
use Admin::Controllers::User;
use Admin::Controllers::UserRoles;

get '/login'
    => \&Admin::Controllers::Login::index;

get '/'
    => require_any_role Constant::roles_admin_access
    => sub { redirect '/dashboard' };

prefix '/profile' => sub {
    get ''
        => require_any_role Constant::roles_admin_access
        => \&Admin::Controllers::Profile::index;

    post '/update'
        => require_any_role Constant::roles_admin_access
        => \&Admin::Controllers::Profile::update;

};

get '/dashboard'
    => require_any_role Constant::roles_admin_access
    => \&Admin::Controllers::Dashboard::index;

prefix '/users' => sub {

    get  ''
        => require_role Constant::role_admin
        => \&Admin::Controllers::User::index;

    get  '/create'
        => require_role Constant::role_admin
        => \&Admin::Controllers::User::create;

    get  '/:user/edit'
        => require_role Constant::role_admin
        => \&Admin::Controllers::User::edit;

    post '/store'
        => require_role Constant::role_admin
        => \&Admin::Controllers::User::store;

    post '/:user/update'
        => require_role Constant::role_admin
        => \&Admin::Controllers::User::update;

    post '/:user/deactivate'
        => require_role Constant::role_admin
        => \&Admin::Controllers::User::deactivate;

    post '/:user/activate'
        => require_role Constant::role_admin
        => \&Admin::Controllers::User::activate;
};

prefix '/users/roles' => sub {

    get  ''
        => require_role Constant::role_admin
        => \&Admin::Controllers::UserRoles::index;

    get  '/create'
        => require_role Constant::role_admin
        => \&Admin::Controllers::UserRoles::create;

    get  '/:role/edit'
        => require_role Constant::role_admin
        => \&Admin::Controllers::UserRoles::edit;

    post '/store'
        => require_role Constant::role_admin
        => \&Admin::Controllers::UserRoles::store;

    post '/:role/update'
        => require_role Constant::role_admin
        => \&Admin::Controllers::UserRoles::update;

    post '/:role/delete'
        => require_role Constant::role_admin
        => \&Admin::Controllers::UserRoles::delete;
};

true;
