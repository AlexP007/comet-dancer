package Admin;

use Dancer2;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Controllers::Login;

our $VERSION = '0.1';

use constant (
    admin => 'admin',
);

get '/' => require_role admin => sub {
    'super';
};

true;
