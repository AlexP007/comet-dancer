package App;

use Dancer2;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Auth::Extensible;

our $VERSION = '0.1';

get '/' => require_login sub {
    template 'index' => {
        title   => 'app',
    };
};

true;
