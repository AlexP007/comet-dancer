package Admin::Http::Forms::User;

use v5.36;
use Dancer2 appname  => 'Admin';

use Moo;
use Types::Standard qw(Str Bool HashRef);
use Dancer2::Plugin::Auth::Extensible;
use namespace::clean;

with 'Dancer2::Plugin::FormValidator::Role::ProfileHasMessages';

has require_username => (
    is       => 'ro',
    isa      => Bool,
    required => 1,
);

has require_password => (
    is       => 'ro',
    isa      => Bool,
    required => 1,
);

has current_email => (
    is        => 'ro',
    isa       => Str,
    predicate => 1,
);

has validated => (
    is        => 'rw',
    isa       => HashRef,
);

sub profile($self) {
    no warnings 'qw';

    my %profile = (
        username     => [ qw(alpha_num length_min:4 length_max:32 unique:User,username) ],
        name         => [ qw(length_min:1 length_max:127) ],
        email        => [ qw(required email length_max:127) ],
        password     => [ qw(password_simple length_max:40) ],
        password_cnf => [ qw(required_with:password same:password) ],
        roles        => [ qw(required) ]
    );

    if ($self->require_username) {
        unshift @{ $profile{username} }, 'required';
    }

    if ($self->require_password) {
        unshift @{ $profile{password} }, 'required';
    }

    return \%profile;
}

around hook_before => sub($orig, $self, $profile, $input) {
    # User creation.
    # If email not equals current user email, add unique validator for it.
    if (
        $self->has_current_email
        and $input->{email} ne $self->current_email
    ) {
        push @{ $profile->{email} }, 'unique:User,email';
    }

    return $orig->($self, $profile, $input);
};

sub messages {
    return {
        email => {
            unique => {
                'en' => 'This email is not allowed, please try another one'
            }
        },
        password_cnf => {
            required_with => {
                en => 'Confirm Password is required',
            },
            same => {
                en => 'Confirm Password must be the same as Password',
            },
        }
    }
}

sub save($self, $validated, $username = undef) {
    $self->validated($validated);

    my $user;
    my $roles         = $self->_prepare_roles;
    my $name          = $validated->{name};
    my $email         = $validated->{email};
    my $password      = $validated->{password};

    # If we have username, we update user
    if ($username) {
        $user = update_user($username,
            name     => $name,
            email    => $email,
            roles    => $roles,
        );
    }
    else {
        $username = $validated->{username};
        $user = create_user(
            username => $username,
            name     => $name,
            email    => $email,
            roles    => $roles,
        );
    }

    if ($user) {
        if ($password) {
            user_password(
                username     => $username,
                new_password => $password,
            );
        }

        return $user;
    }

    return undef;
}

sub _prepare_roles($self) {
    my @roles = ref $self->validated->{roles} eq 'ARRAY'
        ? $self->validated->{roles}->@*
        : $self->validated->{roles};

    my $result = {};

    for my $role (@roles) {
        $result->{$role} = 1;
    }

    return $result;
}

true;
