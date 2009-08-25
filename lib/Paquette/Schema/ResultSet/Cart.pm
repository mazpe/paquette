package Paquette::Schema::ResultSet::Cart;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use Data::Dumper;

=head1 NAME

Paquette::Schema::ResultSet::Cart - ResultSet 

=head1 DESCRIPTION

Carts ResultSet

=cut
sub create2 {
    my ( $self, $args ) = @_;

    my $cart = $self->find_or_new ( $args, { key => 'id' } );

    unless ( $cart->in_storage ) {
    # Cart not found

        # Create cart
        $cart->insert;

    }

    return $cart;
}

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

sub delete {
    my ( $self, $args ) = @_;
    my $cart;

    $cart = $self->find($args);

    $cart->delete if ($cart);

}

sub get_cart {
    my ( $self, $args ) = @_;
    my $cart;

    $cart = $self->find($args);

    return $cart;
}

sub validate_cart_id {
    my ( $self, $args ) = @_;

    # Cart_ID valid
    my $is_valid = $self->search( { 
        id => $args->{cart_id}, session_id => $args->{session_id}
    } );

    return $is_valid ;
    
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

sub attach_cart_to_customer {
    my ( $self, $args ) = @_;

    # Get our cart
    my $cart = $self->search( { id => $args->{cart_id} } );

    # if we find a cart then update
    if ( $cart == 1) {
        $cart->update( { customer_id => $args->{customer_id} } );
    }
    
}

sub get_cart_by_cid {
    my ( $self, $args ) = @_;
    my %cart;
    my $rs;

    $rs = $self->find( $args, { key => 'customer_id' } );

    %cart = $rs->get_columns if $rs;
   
    return \%cart;
}

sub get_cart_by_sid {
    my ( $self, $args ) = @_;
    my %cart;
    my $rs;

    $rs = $self->find( $args, { key => 'session_id' } );

    %cart = $rs->get_columns if $rs;

    return \%cart;
}

sub set_cart_info {

    my ( $self, $cart_id, $args ) = @_;
    my $cart;

    $cart = $self->find($cart_id);

    delete $args->{id};
    delete $args->{customer_id};
    delete $args->{session_id};
    delete $args->{created};
    delete $args->{updated};

    $cart->update( $args );

}

sub update {
    my ( $self, $args ) = @_;
    my $cart;

    $cart = $self->find($args->{id});

    $cart->update( $args );

}


sub set_shipping_info {
    my ( $self, $args ) = @_;

    # Find our cart
    my $cart = $self->find( $args->{id}  );

    # If we found our cart, update the shipping information
    if ( $cart ) { 
        $cart->update( {
            shipping_type   => $args->{shipping_type},
            shipping_amount => $args->{shipping_amount},
        } );
    }

}

sub set_payment_info {
    my ( $self, $args ) = @_;

    # Find our cart
    my $cart = $self->find( $args->{id} );

    # If we found our cart, update the shipping information
    if ( $cart ) {
        $cart->update( {
            payment_type            => $args->{payment_type},
            payment_amount          => $args->{payment_amount},
            payment_card_number     => $args->{payment_card_number},
            payment_expiration      => $args->{payment_expiration},
            payment_cvv             => $args->{payment_cvv},
            payment_paypal_email    => $args->{payment_paypal_email},
    
        } );
    }

}




=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

