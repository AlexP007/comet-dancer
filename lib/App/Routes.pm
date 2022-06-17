package App::Routes;

use v5.36;

use Dancer2 appname => 'App';

use Dancer2::Plugin::Auth::Extensible;
use App::Controllers::Profile;
use App::Controllers::Dashboard;
use App::Controllers::Login;
use App::Controllers::Register;

get '/'
    => require_login sub { redirect '/dashboard' };

prefix '/profile' => sub {
    get '' => require_login \&App::Controllers::Profile::index;

    post '/update' => require_login \&App::Controllers::Profile::update;
};

get '/dashboard' => require_login \&App::Controllers::Dashboard::index;

get '/login' => \&App::Controllers::Login::index;

get '/register' => \&App::Controllers::Register::index;

post '/register' => \&App::Controllers::Register::store;

true;
