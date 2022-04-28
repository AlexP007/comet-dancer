package Schema::Auth::ResultSet::User;

use strict;
use warnings FATAL => 'all';

use base 'DBIx::Class::ResultSet';

sub users_with_roles {
    return shift->search({}, {
        prefetch => { user_roles => 'role' },
        select   => [ qw(username name lastlogin email deleted) ]
    })->all;
}

1;