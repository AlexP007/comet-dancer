package Admin::Http::Controllers::Login;

use v5.36;
use Dancer2 appname  => 'Admin';

sub index {
    my $login_error = undef;

    if (login_failed) {
        status 403;
        $login_error = 'Invalid credentials';
    }

    template 'shared/login' => {
        title        => 'Login page',
        exclude_bars => 1,
        login_error  => $login_error,
    };
}

true;
