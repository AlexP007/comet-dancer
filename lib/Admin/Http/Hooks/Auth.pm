package Admin::Http::Hooks::Auth;

use Dancer2 appname  =>'Admin';

use Constant;
use Dancer2::Plugin::Deferred;
use Dancer2::Plugin::Auth::Extensible;

sub admin_only {
    my $path = request->path;

    if ($path ne Constant::page_login and not user_has_role(Constant::role_admin)) {
        redirect(
            request->uri_for(Constant::page_login, { return_url => $path })
        );
    }

    return;
}

sub login_process {
    my ($auth_result) = @_;

    if ($auth_result->{success} == 1) {
        if (not user_admin $auth_result->{username}) {
            app->destroy_session;

            deferred auth_result => {
                failed  => 1,
                message => 'Not enough rights',
            };

            redirect Constant::page_login;
        }
        else {
            flash_success 'Login successful';
        }
    }
    else {
        my $message = 'Invalid credentials';

        if (user_inactive $auth_result->{username}) {
            $message = 'Access denied';
        }

        deferred auth_result => {
            failed  => 1,
            message => $message,
        };
    }
}

true;
