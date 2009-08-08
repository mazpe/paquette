package Paquette::Schema::Result::Product;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("product");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "category_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "sku",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 25,
  },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
  "url_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "brief_description",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "price",
  {
    data_type => "DECIMAL",
    default_value => "0.00",
    is_nullable => 0,
    size => 9,
  },
  "photo",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 1 },
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
__PACKAGE__->add_unique_constraint("sku", ["sku"]);
__PACKAGE__->add_unique_constraint("url_name", ["url_name"]);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-07 22:45:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1CvC3aovqopKa9g8KHPpAg
__PACKAGE__->has_one(category => 'Paquette::Schema::Result::Categories',
    { 'foreign.id' => 'self.category_id' },
    { cascade_delete => 0 }
);


# You can replace this text with custom content, and it will be preserved on regeneration
1;
