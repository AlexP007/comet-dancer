package Admin::Http::Hooks::Auth;

use Dancer2 appname  =>'Admin';

use Constant;
use Dancer2::Plugin::Deferred;

sub auth_forbidden_handler {
    my ($auth_result) = @_;

    if ($auth_result->{success} != 1) {
        deferred auth_result => {
            failed  => 1,
            message => 'Invalid credentials',
        };
    }
}

sub permission_denied_handler {
    app->destroy_session;

    deferred auth_result => {
        failed  => 1,
        message => 'Permission Denied',
    };

    redirect Constant::page_login;
}

true;
