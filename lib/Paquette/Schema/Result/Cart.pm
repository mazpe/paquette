package Paquette::Schema::Result::Cart;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("cart");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 36,
  },
  "shopper",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 36,
  },
  "type",
  { data_type => "TINYINT", default_value => 0, is_nullable => 0, size => 3 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "description",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-07 22:45:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gyhE8Wec+PZdROjkxpCdpg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
