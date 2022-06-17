#!/usr/bin/env perl

use v5.36;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Plack::Builder;
use Dancer2::Debugger;
use App::Boot;
use Admin::Boot;

my $debugger = Dancer2::Debugger->new;

builder {
    $debugger->mount;

    mount '/' => builder {
        $debugger->enable;
        App::Boot->to_app;
    };

    mount '/admin' => builder {
        $debugger->enable;
        Admin::Boot->to_app;
    };
};
