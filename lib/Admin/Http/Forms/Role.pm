package Admin::Http::Forms::Role;

use v5.36;
use Dancer2 appname  =>'Admin';

use Moo;
use Dancer2::Plugin::DBIC;
use namespace::clean;

with 'Dancer2::Plugin::FormValidator::Role::Profile';

has rset => (
    is      => 'ro',
    lazy    => 1,
    default => sub { rset('Role') },
);

sub profile {
    no warnings 'qw';

    return {
        role => [ qw(required alpha_num length_max:32 unique:Role,role) ],
    };
}

sub save($self, $validated, $role = undef) {
    if ($role) {
        return $self->rset
            ->single({ role => $role })
            ->update({ role => $validated->{role} });
    }

    return $self->rset
        ->create({ role => $validated->{role} });
}

1;
