package Utils;

use strict; use warnings;

use Constant;

sub check_csrf_token {
    my ($app) = @_;

    if ($app->request->is_post) {
        my $csrf_token = $app->request->body_parameters->{csrf_token};
        if (
            not (
                $csrf_token
                or $app->with_plugin('Dancer2::Plugin::CSRF')->validate_csrf_token($csrf_token)
            )
        ) {
            $app->send_error('Page expired', 419)
        }
    }

    return;
}

sub set_active_menu_item {
    my ($items, $path) = @_;

    for my $item (@{ $items }) {
        if ($item->{path} eq $path) {
            $item->{active} = 1;
        }
    }

    return $items;
}

sub table {
    my (%args) = @_;

    my $name     = $args{name};
    my $headings = $args{headings};
    my $rows     = $args{rows};

    return {
        name     => $name,
        headings => $headings,
        rows     => $rows,
    };
}

sub table_row_data {
    my (%args) = @_;

    my $value = $args{value};
    my $type  = $args{type};

    return {
        value => $value,
        type  => $type,
    };
}

sub table_row_action {
    my (%args) = @_;

    my $name    = $args{name};
    my $type    = $args{type};
    my $route   = $args{route};
    my $confirm = $args{confirm};

    return {
        name    => $name,
        type    => $type,
        route   => $route,
        confirm => $confirm,
    };
}

1;
