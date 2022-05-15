package Admin::Http::Controllers::Dashboard::User;

use Dancer2 appname  =>'Admin';

use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Forms::UserForm;

use feature 'try';
no warnings 'experimental::try';

sub index {
    my @users = rset('User')->users_with_roles;
    my @rows  = map {
        {
            id   => $_->username,
            data => [
                { value => $_->username,   type => 'text'   },
                { value => $_->email,      type => 'text'   },
                { value => $_->name,       type => 'text'   },
                { value => $_->deleted,    type => 'toggle' },
                { value => $_->role_names, type => 'list'   },
            ],
        }
    } @users;

    my $table = {
        name     => 'user',
        headings => [ qw(Username Email Name Status Roles) ],
        rows     => \@rows,
        actions  => [
            { name => 'edit',   type => 'link', confirm => 0, route => route('user_edit')   },
            { name => 'delete', type => 'form', confirm => 1, route => route('user_delete') },
        ],
    };

    template 'admin/dashboard/users/index', {
        title  => 'Users',
        table  => $table,
        routes => {
            user_create => route('user_create'),
        }
    }
}

sub create {
    my @roles = map { { text => $_->role, value => $_->role } } (rset('Role')->all);

    template 'admin/dashboard/users/form', {
        title  => 'Create User',
        button => 'Create',
        roles  => \@roles,
        action => route('user_store'),
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

                my $message = "User: $v->{username} created";

                info          $message;
                flash_success $message;
                redirect route('users');
            }
        } catch ($e) {
            error       $e;
            flash_error $e;
        };
    }

    redirect request->referer;
}

sub edit {
    my $username = route_parameters->{user};

    my $user = rset('User')->single({
        username => $username,
    });

    if ($user) {
        my @roles = map {
            {
                text     => $_->role,
                value    => $_->role,
                selected => $user->has_role($_->role),
            }
        } (rset('Role')->all);

        template 'admin/dashboard/users/form', {
            title  => 'Update User',
            user   => $user,
            roles  => \@roles,
            button => 'Update',
            action => route('user_update', $user->username),
        }
    }
    else {
        my $message = sprintf('User: %s not found', $username);

        warning    $message;
        send_error $message => 404;
    }
}

true;
