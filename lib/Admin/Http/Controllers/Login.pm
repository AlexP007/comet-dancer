package Admin::Http::Controllers::Login;

use Dancer2 appname  =>'Admin';
use Constant;
use Dancer2::Plugin::Deferred;
use Dancer2::Plugin::Auth::Extensible;

hook after_authenticate_user => sub {
    my $auth_result = shift;

    if ($auth_result->{success} == 1) {
        my $user = get_user_details($auth_result->{username});

        if (not $user->is_admin) {
            app->destroy_session;

            deferred auth_result => {
                failed  => 1,
                message => 'Not enough rights',
            };

            redirect '/login';
        }
    }
    else {
        deferred auth_result => {
            failed  => 1,
            message => 'Invalid credentials',
        };
    }
};

get '/login' => sub {
    my $login_error = undef;

    if (my $auth_result = deferred 'auth_result') {
        if ($auth_result->{failed} == 1) {
            status 403;
            $login_error = $auth_result->{message};
        }
    }

    template 'admin/login' => {
        title        => 'Login page',
        exclude_bars => 1,
        login_error  => $login_error,
    };
};

true;
