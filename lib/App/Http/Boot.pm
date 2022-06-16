package App::Http::Boot;

use v5.36;
use Dancer2 appname => 'App';
use Dancer2::Plugin::Debugger;
use Dancer2::Plugin::Flash;
use Dancer2::Plugin::CSRFI;

our $VERSION = '0.1';

### Hooks.
require App::Http::Hooks;

### Routes.
require App::Http::Routes;

true;
