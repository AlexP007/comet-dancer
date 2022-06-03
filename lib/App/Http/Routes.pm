package App::Http::Routes;

use v5.36;

use Dancer2 appname => 'App';

use App::Http::Controllers::Login;
use App::Http::Controllers::Register;

get '/login' => \&App::Http::Controllers::Login::index;

get '/register' => \&App::Http::Controllers::Register::index;

post '/register' => \&App::Http::Controllers::Register::store;

true;
