package Dsl;

use Moo;

extends 'Dancer2::Core::DSL';

# use Dancer2 ':syntax';

around dsl_keywords => sub {
    my ($parent, $method) = @_;

    my $keywords = $parent->($method);

    $keywords->{route} = { is_global => 0 };

    return $keywords;
};

sub route {
    my ($self, $name) = @_;

    return $self->uri_for(
        $self->var('routes')->{$name},
    );
}

1;
