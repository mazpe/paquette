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
  "cart_sku",
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
__PACKAGE__->add_unique_constraint("cart_sku", ["cart_sku"]);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-31 00:54:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jwd0AzeDi4Oj7mOIE3iYbg
__PACKAGE__->add_columns(
    "created",
    { data_type => 'datetime', set_on_create => 1 },
    "updated",
    { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
);

__PACKAGE__->belongs_to(
    carts => 'Paquette::Schema::Result::Cart',
    'cart_id'
);
__PACKAGE__->belongs_to(
    products => 'Paquette::Schema::Result::Product',
    'sku'
);
__PACKAGE__->has_one(
    product => 'Paquette::Schema::Result::Product',
    { 'foreign.sku' => 'self.sku' },
    { cascade_delete => 0 }
);



# You can replace this text with custom content, and it will be preserved on regeneration
1;
