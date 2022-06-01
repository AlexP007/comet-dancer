#!/usr/bin/env perl

use v5.36;

use FindBin;
use lib "$FindBin::Bin/../lib";

use App;
use Admin::Http::Boot;
use Plack::Builder;

builder {
    mount '/'      => App->to_app;
    mount '/admin' => Admin::Http::Boot->to_app;
};
