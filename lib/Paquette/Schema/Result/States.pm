package Paquette::Schema::Result::States;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("states");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "abbr",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-09-09 08:43:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9wKzstykgVxqsNj+8D6xmg

# Set ResultSet Class
__PACKAGE__->resultset_class('Paquette::Schema::ResultSet::States');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
