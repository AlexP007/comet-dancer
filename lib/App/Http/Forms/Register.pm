package App::Http::Forms::Register;

use v5.36;
use Dancer2 appname  => 'App';

use Moo;
use Dancer2::Plugin::Auth::Extensible;
use namespace::clean;

with 'Dancer2::Plugin::FormValidator::Role::ProfileHasMessages';

sub profile {
    no warnings 'qw';

    return {
        username     => [ qw(required alpha_num length_min:4 length_max:32 unique:User,username) ],
        email        => [ qw(required email length_max:127 unique:User,email) ],
        password     => [ qw(required password_simple length_max:40) ],
        password_cnf => [ qw(required_with:password same:password) ],
        confirm      => [ qw(required accepted) ],
    };
};

sub messages {
    return {
        email => {
            unique => {
                'en' => 'This email is not allowed, please use another one'
            }
        },
        password_cnf => {
            required_with => {
                en   => 'Confirm Password is required',
            },
            same     => {
                en => 'Confirm Password must be the same as Password',
            },
        }
    }
}

sub save($, $validated) {
    my $user = create_user(
        username => $validated->{username},
        email    => $validated->{email},
        roles    => { user => 1 },
    );

    if ($user) {
        user_password(
            username     => $user->username,
            new_password => $validated->{password},
        );
    }

    return $user;
}

1;
