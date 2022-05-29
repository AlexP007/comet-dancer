package Admin::Http::Controllers::Login;

use Dancer2 appname  => 'Admin';

use Dancer2::Plugin::Deferred;

sub index {
    my $login_error = undef;

    if (login_failed) {
        status 403;
        $login_error = 'Invalid credentials';
    }

    template 'admin/login' => {
        title        => 'Login page',
        exclude_bars => 1,
        login_error  => $login_error,
    };
};

true;
