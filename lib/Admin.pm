package Admin;

use Dancer2;

our $VERSION = '0.1';

set layout => 'admin';

### Hooks ###
require Admin::Http::Hooks;

### Routes ###
require Admin::Http::Routes;

true;
