package App::Http::Controllers::Login;

use Dancer2 appname  =>'App';

get '/login' => sub {
    template 'app/login' => {
        title  => 'Login page',
    };
};

get '/register' => sub {
    template 'app/register' => {
        title  => 'Register page',
    };
};

true;
