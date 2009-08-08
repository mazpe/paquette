package Paquette::Schema::Result::CartItems;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("cart_items");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 36,
  },
  "cart",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 36,
  },
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
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-07 22:45:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:U70pamivU032nl8Shl+QsA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
