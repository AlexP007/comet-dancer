package App::Http::Controllers::Login;

use Dancer2 appname  =>'App';

get '/login' => sub {
    template 'app/login' => {
        title  => 'login',
    };
};

true;
