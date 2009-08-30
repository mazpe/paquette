package Paquette::Schema::Result::Lead;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("lead");
__PACKAGE__->add_columns(
  "lead_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "first_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "last_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "address1",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "address2",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "city",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "state",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 2 },
  "zip_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "country",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 2 },
  "phone",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "message",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
);
__PACKAGE__->set_primary_key("lead_id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-28 23:18:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OrieJ2s0uvHYW+aAH2/ihQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
