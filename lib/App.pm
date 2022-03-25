package App;

use Dancer2;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Auth::Extensible;

our $VERSION = '0.1';

get '/' => sub {
    template 'app/login' => {
        title  => 'ho',
        lang   => 'app',
    };
};

true;
