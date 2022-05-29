package Admin::Http::Controllers::Dashboard;

use Dancer2 appname  => 'Admin';

use Dancer2::Plugin::DBIC;

sub index {
    my $total_users = rset('User')->count;

    template 'admin/dashboard/index', {
        title       => 'Dashboard',
        total_users => $total_users,
    }
}

true;
