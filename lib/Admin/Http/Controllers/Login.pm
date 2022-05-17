package Admin::Http::Controllers::Login;

use Dancer2 appname  =>'Admin';

use Dancer2::Plugin::Deferred;

sub index {
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
