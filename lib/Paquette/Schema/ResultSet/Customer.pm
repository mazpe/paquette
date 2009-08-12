package Paquette::Schema::ResultSet::Customer;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use Data::Dumper;

=head1 NAME

Paquette::Schema::ResultSet::Customer - ResultSet 

=head1 DESCRIPTION

Customers ResultSet

=cut

sub create_customer {
    my ( $self, $args ) = @_;
    my $customer;
    if ( $args ) {
    # We have arguments

        $customer = $self->find_or_new(  $args , { key => 'email' }, );
        
        unless ( $customer->in_storage ) {
        # Customer not in store

            # Insert customer
            $customer->insert;

        }

    } else {
    # No arguments submited
    
    }

    return $customer ? $customer : 0;
}

sub get_customer_by_email {
    my ( $self, $email ) = @_;
    my $customer;

    if ( $email) {
    # We have arguments
    
        # Get our customer
        $customer = $self->find( $email, { key => 'email' } );

    } else {
    # No arguments submited

    }

    return $customer ? $customer : 0;
}



=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

