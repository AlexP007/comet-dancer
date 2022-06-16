package Utils;

use v5.36;

use Constant;
use Paginator::Lite;

sub login_success_message($app) {
    return flash_success($app, 'Login succeeded');
}

sub logout_and_show_403($app) {
    $app->destroy_session;
    $app->send_error('Forbidden', 403);
}

sub flash_success($app, $message) {
    $app->with_plugin('Flash')->flash(success => $message);
    return;
}

sub flash_error($app, $message) {
    $app->with_plugin('Flash')->flash(error => $message);
    return;
}

sub set_active_menu_item($items, $path) {
    for my $item (@{ $items }) {
        if ($item->{link} eq $path) {
            $item->{active} = 1;
        }
    }

    return $items;
}

sub pagination(%args) {
    my $page   = $args{page};
    my $size   = $args{size};
    my $frame  = $args{frame};
    my $total  = $args{total};
    my $url    = $args{url};
    my $params = $args{params};
    my $mode   = 'query';

    my $paginator = Paginator::Lite->new({
        curr       => $page,
        page_size  => $size,
        frame_size => $frame,
        items      => $total,
        base_url   => $url,
        mode       => $mode,
        params     => $params,
    });

    my @controls;

    for my $i ($paginator->begin .. $paginator->end) {
        push @controls => {
            page => $i,
            url  => $paginator->page_url($i),
            curr => $paginator->curr == $i,
        };
    }

    return {
        page     => $paginator->curr,
        size     => $paginator->page_size,
        is_first => $paginator->curr == $paginator->first,
        is_last  => $paginator->curr == $paginator->last,
        prev_url => $paginator->prev_url,
        next_url => $paginator->next_url,
        controls => \@controls,
    };
}

sub table(%args) {
    my $name     = $args{name};
    my $headings = $args{headings};
    my $rows     = $args{rows};

    return {
        name     => $name,
        headings => $headings,
        rows     => $rows,
    };
}

sub table_row_data(%args) {
    my $value = $args{value};
    my $type  = $args{type};

    return {
        value => $value,
        type  => $type,
    };
}

sub table_row_action(%args) {
    my $name    = $args{name};
    my $type    = $args{type};
    my $show    = $args{show};
    my $route   = $args{route};
    my $confirm = $args{confirm};

    return {
        name    => $name,
        type    => $type,
        show    => $show,
        route   => $route,
        confirm => $confirm,
    };
}

sub select(%args) {
    my $text     = $args{text};
    my $value    = $args{value};
    my $selected = $args{selected};

    return {
        text     => $text,
        value    => $value,
        selected => $selected,
    }
}

1;
