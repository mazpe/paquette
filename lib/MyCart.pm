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
    my $self            = shift;
    my $customer_id     = $self->user->id if ($self->user);
    my $cart;

    # Check for a cart with the same session id
    if ( $self->resultset('Cart')->get_cart($self->session_id) ) {
    # Found cart with the same Session ID

        # Get our cart id from database
        $cart = $self->resultset('Cart')->get_cart($self->session_id);

    } else {
    # Found no cart, creating one

        # Create a new cart
        $cart = create_cart( $self, $customer_id );

    }

    return $cart;
}

# Adds items to the shopping cart
sub add_items_to_cart {
    my ( $self, $args ) = @_;
    my $cart_id         = get_cart($self)->id;
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

# Return list of items
sub get_items_in_cart { 
    my $self            = shift;
    my $cart_id         = get_cart($self)->id;

    my $items_in_cart 
            = $self->resultset('CartItem')->get_items( $cart_id );

    return $items_in_cart ? $items_in_cart : 0;
}

# Removes items from the shopping cart
sub remove_items_from_cart { 
    my ( $self, $args ) = @_;
    my $cart_id         = get_cart($self)->id;
    my $cart_sku        = $cart_id.''.$args->{sku};

    # Remove particular item from cart
    $self->resultset('CartItem')->remove_item($cart_sku);

    return 1;
}

# Update items in the shopping cart
sub update_items_in_cart {
    my ( $self, $args ) = @_;
    my $cart_id         = get_cart($self)->id;
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
    my $cart_id         = get_cart($self)->id;

    # Clear our shopping cart items
    $self->resultset('CartItem')->clear_items($cart_id);

    return 1;
}

sub checkout { # This will persist the cart, and place the order 
}

1;
