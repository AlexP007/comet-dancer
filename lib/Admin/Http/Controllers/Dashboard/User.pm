package Admin::Http::Controllers::Dashboard::User;

use Dancer2 appname  =>'Admin';

use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Forms::UserForm;

use feature 'try';
no warnings 'experimental::try';

sub index {
    my $pagination = pagination(
        total => rset('User')->count,
        page  => query_parameters->{page},
        url   => route('users'),
    );

    my @users = rset('User')->users_with_roles(
        page => $pagination->{page},
        size => $pagination->{size},
    );

    my @rows  = map {
        {
            id      => $_->username,
            data    => [
                { value => $_->username,   type => 'text'   },
                { value => $_->email,      type => 'text'   },
                { value => $_->name,       type => 'text'   },
                { value => $_->deleted,    type => 'toggle' },
                { value => $_->role_names, type => 'list'   },
            ],
            actions => $_->active ? [
                {
                    name    => 'edit',
                    type    => 'link',
                    route   => route('user_edit', $_->username)
                },
                {
                    name    => 'deactivate',
                    type    => 'form',
                    confirm => {
                        heading => 'Are you sure?',
                        message => sprintf('User: %s will be deactivated.', $_->username),
                    },
                    route   => route('user_deactivate', $_->username)
                },
            ] : [
                {
                    name    => 'activate',
                    type    => 'form',
                    confirm => {
                        heading => 'Are you sure?',
                        message => sprintf('User: %s will be activated.', $_->username),
                    },
                    route   => route('user_activate', $_->username)
                },
            ],
        }
    } @users;

    my $table = {
        name     => 'user',
        headings => [ qw(Username Email Name Status Roles) ],
        rows     => \@rows,
    };

    template 'admin/dashboard/users/index', {
        title      => 'Users',
        table      => $table,
        pagination => $pagination,
        routes     => {
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
    my $profile = Admin::Http::Forms::UserForm->new(
        require_username => 1,
        require_password => 1,
    );

    if (validate profile => $profile) {
        my $v = validated;

        try {
            my $roles = prepare_roles(
                ref $v->{roles} eq 'ARRAY' ? @{ $v->{roles} } : ($v->{roles})
            );

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

                my $message = sprintf('User: %s created', $v->{username});

                info          $message;
                flash_success $message;
                redirect route('users');
            }
        } catch ($e) {
            error       $e;
            flash_error $e;
        }
    }

    redirect back;
}

sub edit {
    my $username = route_parameters->{user};

    my $user = get_user_details $username;

    if ($user) {
        my @roles = map {
            {
                text     => $_->role,
                value    => $_->role,
                selected => $user->has_role($_->role),
            }
        } (rset('Role')->all);

        template 'admin/dashboard/users/form', {
            title           => 'Update User',
            user            => $user,
            roles           => \@roles,
            button          => 'Update',
            action          => route('user_update', $user->username),
            freeze_username => 1,
        }
    }
    else {
        my $message = sprintf('User: %s not found', $username);

        warning    $message;
        send_error $message => 404;
    }
}

sub update {
    my $username = route_parameters->{user};
    my $user     = get_user_details $username;

    my $profile  = Admin::Http::Forms::UserForm->new(
        require_username => 0,
        require_password => 0,
        current_email    => $user->email,
    );

    if (validate profile => $profile) {
        my $v = validated;

        try {
            my $roles = prepare_roles(
                ref $v->{roles} eq 'ARRAY' ? @{ $v->{roles} } : ($v->{roles})
            );

            update_user($username,
                name     => $v->{name},
                email    => $v->{email},
                roles    => $roles,
            );

            if ($v->{password}) {
                user_password(
                    username     => $username,
                    new_password => $v->{password},
                );
            }

            my $message = sprintf('User: %s updated', $username);

            info          $message;
            flash_success $message;
            redirect      route('users');
        } catch ($e) {
            error         $e;
            flash_error   $e;
        }
    }

    redirect back;
}

### Utils ###

sub prepare_roles {
    my $roles = {};

    for my $role (@_) {
        $roles->{$role} = 1;
    }

    return $roles;
}

sub deactivate {
    my $user = route_parameters->{user};

    try {
        deactivate_user $user;

        my $message = sprintf('User: %s deactivated', $user);

        info          $message;
        flash_success $message;
        redirect      route('users');
    } catch ($e) {
        error         $e;
        flash_error   $e;
        redirect      back;
    }
}

sub activate {
    my $user = route_parameters->{user};

    try {
        activate_user $user;

        my $message = sprintf('User: %s activated', $user);

        info          $message;
        flash_success $message;
        redirect      route('users');
    } catch ($e) {
        error         $e;
        flash_error   $e;
        redirect      back;
    }
}

true;
