package Admin::Http::Hooks::Routes;

use Dancer2 appname  =>'Admin';

sub set {
    routes {
        dashboard   => '/dashboard',
        users       => '/dashboard/users',
        user_create => '/dashboard/users/create',
        user_edit   => '/dashboard/users/%s/edit',
        user_delete => '/dashboard/users/%s/delete',
        roles       => '/dashboard/users/roles',
        role_create => '/dashboard/users/roles/create',
        role_store  => '/dashboard/users/roles/store',
        role_delete => '/dashboard/users/roles/%s/delete',
        role_edit   => '/dashboard/users/roles/%s/edit',
        role_update => '/dashboard/users/roles/%s/update',
    };

    return;
}

true;
