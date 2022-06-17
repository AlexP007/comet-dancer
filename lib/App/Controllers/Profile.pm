package App::Controllers::Profile;

use v5.36;
use Dancer2 appname => 'App';

use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;
use Shared::Forms::Profile;

use feature 'try';
no warnings 'experimental::try';

sub index {
    template 'shared/profile' => {
        title  => 'User profile',
        button => 'Update',
        action => route('profile_update'),
    };
}

sub update {
    if (validate profile => Shared::Forms::Profile->new) {
        my $validated = validated;

        try {
            update_current_user(
                name  => $validated->{name},
            );

            if ($validated->{password}) {
                user_password password => $validated->{password};
            }

            my $message = 'Profile updated';

            info          $message;
            flash_success $message;
        } catch ($e) {
            error         $e;
            flash_error   'Profile update failed, please contact administrator';
        }
    }

    redirect back;
}

true;
