package App::Http::Controllers::Login;

use Dancer2 appname  =>'App';
use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;

hook before_template_render => sub {
    my $tokens = shift;

    $tokens->{routes} = {
        'login'    => '/login',
        'forget'   => '/forget',
        'register' => '/register',
    };

    return;
};

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

post '/register' => sub {
    if (my $v = validate_form 'app_register_form') {
        my $user = create_user(
            username => $v->{username},
            email    => $v->{email},
            password => $v->{password},
        );

        to_dumper $user;
    }
    else {
        redirect '/register';
    }
};

true;
