package Dsl;

use strict; use warnings;

use constant {
    routes_var => 'routes',
};

use Moo;
use Utils;

extends 'Dancer2::Core::DSL';

use namespace::clean;

around dsl_keywords => sub {
    my ($orig, $self) = @_;

    my $keywords = $orig->($self);

    $keywords->{routes}          = { is_global => 1 };
    $keywords->{route}           = { is_global => 1 };
    $keywords->{flash_success}   = { is_global => 1 };
    $keywords->{flash_error}     = { is_global => 1 };
    $keywords->{back}            = { is_global => 1 };
    $keywords->{login_failed}    = { is_global => 1 };
    $keywords->{get_user}        = { is_global => 1 };
    $keywords->{activate_user}   = { is_global => 1 };
    $keywords->{deactivate_user} = { is_global => 1 };

    return $keywords;
};

sub routes {
    my ($self, $routes) = @_;

    $self->var(routes_var, $routes);
    return;
}

sub route {
    my ($self, $name, @params) = @_;

    my $route = $self->var(routes_var)->{$name};
    if (@params) {
        $route = sprintf($route, @params);
    }

    return $self->request->base . $route;
}

sub flash_success {
    my ($self, $message) = @_;
    return Utils::flash_success($self->app, $message);
}

sub flash_error {
    my ($self, $message) = @_;
    return Utils::flash_error($self->app, $message);
}

sub back {
    my ($self) = @_;
    return $self->request->referer;
}

sub login_failed {
    my ($self) = @_;
    return $self->app->request->var('login_failed');
}

sub get_user {
    my ($self, $username) = @_;

    return $self
        ->app
        ->with_plugin('Dancer2::Plugin::DBIC')
        ->rset('User')
        ->find({ username => $username });
}

sub activate_user {
    my ($self, $username) = @_;

    return $self
        ->get_user($username)
        ->update({ deleted  => 0 });
}

sub deactivate_user {
    my ($self, $username) = @_;

    return $self
        ->get_user($username)
        ->update({ deleted => 1 });
}

1;
