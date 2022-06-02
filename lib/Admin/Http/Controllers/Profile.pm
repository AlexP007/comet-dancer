package Admin::Http::Controllers::Profile;

use v5.36;
use Dancer2 appname  => 'Admin';

use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Forms::Profile;

use feature 'try';
no warnings 'experimental::try';

sub index {
    template 'admin/profile' => {
        title  => 'User profile',
        button => 'Update',
        action => route('profile_update'),
    };
}

sub update {
    if (validate profile => Admin::Http::Forms::Profile->new) {
        my $validated = validated;

        try {
            update_current_user(
                name  => $validated->{name},
                email => $validated->{email},
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
