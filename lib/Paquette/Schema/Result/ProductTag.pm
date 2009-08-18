package Paquette::Schema::Result::ProductTag;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("product_tag");
__PACKAGE__->add_columns(
  "product_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "tag_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
);
__PACKAGE__->set_primary_key("product_id", "tag_id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-18 07:15:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/SJgNXsMe+xRd+TUFAjy7g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
