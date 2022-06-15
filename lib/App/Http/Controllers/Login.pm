package App::Http::Controllers::Login;

use v5.36;
use Dancer2 appname  =>'App';

sub index {
    my $links = [
        { text => 'Register', link => route('register') },
    ];

    template 'shared/login' => {
        title        => 'Login page',
        exclude_bars => 1,
        links        => $links,
    };
}

true;
