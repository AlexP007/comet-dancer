package Admin::Http::Controllers::Dashboard::User;

use Dancer2 appname  =>'Admin';

use Constant;
use String::Util qw(trim);
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Forms::UserForm;
use Admin::Usecases::User::Queries::UserSearch;
use Admin::Usecases::User::Utils::UsersToTableStruct;

use feature 'try';
no warnings 'experimental::try';

sub index {
    my $page = query_parameters->{page} || 1;

    my $rset = Admin::Usecases::User::Queries::UserSearch->new(
        rset          => rset('User'),
        role          => query_parameters->{role},
        active        => query_parameters->{active},
        search_phrase => trim(query_parameters->{q}),
    )->invoke;

    my $pagination = pagination(
        total => $rset->count,
        page  => $page,
        size  => Constant::pagination_page_size,
        frame => Constant::pagination_frame_size,
        url   => route('users'),
    );

    my @users = $rset->search(undef, {
        page => $page,
        size => Constant::pagination_page_size,
    })->all;

    my @roles = map { { text => $_->role, value => $_->role } } (rset('Role')->all);

    my $rows = Admin::Usecases::User::Utils::UsersToTableStruct->new(
        users  => \@users,
        routes => {
            user_edit       => route('user_edit'),
            user_activate   => route('user_activate'),
            user_deactivate => route('user_deactivate'),
        },
    )->invoke;

    my $table = {
        name     => 'user',
        headings => [ qw(Username Email Name Status Roles) ],
        rows     => $rows,
    };

    template 'admin/dashboard/users/index', {
        title      => 'Users',
        table      => $table,
        pagination => $pagination,
        roles      => \@roles,
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
        my $validated = validated;

        try {
            my $user    = _user_store(%{ $validated });
            my $message = sprintf('User: %s created', $user->username);

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
            my $roles = _prepare_roles(
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

### Usecases ###

sub _user_store {
    my (%args) = @_;

    my $roles = _prepare_roles(
        ref $args{roles} eq 'ARRAY' ? @{ $args{roles} } : ($args{roles})
    );

    my $username = $args{username};
    my $password = $args{password};
    my $name     = $args{name};
    my $email    = $args{email};

    my $user = create_user(
        username => $username,
        name     => $name,
        email    => $email,
        roles    => $roles,
    );

    if ($user) {
        user_password(
            username     => $username,
            new_password => $password,
        );

        return $user;
    }

    return undef;
}

### Utils ###

sub _prepare_roles {
    my $roles = {};

    for my $role (@_) {
        $roles->{$role} = 1;
    }

    return $roles;
}

true;
