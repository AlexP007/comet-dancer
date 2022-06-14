package App::Http::Routes;

use v5.36;

use Dancer2 appname => 'App';

use Dancer2::Plugin::Auth::Extensible;
use App::Http::Controllers::Dashboard;
use App::Http::Controllers::Login;
use App::Http::Controllers::Register;

get '/'
    => require_login sub { redirect '/dashboard' };

get '/dashboard'
    => require_login \&App::Http::Controllers::Dashboard::index;

get '/login' => \&App::Http::Controllers::Login::index;

get '/register' => \&App::Http::Controllers::Register::index;

post '/register' => \&App::Http::Controllers::Register::store;

true;
