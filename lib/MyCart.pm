package MyCart;

use Moose;
use MooseX::Types::Moose qw(Str Int ArrayRef);
use namespace::autoclean;
use Data::Dumper;

has 'user'          => ( is => 'ro', required => 1, weak_ref => 1 );
has 'session'       => ( is => 'ro', required => 1, weak_ref => 1 );
has 'session_id'    => ( is => 'ro', required => 1, weak_ref => 1 );
has 'schema'    => ( is => 'rw', required => 1, handles => [qw / resultset /] );
has 'sku'       => ( is => 'ro', isa => Str );
has 'qty'       => ( is => 'ro', isa => Int, default => 0 );

has '_items'    => ( is => 'ro', isa => ArrayRef, lazy_build => 1 );

sub create_cart {
    my ( $self, $customer_id ) = @_;
    my $cart;
    my $cart_args;

    # Create a hashref with our cart arguments 
    $cart_args = ( { 
        session_id  => $self->session_id,
        customer_id => $customer_id,
    } );

    # Create the Cart
    $cart = $self->resultset('Cart')->create( $cart_args );
    
    return $cart;
}

sub get_cart {
    my ( $self, $args ) = @_;
    my $cart;

    # Check how we are going to find our cart
    if ($args->{customer_id}) {
    # by cusomter id
        
        $cart = $self->resultset('Cart')->get_cart_by_customer_id(
            $args->{customer_id}
        );

    } elsif ($args->{cart_id}) {

        $cart = $self->resultset('Cart')->get_cart_by_cart_id(
            $args->{cart_id}
        );

    } elsif ($args->{session_id}) {

        $cart = $self->resultset('Cart')->get_cart_by_session_id(
            $args->{session_id}
        );

    }


    return $cart;
}


sub get_cart_id {
    my $self            = shift;
    my $session_id      = $self->session_id;
    my $cart_args;
    my $cart_id;


    if ( $self->session->{cart_id} gt 0 ) {
    # There is a cart_id in the session

        # Get our Cart ID from session
        $cart_id = $self->session->{cart_id};

        # Set arguments for validation
        $cart_args = {
            cart_id     => $cart_id,
            session_id  => $session_id,
        };

        # Check if Cart ID still valid, if not create a new cart
        unless ( $self->resultset('Cart')->validate_cart_id($cart_args) == 1 ) {
        # Cart_id from session not valid

            $cart_id = create_cart($self)->id;
        }

    } else {
    # Card ID not found

        # Create Cart ID
        $cart_id = create_cart($self)->id;

    }
        
    $self->session->{cart_id} = $cart_id;

    return $cart_id;
}

# Adds items to the shopping cart
sub add_items_to_cart {
    my ( $self, $args ) = @_;
    my $cart_id         = get_cart_id($self);
    my $item;

    # Check that we do have this item
    if ( $self->resultset('Product')->get_item_by_sku($args->{sku}) ) {
    # Sku found on db

        $item = {
            cart_id     => $cart_id,
            cart_sku    => $cart_id.''.$args->{sku},
            sku         => $args->{sku},
            quantity    => $args->{qty},
        };

        # Add item to cart
        $self->resultset('CartItem')->add_item( $item );
        
    } else {
    # Sku not found

    }

}

sub sum_items_in_cart {
    my $self = shift;
    my $cart_id         = get_cart_id($self);
    my $total_amount;

    $total_amount
        = $self->resultset('CartItem')->sum_items($cart_id);

    return $total_amount;
}

# Return list of items
sub get_items_in_cart { 
    my $self            = shift;
    my $cart_id         = get_cart_id($self);

    my $items_in_cart 
            = $self->resultset('CartItem')->get_items( $cart_id );

    return $items_in_cart ? $items_in_cart : 0;
}

# Removes items from the shopping cart
sub remove_items_from_cart { 
    my ( $self, $args ) = @_;
    my $cart_id         = get_cart_id($self);
    my $cart_sku        = $cart_id.''.$args->{sku};

    # Remove particular item from cart
    $self->resultset('CartItem')->remove_item($cart_sku);

    return 1;
}

