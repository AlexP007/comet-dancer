package Admin::Http::Boot;

use v5.36;
use Dancer2 appname  => 'Admin';

our $VERSION = '0.1';

set layout => 'admin';

### Hooks.
require Admin::Http::Hooks;

### Routes.
require Admin::Http::Routes;

true;
