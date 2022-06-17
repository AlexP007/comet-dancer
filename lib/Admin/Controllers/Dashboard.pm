package Admin::Controllers::Dashboard;

use v5.36;
use Dancer2 appname => 'Admin';

use Dancer2::Plugin::DBIC;

sub index {
    my $total_users = rset('User')->count;

    template 'admin/dashboard', {
        title       => 'Dashboard',
        total_users => $total_users,
    };
}

true;
