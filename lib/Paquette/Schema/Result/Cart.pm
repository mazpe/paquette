package Paquette::Schema::Result::Cart;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("cart");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "session_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "customer_id",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "shipping_type",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "shipping_amount",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 5 },
  "payment_type",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "payment_amount",
  { data_type => "DECIMAL", default_value => undef, is_nullable => 1, size => 5 },
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
__PACKAGE__->add_unique_constraint("session_id", ["session_id"]);
__PACKAGE__->add_unique_constraint("customer_id", ["customer_id"]);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-11 15:37:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1m/yQ762aegjTteVdYa95w
__PACKAGE__->add_columns(
    "created",
    { data_type => 'datetime', set_on_create => 1 },
    "updated",
    { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
);

__PACKAGE__->has_many(
    cart_items => 'Paquette::Schema::Result::CartItem',
    { 'foreign.cart_id' => 'self.id' },
    { cascade_delete => 0 }
);


# You can replace this text with custom content, and it will be preserved on regeneration
1;
