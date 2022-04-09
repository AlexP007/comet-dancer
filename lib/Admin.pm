package Admin;

use Dancer2;
use Constant;
use Dancer2::Core::Error;
use Dancer2::Plugin::CSRF;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Controllers::Login;
use Admin::Http::Controllers::Dashboard;

our $VERSION = '0.1';

set layout => 'admin';

hook before => sub {

    ### Protect admin space ###
    my $path = request->path;

    if (
       $path ne Constant::page_login
        and not user_has_role(Constant::role_admin)
    ) {
        redirect uri_for(Constant::page_login, { return_url =>$path });
    }

    ### Check CSRF token ###
    if (request->is_post) {
        my $csrf_token = body_parameters->{csrf_token};
        if (not ($csrf_token or validate_csrf_token($csrf_token))) {
            set layout => 'main';

            my $error = Dancer2::Core::Error->new(
                app      => app,
                status   => 419,
                title    => 'Error 419 - Authentication Timeout',
                message  => 'Page expired',
            );

            $error->throw(response);
        }
    }
};

hook before_template_render => sub {
    my $tokens = shift;

    $tokens->{user}       = logged_in_user;
    $tokens->{csrf_token} = get_csrf_token;
};

get '/' => sub {
    redirect '/dashboard';
};

true;
