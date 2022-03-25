#!/usr/bin/perl

use Dancer2;
use FindBin;
use Dancer2::Plugin::DBIC;
use DBIx::Class::Migration;
use lib "$FindBin::Bin/../lib";

my $action = shift;

my $migration = DBIx::Class::Migration->new(
    schema     => schema,
    target_dir => "$FindBin::Bin/../db",
);

for ($action) {
    $migration->prepare   if /^prepare$/;
    $migration->install   if /^install$/;
    $migration->downgrade if /^downgrade$/;
}
