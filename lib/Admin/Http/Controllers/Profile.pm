package Admin::Http::Controllers::Profile;

use Dancer2 appname  => 'Admin';

sub index {
    template 'admin/profile' => {
        title  => 'User profile',
        button => 'Update'
    };
};

true;
