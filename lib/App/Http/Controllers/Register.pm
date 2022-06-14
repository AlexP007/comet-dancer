package App::Http::Controllers::Register;

use v5.36;
use Dancer2 appname  =>'App';

use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;
use App::Http::Forms::RegisterForm;


sub index {
    template 'app/register' => {
        title        => 'Register page',
        exclude_bars => 1,
    };
}

sub store {
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
}

true;
