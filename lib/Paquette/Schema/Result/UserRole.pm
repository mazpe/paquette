package Paquette::Schema::Result::UserRole;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("user_role");
__PACKAGE__->add_columns(
  "user_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "role_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
);
__PACKAGE__->set_primary_key("user_id", "role_id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-31 23:58:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:k7oLcIGdCdPXEWbDQK2ZOw

__PACKAGE__->belongs_to(user => 'Paquette::Schema::Result::User', 'user_id');
__PACKAGE__->belongs_to(role => 'Paquette::Schema::Result::Role', 'role_id');


# You can replace this text with custom content, and it will be preserved on regeneration
1;
