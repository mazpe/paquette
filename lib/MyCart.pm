package MyCart;

use Moose;
use MooseX::Types::Moose qw(Str Int ArrayRef);
use namespace::autoclean;
use Data::Dumper;

has 'user'      => ( is => 'ro', required => 1, weak_ref => 1 );
has 'session'   => ( is => 'ro', required => 1, weak_ref => 1 );
has 'schema'    => ( is => 'rw', required => 1, handles => [qw / resultset /] );
has 'sku'       => ( is => 'ro', isa => Str );
has 'qty'       => ( is => 'ro', isa => Int, default => 0 );

has '_items'    => ( is => 'ro', isa => ArrayRef, lazy_build => 1 );

sub _build_items { # Inflate the items from either the sessin or the DB 
}

sub get_items_in_cart { # Return list of items 
    my $self = shift;

    my %items_in_cart;

    if ($self->user) {
    # Get items in cart from db


    } else {
    # Get items in cart from session
    
        my $items_in_session = $self->session->{cart};

        foreach my $sku ( keys %$items_in_session ) {

            my $sku_data_from_db 
                = $self->resultset('Product')->get_item_by_sku($sku);

            $items_in_cart{$sku} = { 
                sku     => $sku, 
                qty     => $items_in_session->{$sku},
                name    => $sku_data_from_db->name,
                price   => $sku_data_from_db->price,
            }; 

        }

    }

    return %items_in_cart ? \%items_in_cart : 0;
}

# Adds items to the shopping cart
sub add_items_to_cart {  
    my ( $self, $args ) = @_; 

    if ($self->user) {
    # Add to db 

    } else {
    # Add to session

        # Check that we do have this item
        if ( $self->resultset('Product')->get_item_by_sku($args->{sku}) ) {
        # Found sku on db

            # We add a new item to our cart.
            $self->session->{cart}{$args->{sku}} += $args->{qty};

        } else {
        # Sku not found 

        }
    }

    #print Dumper $self->session;

}

# Removes items from the shopping cart
sub remove_items_from_cart { 
    my ( $self, $args ) = @_;

    if ( $self->user ) {
    # Delete item from cart in the db

    } else {
    # Delete item from cart in session

        if ( $self->session->{cart}{$args->{sku}} ) {
        # Found sku in session

            delete($self->session->{cart}{$args->{sku}});

        } else {
        # Sku not found in session

        }
    }

}

# Update items in the shopping cart
sub update_items_in_cart {
    my ( $self, $args ) = @_;

    my $items = $args->{items};

    if ( $self->user ) {
    # Update items in cart in db


    } else {
    # Update items in cart in session

        # Get each of our items sku
        foreach my $key ( keys %$items ) {
            #print $key ." => ". $args{items}{$key} ."\n";

            # Update session's qty
            $self->session->{cart}{$key} = $args->{items}->{$key};

            #print $self->session->{cart}{$key};
        }        

    }

    return 1;
}

# Clear items in the shopping cart
sub clear_cart {
    my $self = shift; 

    if ( $self->user ) {
    # Clear cart in db
        

    } else {
    # Clear cart in session 
        
        # Clear session
        $self->session->{cart} = {};

    }

}

sub checkout { # This will persist the cart, and place the order 
}

1;
