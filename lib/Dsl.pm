package Dsl;

use Moo;
use Constant;
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
    $keywords->{pagination}      = { is_global => 0 };

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

sub pagination {
    my ($self, %args) = @_;

    my $page  = $args{page}  || 1;
    my $size  = $args{size}  || Constant::pagination_page_size;
    my $frame = $args{frame} || Constant::pagination_frame_size;
    my $total = $args{total};
    my $url   = $args{url};
    my $mode  = 'query';

    my $paginator = $self->app->with_plugin('Dancer2::Plugin::Paginator')->paginator(
        curr        => $page,
        page_size   => $size,
        frame_size  => $frame,
        items       => $total,
        base_url    => $url,
        mode        => $mode,
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
