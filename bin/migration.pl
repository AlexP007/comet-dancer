#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";

use Dancer2 appname => 'Migration';
use Dancer2::Plugin::DBIC;
use DBIx::Class::Migration;

my ($action) = @ARGV;

my $migration = DBIx::Class::Migration->new(
    schema     => schema,
    target_dir => "$FindBin::Bin/../db",
);

for ($action) {
    $migration->status          if /^status$/;
    $migration->prepare         if /^prepare$/;
    $migration->install         if /^install$/;
    $migration->upgrade         if /^upgrade$/;
    $migration->downgrade       if /^downgrade$/;
    $migration->drop_tables     if /^drop_tables$/;
    $migration->dump_all_sets   if /^dump_sets$/;
    $migration->populate        if /^populate$/;
}
