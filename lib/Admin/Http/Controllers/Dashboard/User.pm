package Admin::Http::Controllers::Dashboard::User;

use feature 'try';
use Dancer2 appname  =>'Admin';
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;
use Dancer2::Plugin::Deferred;
use Admin::Http::Forms::UserForm;
no warnings 'experimental::try';

sub index {
    my @users = rset('User')->users_with_roles;
    my @rows  = map {
        {
            id       => $_->username,
                data     => [
                    { value => $_->username,    name => 'username' },
                    { value => $_->email,       name => 'email'    },
                    { value => $_->name,        name => 'name'     },
                    { value => $_->deleted,     name => 'deleted'  },
                    { value => $_->roles_names, name => 'roles'    },
                ],
        }
    } @users;

    my $table = {
        headings => [ qw(Username Email Name Status Roles) ],
        rows     => \@rows,
    };

    template 'admin/dashboard/users', {
        title => 'Users',
        table => $table,
    }
}

sub create {
    my @roles_result = rset('Role')->all;
    my @roles = ();

    for my $role (@roles_result) {
        push @roles => { text => $role->role, value => $role->role },
    }

    template 'admin/dashboard/user_create', {
        title => 'Create user',
        roles => \@roles,
    }
}

sub store {
    if (validate profile => Admin::Http::Forms::UserForm->new) {
        my $v = validated;

        try {
            my @roles = ref $v->{roles} eq 'ARRAY' ? @{ $v->{roles} } : ($v->{roles});
            my $roles = {};

            for my $role (@roles) {
                $roles->{$role} = 1;
            }

            my $user = create_user(
                username => $v->{username},
                name     => $v->{name},
                email    => $v->{email},
                roles    => $roles,
            );

            if ($user) {
                user_password(
                    username     => $user->username,
                    new_password => $v->{password},
                );

                my $message = "User: $v->{username} created.";

                info $message;
                deferred success => $message;

                redirect '/dashboard/users'
            }
        } catch ($e) {
            error $e;
            deferred error => $e;
        };
    }

    redirect request->referer;
}

true;
