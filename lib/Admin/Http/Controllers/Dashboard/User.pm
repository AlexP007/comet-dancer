package Admin::Http::Controllers::Dashboard::User;

use Dancer2 appname  =>'Admin';

use Constant;
use List::Util qw(any);
use String::Util qw(trim);
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::FormValidator;
use Dancer2::Plugin::Auth::Extensible;
use Admin::Http::Forms::UserForm;
use Admin::Http::Forms::UserSearchForm;

use feature 'try';
no warnings 'experimental::try';

sub index {
    my $rset = rset('User');
    my $page = 1;

    if (validate profile => Admin::Http::Forms::UserSearchForm->new) {
        my $validated = validated;

        $page = $validated->{page} > 0
            ? $validated->{page}
            : $page;

        $rset = _user_search($rset,
            role   => $validated->{role},
            active => $validated->{active},
            search => trim($validated->{q}),
        );
    }
    else {
        my $errors = errors;
        flash_error [ values(%{ $errors }) ];
    }

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

    my @roles = rset('Role')->all;

    my $table = {
        name     => 'user',
        headings => [ qw(Username Email Name Status Roles) ],
        rows     => _users_to_table(\@users),
    };

    template 'admin/dashboard/users/index', {
        title      => 'Users',
        table      => $table,
        pagination => $pagination,
        roles      => _roles_to_select(\@roles),
        routes     => {
            user_create => route('user_create'),
        }
    }
}

sub create {
    my @roles = rset('Role')->all;

    template 'admin/dashboard/users/form', {
        title  => 'Create User',
        button => 'Create',
        roles  => _roles_to_select(\@roles),
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
    my $user     = get_user_details $username;

    if ($user) {
        my @roles = rset('Role')->all;

        template 'admin/dashboard/users/form', {
            title           => 'Update User',
            user            => $user,
            roles           => _roles_to_select(\@roles, $user->role_names),
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
        my $validated = validated;

        try {
            my $user    = _user_update($username, %{ $validated });
            my $message = sprintf('User: %s updated', $user->username);

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

sub _user_search {
    my ($rset, %args) = @_;

    my $role   = $args{role};
    my $active = $args{active};
    my $search = $args{search};

    $rset = $rset->users_with_roles;

    if ($role) {
        my $username_rset = $rset->users_by_role($role);

        $rset = $rset->search_rs({
            username =>  {
                -in => $username_rset->get_column('username')->as_query,
            },
        });
    }

    if ($active eq '1' or $active eq '0') {
        $rset = $rset->search_rs({
            deleted => not $active,
        });
    }

    if ($search) {
        $rset = $rset->search_rs([
            { username => { -like => "%$search%" } },
            { name     => { -like => "%$search%" } },
            { email    => { -like => "%$search%" } },
        ]);
    }

    return $rset;
}

sub _users_to_table {
    my ($users) = @_;

    my @rows = map {
        {
            id      => $_->username,
                data    => [
                    { value => $_->username,   type => 'text'   },
                    { value => $_->email,      type => 'text'   },
                    { value => $_->name,       type => 'text'   },
                    { value => $_->active,     type => 'toggle' },
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
    } @{ $users };

    return \@rows
}

sub _roles_to_select {
    my ($roles, $selected) = @_;

    my @select = map {
        {
            text     => $_->role,
            value    => $_->role,
            selected => _set_selected($_->role, $selected),
        }
    } @{ $roles };

    return \@select;
}

sub _set_selected {
    my ($role, $selected) = @_;

    return $selected
        ? any { $_ eq $role } @{ $selected }
        : undef;
}

sub _user_store {
    my (%args) = @_;

    my $roles_or_role = $args{roles};
    my $username      = $args{username};
    my $password      = $args{password};
    my $name          = $args{name};
    my $email         = $args{email};

    my $roles = _prepare_roles(
        ref $args{roles} eq 'ARRAY' ? @{ $roles_or_role } : ($roles_or_role)
    );

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

sub _user_update {
    my ($username, %args) = @_;

    my $roles_or_role = $args{roles};
    my $password      = $args{password};
    my $name          = $args{name};
    my $email         = $args{email};

    my $roles = _prepare_roles(
        ref $args{roles} eq 'ARRAY' ? @{ $roles_or_role } : ($roles_or_role)
    );

    my $user = update_user($username,
        name     => $name,
        email    => $email,
        roles    => $roles,
    );

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

### Utils ###

sub _prepare_roles {
    my $roles = {};

    for my $role (@_) {
        $roles->{$role} = 1;
    }

    return $roles;
}

true;
