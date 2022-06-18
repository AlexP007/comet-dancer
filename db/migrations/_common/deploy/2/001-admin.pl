use v5.36;

use Dancer2 appname => 'Migration';
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Auth::Extensible;
use DBIx::Class::Migration::RunScript;

migrate {
    rset('Role')->create({ role => 'admin' });

    create_user(
        username => 'admin',
        roles    => { 'admin' => 1 },
    );

    user_password(
        username     => 'admin',
        new_password => 'pass1234',
    );
};

1;
