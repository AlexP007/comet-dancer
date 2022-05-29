package Admin::Http::Hooks::Routes;

use Dancer2 appname  =>'Admin';

sub set_routes {
    routes {
        dashboard       => '/dashboard',
        users           => '/users',
        user_create     => '/users/create',
        user_store      => '/users/store',
        user_deactivate => '/users/%s/deactivate',
        user_activate   => '/users/%s/activate',
        user_edit       => '/users/%s/edit',
        user_update     => '/users/%s/update',
        roles           => '/users/roles',
        role_create     => '/users/roles/create',
        role_store      => '/users/roles/store',
        role_delete     => '/users/roles/%s/delete',
        role_edit       => '/users/roles/%s/edit',
        role_update     => '/users/roles/%s/update',
    };

    return;
}

true;
