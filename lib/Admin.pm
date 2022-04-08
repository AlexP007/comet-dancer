package Admin;

use Dancer2;
use Constant;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Controllers::Login;
use Admin::Http::Controllers::Dashboard;

our $VERSION = '0.1';

set layout => 'admin';

hook before => sub {
    my $path = request->path;

    if (
       $path ne Constant::page_login
        and not user_has_role(Constant::role_admin)
    ) {
        redirect Constant::page_login . "?return_url=$path";
    }
};

hook before_template_render => sub {
    my $tokens = shift;

    $tokens->{user} = logged_in_user;
};

get '/' => sub {
    redirect '/dashboard';
};

true;
