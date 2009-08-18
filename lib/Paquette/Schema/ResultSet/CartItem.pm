package Paquette::Schema::ResultSet::CartItem;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use Data::Dumper;

=head1 NAME

Paquette::Schema::ResultSet::CartItem - ResultSet 

=head1 DESCRIPTION

CartItems ResultSet

=cut

sub add_item {
    my ( $self, $args ) = @_;

    my $item = $self->find_or_new ( $args, { key => 'cart_sku' } );

    unless ( $item->in_storage ) {
    # Item not found in cart
    
        # Add item to cart 
        $item->insert;
    
    } else {
    # Item found in cart

        # Add to the current quantity in the cart
        $args->{quantity} = $item->quantity + $args->{quantity};
    
        # Update item in cart
        $item->update( $args );
    
    }

    return $item;
}

sub get_items {
    my ( $self, $args ) = @_;
    my @items;

    # Get all the items in the shopping cart
    #$items = $self->find( $args, { key => 'cart_id' } );
    @items = $self->search({ 'cart_id' => $args });

    return \@items;
}

sub count_items {
    my ( $self, $args ) = @_;
    my $items;

    # Get all the items in the shopping cart
    $items = $self->search({ 'cart_id' => $args });

    return $items->count;
}

sub set_items_cart_id {
    my ( $self, $cart_id, $old_cart_id ) = @_;
    my $cart_items;

    $cart_items = $self->search( { cart_id => $old_cart_id } );

    $cart_items->update( { cart_id => $cart_id } );

}

sub set_items_cart_sku {
    my ( $self, $cart_id, $old_card_id ) = @_;
    my $rs;
    my $cart_sku;
    my $old_cart_sku;

    # Resulet with items in our new cart
    $rs = $self->search( { cart_id => $cart_id } );

    # Loop through all items in cart
    while ( my $item = $rs->next ) {
    
        # New cart_sku
        $cart_sku = $cart_id. '' .$item->sku;

        # Check If our item SKU is already on the database
        if (my $found_item = $self->find( $cart_sku, { key => 'cart_sku' } ) ) {
            
            # Delete old item if QTY is < new item QTY
            if ( $found_item->quantity > $item->quantity ) {

                # Delete 
                $item->delete;

            } 

        } else {

                $item->update( { cart_sku => $cart_sku } );
        }

   } 

}
    

sub update_item {
    my ( $self, $args ) = @_;

    # Find our item
    my $item = $self->find( $args, { key => 'cart_sku' } );

    # Update item if we were able to find it
    $item->update($args) if ($item);
    
    # Return item hashref
    return $item;
}

sub remove_item {
    my ( $self, $args ) = @_;

    my $item = $self->find( $args, { key => 'cart_sku' } );

    $item->delete if ($item);

    return $item;
}

sub clear_items {
    my ( $self, $args ) = @_;
    my $items;

    # Find all items in the cart for cart_id
    $items = $self->search( { cart_id => $args } );

    # Delete items from resultset
    $items->delete;

    return;
}

=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