# Update items in the shopping cart
sub update_items_in_cart {
    my ( $self, $args ) = @_;
    my $cart_id         = get_cart_id($self);
    my $items           = $args->{items};

    # Loop through each sku
    foreach my $sku ( keys %$items ) {

        # Create our cart_sku identifyer
        my $cart_sku = $cart_id.''.$sku;

        # Update item in the cart
        my $item = $self->resultset('CartItem')->update_item( {
            quantity    => $items->{$sku},
            cart_sku    => $cart_sku,
        } );

    }

    return 1;
}

# Clear items in the shopping cart
sub clear_cart {
    my $self            = shift; 
    my $cart_id         = get_cart_id($self);

    # Clear our shopping cart items
    $self->resultset('CartItem')->clear_items($cart_id);

    return 1;
}

sub assign_cart {
    my $self = shift;
    my $customer_id;
    my $cart_by_customer_id;
    my $cart_id_by_customer_id;
    my $cart_by_session_id;
    my $cart_id_by_session_id;
    my %cart_args;

    if ( $self->user ) {
    # Logged in

        # Get our customer id
        $customer_id = $self->user->id;

        # Do we own a cart? whats our cart_id
        $cart_by_customer_id
            = $self->resultset('Cart')->get_cart_by_customer_id( $customer_id);
        $cart_id_by_customer_id 
            = $cart_by_customer_id->id if $cart_by_customer_id;

        # Do we have an anonymous cart? what our anonymous cart id
        $cart_by_session_id
            = $self->resultset('Cart')->get_cart_by_sid( $self->session_id);
        $cart_id_by_session_id 
            = $cart_by_session_id->id if $cart_by_session_id;

        # Check that we have 2 seperate carts
        if ($cart_id_by_customer_id) {
        # Found customer cart

            if ( $cart_id_by_customer_id ne $cart_id_by_session_id ) {
            # Seperate carts

                # Update Cart Items to the customer_cart
                $self->resultset('CartItem')->set_items_cart_sku(
                    $cart_id_by_customer_id,
                    $cart_id_by_session_id,
                );

                # Delete anonymous cart
                $self->resultset('Cart')->delete($cart_id_by_session_id);

                # Update our customer cart with our current session
                %cart_args = (
                    id          => $cart_id_by_customer_id,
                    session_id  => $self->session_id,
                );
                $self->resultset('Cart')->update(\%cart_args);

            }

        } elsif ($cart_id_by_session_id) {
        # Found session cart
            # Update our customer cart with our current session
            %cart_args = (
                id              => $cart_id_by_session_id,
                session_id      => $self->session_id,
                customer_id     => $customer_id,
            );

            $self->resultset('Cart')->update(\%cart_args);

        }
        
        
    } else {
    # Not logged in


    }

}

sub set_shipping {
    my ( $self, $args ) = @_;
    my $cart_id         = get_cart_id($self);

    $args->{id} = $cart_id;
    delete $args->{submit};
    
    # Set shipping
    $self->resultset('Cart')->set_shipping_info($args);
}

sub set_payment {
    my ( $self, $args ) = @_;
    my $cart_id         = get_cart_id($self);

    $args->{id} = $cart_id;
    delete $args->{submit};

    # Set payment
    $self->resultset('Cart')->set_payment_info($args);
}

sub total_items_in_cart {
    my $self            = shift;
    my $cart_id         = get_cart_id($self);


    my $total_items = $self->resultset('CartItem')->count_items($cart_id);

    return $total_items;
}

sub destroy_cart {
    my $self            = shift;
    my $cart_id         = get_cart_id($self);

    # Destroy the cart items
    $self->resultset('CartItem')->clear_items($cart_id);
    
    # Destroy the cart;
    $self->resultset('Cart')->delete($cart_id);


}

1;
