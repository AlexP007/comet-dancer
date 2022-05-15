package Dsl;

use Moo;

extends 'Dancer2::Core::DSL';

my $routes;

around dsl_keywords => sub {
    my ($parent, $method) = @_;

    my $keywords = $parent->($method);

    $keywords->{routes} = { is_global => 1 };
    $keywords->{route}  = { is_global => 1 };

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

1;
