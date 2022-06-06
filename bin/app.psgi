#!/usr/bin/env perl

use v5.36;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Plack::Builder;
use Dancer2::Debugger;
use App::Http::Boot;
use Admin::Http::Boot;

my $debugger = Dancer2::Debugger->new;

builder {
    $debugger->mount;

    mount '/' => builder {
        $debugger->enable;
        App::Http::Boot->to_app;
    };

    mount '/admin' => builder {
        $debugger->enable;
        Admin::Http::Boot->to_app;
    };
};
