package Admin::Http::Controllers::Profile;

use Dancer2 appname  => 'Admin';

use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Forms::ProfileForm;

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
    my $profile = Admin::Http::Forms::ProfileForm->new(
        current_email => logged_in_user->email,
    );

    if (validate profile => $profile) {
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
