#!/usr/bin/env perl

use v5.36;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Plack::Builder;
use App::Http::Boot;
use Admin::Http::Boot;

builder {
    mount '/'      => App::Http::Boot->to_app;
    mount '/admin' => Admin::Http::Boot->to_app;
};
