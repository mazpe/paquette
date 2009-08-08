package Paquette::Schema::Result::CartItem;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("cart_item");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "cart_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "sku",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 25,
  },
  "quantity",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 3 },
  "price",
  {
    data_type => "DECIMAL",
    default_value => "0.00",
    is_nullable => 0,
    size => 9,
  },
  "description",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "created",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
  "updated",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-07 22:45:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:R46HCQ4MEb1CDmKllQR8Kw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
