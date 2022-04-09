package Utils;

use strict;
use warnings;
use Constant;
use Dancer2::Core::Error;

sub access_admin_only {
    my $app  = shift;
    my $path = $app->request->path;

    if (
        $path ne Constant::page_login
          and not $app->with_plugin('Dancer2::Plugin::Auth::Extensible')->user_has_role(Constant::role_admin)
    ) {
        $app->redirect(
            $app->request->uri_for(Constant::page_login, { return_url =>$path })
        );
    }

    return;
}

sub check_csrf_token {
    my $app  = shift;

    if ($app->request->is_post) {
        my $csrf_token = $app->request->body_parameters->{csrf_token};
        if (
            not (
                $csrf_token
                or $app->with_plugin('Dancer2::Plugin::CSRF')->validate_csrf_token($csrf_token)
            )
        ) {
            my $error = Dancer2::Core::Error->new(
                app      => $app,
                status   => 419,
                title    => 'Error 419 - Authentication Timeout',
                message  => 'Page expired',
            );

            $error->throw($app->response);
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

1;
