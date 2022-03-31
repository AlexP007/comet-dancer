package App::Http::Controllers::Login;

use Dancer2 appname  =>'App';
use Dancer2::Plugin::FormValidator;
use App::Http::Validators::RegisterForm;

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
    if (my $validated = validate_form 'app_register_form') {
        to_dumper $validated;
    }
    else {
        redirect '/register';
    }
};

true;
