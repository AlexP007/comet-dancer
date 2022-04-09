package Utils;

use strict;
use warnings;
use Constant;

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

1;
