package Constant;

use strict; use warnings;

use constant {
    role_admin            => 'admin',
    roles_admin_access    => [ qw(admin manager) ],
    pagination_page_size  => 10,
    pagination_frame_size => 5,
};

1;
