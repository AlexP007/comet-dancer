#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use App;
use Admin;
use Plack::Builder;

builder {
    mount '/'      => App->to_app;
    mount '/admin' => Admin->to_app;
};
