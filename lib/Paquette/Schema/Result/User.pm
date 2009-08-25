package Paquette::Schema::Result::User;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("EncodedColumn", "InflateColumn::DateTime", "TimeStamp", "Core");
__PACKAGE__->table("user");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "username",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 25,
  },
  "password",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
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
  "age",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "birthdate",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 10 },
  "hobbies",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "address",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "city",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "state",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("username", ["username"]);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-24 23:56:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9mmJtyISD3WLuqnS5p0qjg

# Have the 'password' column use a SHA-1 hash and 10-character salt
# with hex encoding; Generate the 'check_password" method
__PACKAGE__->add_columns(
    'password' => {
        data_type           => "VARCHAR",
        size                => 255,
        encode_column       => 1,
        encode_class        => 'Digest',
        encode_args         => {salt_length => 10},
        encode_check_method => 'check_password',
    },
);

__PACKAGE__->has_many(
    map_user_roles => 'Paquette::Schema::Result::UserRole', 
    'user_id'
);
__PACKAGE__->many_to_many(roles => 'map_user_roles', 'role');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
