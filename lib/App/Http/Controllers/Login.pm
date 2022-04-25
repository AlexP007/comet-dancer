package App::Http::Controllers::Login;

use Dancer2 appname  =>'App';
use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;
use App::Http::Forms::RegisterForm;

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
    if (validate profile => App::Http::Forms::RegisterForm->new) {
        my $v = validated;

        my $user = create_user(
            username => $v->{username},
            email    => $v->{email},
            roles    => { user => 1 },
        );

        if ($user) {
            user_password(
                username     => $user->username,
                new_password => $v->{password},
            );

            return 'super';
        }
    }

    redirect '/register';
};

true;
