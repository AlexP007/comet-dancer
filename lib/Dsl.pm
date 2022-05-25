package Dsl;

use Moo;
extends 'Dancer2::Core::DSL';

use constant {
    routes_var => 'routes',
    success    => 'flash_success',
    error      => 'flash_error',
};

around dsl_keywords => sub {
    my ($orig, $self) = @_;

    my $keywords = $orig->($self);

    $keywords->{routes}          = { is_global => 1 };
    $keywords->{route}           = { is_global => 1 };
    $keywords->{flash_success}   = { is_global => 1 };
    $keywords->{flash_error}     = { is_global => 1 };
    $keywords->{back}            = { is_global => 1 };
    $keywords->{get_user}        = { is_global => 1 };
    $keywords->{activate_user}   = { is_global => 1 };
    $keywords->{deactivate_user} = { is_global => 1 };
    $keywords->{pagination}      = { is_global => 0 };

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
    my ($self) = @_;
    return $self->request->referer;
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

sub pagination {
    my ($self, %args) = @_;

    my $page  = $args{page};
    my $size  = $args{size};
    my $frame = $args{frame};
    my $total = $args{total};
    my $url   = $args{url};
    my $mode  = 'query';

    my $paginator = $self->app->with_plugin('Dancer2::Plugin::Paginator')->paginator(
        curr       => $page,
        page_size  => $size,
        frame_size => $frame,
        items      => $total,
        base_url   => $url,
        mode       => $mode,
        params     => $self->app->request->query_parameters->as_hashref_mixed, # Add query params
    );

    my @controls;

    for my $i ($paginator->begin .. $paginator->end) {
        push @controls => {
            page => $i,
            url  => $paginator->page_url($i),
            curr => $paginator->curr == $i,
        };
    }

    return {
        page     => $paginator->curr,
        size     => $paginator->page_size,
        is_first => $paginator->curr == $paginator->first,
        is_last  => $paginator->curr == $paginator->last,
        prev_url => $paginator->prev_url,
        next_url => $paginator->next_url,
        controls => \@controls,
    };
}

1;
