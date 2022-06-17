package App::Routes;

use v5.36;

use Dancer2 appname => 'App';

use Dancer2::Plugin::Auth::Extensible;
use App::Controllers::Dashboard;
use App::Controllers::Login;
use App::Controllers::Register;

get '/'
    => require_login sub { redirect '/dashboard' };

get '/dashboard'
    => require_login \&App::Controllers::Dashboard::index;

get '/login' => \&App::Controllers::Login::index;

get '/register' => \&App::Controllers::Register::index;

post '/register' => \&App::Controllers::Register::store;

true;
