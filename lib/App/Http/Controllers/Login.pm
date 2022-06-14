package App::Http::Controllers::Login;

use v5.36;
use Dancer2 appname  =>'App';

sub index {
    template 'app/login' => {
        title        => 'Login page',
        exclude_bars => 1,
    };
}

true;
