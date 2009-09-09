package Paquette::Schema::Result::OrdersItem;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("orders_item");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "order_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "order_sku",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
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
__PACKAGE__->add_unique_constraint("order_sku", ["order_sku"]);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-09-09 08:43:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pMogzpKV3ka9tudwa6+4Qw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
