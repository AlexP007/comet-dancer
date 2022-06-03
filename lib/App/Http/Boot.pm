package App::Http::Boot;

use v5.36;
use Dancer2 appname => 'App';

our $VERSION = '0.1';

### Hooks.
require App::Http::Hooks;

### Routes.
require App::Http::Routes;

true;
