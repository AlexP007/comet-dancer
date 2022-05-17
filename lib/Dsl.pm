package Dsl;

use Moo;
extends 'Dancer2::Core::DSL';

use constant {
    success => 'flash_success',
    error   => 'flash_error',
};

my $routes;

around dsl_keywords => sub {
    my ($orig, $self) = @_;

    my $keywords = $orig->($self);

    $keywords->{routes}          = { is_global => 1 };
    $keywords->{route}           = { is_global => 1 };
    $keywords->{flash_success}   = { is_global => 1 };
    $keywords->{flash_error}     = { is_global => 1 };
    $keywords->{back}            = { is_global => 0 };
    $keywords->{activate_user}   = { is_global => 1 };
    $keywords->{deactivate_user} = { is_global => 1 };
    $keywords->{user_inactive}   = { is_global => 1 };
    $keywords->{user_admin}      = { is_global => 1 };

    return $keywords;
};

sub routes {
    $routes = $_[1];
    return;
}

sub route {
    my ($self, $name, @params) = @_;

    my $route = $routes->{$name};
    if (@params) {
        $route = sprintf($route, @params);
    }

    return $self->uri_for($route);
}

sub flash_success {
    my ($self, $message) = @_;

    $self->app
         ->with_plugin('Dancer2::Plugin::Deferred')
         ->deferred(success, $message);

    return;
}

sub flash_error {
    my ($self, $message) = @_;

    $self->app
         ->with_plugin('Dancer2::Plugin::Deferred')
         ->deferred(error, $message);

    return;
}

sub back {
    return $Dancer2::Core::Route::REQUEST->referer;
}

sub activate_user {
    my ($self, $username) = @_;

    return $self
        ->app
        ->with_plugin('Dancer2::Plugin::DBIC')
        ->rset('User')
        ->single({ username => $username })
        ->update({ deleted  => 0 });
}

sub deactivate_user {
    my ($self, $username) = @_;

    return $self
        ->app
        ->with_plugin('Dancer2::Plugin::DBIC')
        ->rset('User')
        ->single({ username => $username })
        ->update({ deleted => 1 });
}

sub user_inactive {
    my ($self, $username) = @_;

    return $self
        ->app
        ->with_plugin('Dancer2::Plugin::DBIC')
        ->rset('User')
        ->single({ username => $username })
        ->inactive;
}

sub user_admin {
    my ($self, $username) = @_;

    return $self
        ->app
        ->with_plugin('Dancer2::Plugin::Auth::Extensible')
        ->get_user_details($username)
        ->admin;
}

1;
