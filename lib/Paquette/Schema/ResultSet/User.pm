package Paquette::Schema::ResultSet::User;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

=head1 NAME

Paquette::Schema::ResultSet::User - ResultSet 

=head1 DESCRIPTION

Users ResultSet

=cut

sub create_user_account {
    my ( $self, $args ) = @_;
    my $user;

    if ( $args ) {
    # We have arguments

        $user = $self->find_or_new(  $args , { key => 'username' }, );

        unless ( $user->in_storage ) {
        # User not in store

            # Insert customer
            $user->insert;

        }

    } else {
    # No arguments submited
    
    }

    return $user ? $user : 0;
}

=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

