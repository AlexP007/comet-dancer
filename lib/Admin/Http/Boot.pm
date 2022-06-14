package Admin::Http::Boot;

use v5.36;
use Dancer2 appname  => 'Admin';
use Dancer2::Plugin::Debugger;
use Dancer2::Plugin::CSRFI;

our $VERSION = '0.1';

### Hooks.
require Admin::Http::Hooks;

### Routes.
require Admin::Http::Routes;

true;
