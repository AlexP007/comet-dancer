package Admin;

use Dancer2;
use Constant;
use Utils;
use Dancer2::Core::Error;
use Dancer2::Plugin::CSRF;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Controllers::Login;
use Admin::Http::Controllers::Dashboard;

our $VERSION = '0.1';

set layout => 'admin';

### Protect admin space ###
hook before => \&Utils::access_admin_only;

### Check CSRF token ###
hook before => \&Utils::check_csrf_token;

hook before_template_render => sub {
    my $tokens = shift;

    $tokens->{user}       = logged_in_user;
    $tokens->{csrf_token} = get_csrf_token;
};

get '/' => sub {
    redirect '/dashboard';
};

true;
