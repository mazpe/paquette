package Paquette::Schema::ResultSet::Cart;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

=head1 NAME

Paquette::Schema::ResultSet::Cart - ResultSet 

=head1 DESCRIPTION

Carts ResultSet

=cut

sub create {
    my ( $self, $args ) = @_;

    my $cart = $self->find_or_new ( $args, { key => 'session_id' } );

    unless ( $cart->in_storage ) {
    # Cart not found
    
        # Create cart
        $cart->insert;
    
    } else {

        # Update cart
        $cart->update( $args );
    
    }

    return $cart;
}

sub get_cart {
    my ( $self, $args ) = @_;

    my $cart = $self->find( $args, { key => 'session_id' } );

    return $cart;
}

sub save_item_to_cart {
    my ( $self, $args ) = @_;

    my $item = $self->find_or_new( $args,  { key => 'session_sku' } );

    unless ( $item->in_storage ) {
    # Item not in cart 

        # Insert item 
        #print "insert item\n";
        $item->insert;

    } else {
    # Item already in cart
     
        #print "update item\n";
        $item->update( $args );

    }
    
    return $item ? $item : 0;
}

sub get_item_by_sku {
    my ( $self, $sku ) = @_;

    my $item = $self->find( { sku => $sku } );

    return $item ? $item : 0;
}

=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

