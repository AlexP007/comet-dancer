package App::Controllers::Login;

use v5.36;
use Dancer2 appname => 'App';

sub index {
    my $links = [
        { text => 'Register', link => route('register') },
    ];

    my $login_error = undef;
    if (login_failed) {
        status 403;
        $login_error = 'Invalid credentials';
    }

    template 'shared/login' => {
        title        => 'Login page',
        exclude_bars => 1,
        links        => $links,
        login_error  => $login_error,
    };
}

true;
