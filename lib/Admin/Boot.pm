package Admin::Boot;

use v5.36;
use Dancer2 appname  => 'Admin';
use Dancer2::Plugin::Debugger;
use Dancer2::Plugin::Flash;
use Dancer2::Plugin::CSRFI;

our $VERSION = '1';

### Hooks.
require Admin::Hooks;

### Routes.
require Admin::Routes;

true;
