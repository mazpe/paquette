package Paquette::Schema::ResultSet::OrdersItem;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use Data::Dumper;

=head1 NAME

Paquette::Schema::ResultSet::OrdersItem - ResultSet 

=head1 DESCRIPTION

OrdersItems ResultSet

=cut

sub add_item {
    my ( $self, $args ) = @_;

    my $item = $self->find_or_new ( $args, { key => 'order_sku' } );

    unless ( $item->in_storage ) {
    # Item not found in orders
    
        # Add item to orders 
        $item->insert;
    
    } else {
    # Item found in orders

        # Add to the current quantity in the orders
        $args->{quantity} = $item->quantity + $args->{quantity};
    
        # Update item in orders
        $item->update( $args );
    
    }

    return $item;
}

sub get_items {
    my ( $self, $args ) = @_;
    my @items;

    # Get all the items in the shopping orders
    #$items = $self->find( $args, { key => 'order_id' } );
    @items = $self->search({ 'order_id' => $args });

    return \@items;
}

sub count_items {
    my ( $self, $args ) = @_;
    my $items;

    # Get all the items in the shopping orders
    $items = $self->search({ 'order_id' => $args });

    return $items->count;
}

sub sum_items {
    my ( $self, $args ) = @_;
    my $rs;
    my $amount;

    $rs = $self->search( { 'order_id' => $args } );

    while ( my $item = $rs->next ) {
        $amount += $item->quantity * $item->price;
    }
    
    return $amount;
}

sub set_items_order_id {
    my ( $self, $order_id, $old_order_id ) = @_;
    my $order_items;

    $order_items = $self->search( { order_id => $old_order_id } );

    $order_items->update( { order_id => $order_id } );

}

sub set_items_order_sku {
    my ( $self, $order_id, $old_card_id ) = @_;
    my $rs;
    my $order_sku;
    my $old_order_sku;

    # Resulet with items in our new orders
    $rs = $self->search( { order_id => $order_id } );

    # Loop through all items in orders
    while ( my $item = $rs->next ) {
    
        # New order_sku
        $order_sku = $order_id. '' .$item->sku;

        # Check If our item SKU is already on the database
        if (my $found_item = $self->find( $order_sku, { key => 'order_sku' } ) ) {
            
            # Delete old item if QTY is < new item QTY
            if ( $found_item->quantity > $item->quantity ) {

                # Delete 
                $item->delete;

            } 

        } else {

                $item->update( { order_sku => $order_sku } );
        }

   } 

}

sub update_item {
    my ( $self, $args ) = @_;

    # Find our item
    my $item = $self->find( $args, { key => 'order_sku' } );

    # Update item if we were able to find it
    $item->update($args) if ($item);
    
    # Return item hashref
    return $item;
}

sub remove_item {
    my ( $self, $args ) = @_;

    my $item = $self->find( $args, { key => 'order_sku' } );

    $item->delete if ($item);

    return $item;
}

sub clear_items {
    my ( $self, $args ) = @_;
    my $items;

    # Find all items in the orders for order_id
    $items = $self->search( { order_id => $args } );

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

