package Dsl;

use v5.36;

use constant {
    routes_var => 'routes',
};

use Moo;
use Utils;

extends 'Dancer2::Core::DSL';

use namespace::clean;

around dsl_keywords => sub($orig, $self) {
    my $keywords = $orig->($self);

    $keywords->{routes}          = { is_global => 1 };
    $keywords->{route}           = { is_global => 1 };
    $keywords->{login_failed}    = { is_global => 1 };
    $keywords->{flash_success}   = { is_global => 1 };
    $keywords->{flash_error}     = { is_global => 1 };
    $keywords->{back}            = { is_global => 1 };

    return $keywords;
};

sub routes($self, $routes) {
    $self->var(routes_var, $routes);
    return;
}

sub route($self, $name, @params) {
    my $route = $self->var(routes_var)->{$name};
    if (@params) {
        $route = sprintf($route, @params);
    }

    return $self->request->uri_base . $route;
}

sub login_failed($self) {
    return $self->app->request->var('login_failed');
}

sub flash_success($self, $message) {
    return Utils::flash_success($self->app, $message);
}

sub flash_error($self, $message) {
    return Utils::flash_error($self->app, $message);
}

sub back($self) {
    return $self->request->referer;
}

1;
