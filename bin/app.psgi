#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

# use this block if you don't need middleware, and only have a single target Dancer app to run here
use App;
use Admin;
use Plack::Builder;
use Log::Dispatch;

my $logger = Log::Dispatch->new(
    outputs => [
        ['File',   min_level => 'info', filename => "$FindBin::Bin/../logs/access.log"],
    ],
);

builder {
    enable 'Plack::Middleware::AccessLog::Timed',
     format => 'combined',
     logger => sub { $logger->log(level => 'info', message => @_) };
    mount '/'      => App->to_app;
    mount '/admin' => Admin->to_app;
};
