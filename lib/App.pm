package App;

use Dancer2;
use Dancer2::Plugin::DBIC;

schema('default');

our $VERSION = '0.1';


get '/' => sub {
    template 'index' => {
        title   => 'app',
    };
};

true;
