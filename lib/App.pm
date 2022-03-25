package App;

use Dancer2;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Auth::Extensible;

use App::Http::Controllers::Login;

our $VERSION = '0.1';

hook before_template_render => sub {
    my $tokens = shift;

    $tokens->{routes} = {
        'login'    => '/login',
        'forget'   => '/forget',
        'register' => '/register',
    };
};

true;
