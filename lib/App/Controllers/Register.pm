package App::Controllers::Register;

use v5.36;
use Dancer2 appname => 'App';

use Dancer2::Plugin::FormValidator;
use App::Forms::Register;

use feature 'try';
no warnings 'experimental::try';

sub index {
    template 'app/register' => {
        title        => 'Register page',
        action       => route('register'),
        exclude_bars => 1,
    };
}

sub store {
    my $form = App::Forms::Register->new;

    if (validate profile => $form) {
        try {
            my $user    = $form->save(validated());
            my $message = sprintf('User: %s registered', $user->username);

            info          $message;
            flash_success $message;
            redirect      route('dashboard');
        } catch ($e) {
            error         $e;
        };
    }

    redirect back;
}

true;
