package Admin;

use Dancer2;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Controllers::Login;
use Admin::Http::Controllers::Dashboard;

our $VERSION = '0.1';

use constant (
    admin => 'admin',
);

set layout => 'admin';

get '/' => require_role admin => sub {
    redirect '/dashboard';
};

true;
