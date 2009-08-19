package MyCheckout;

use Moose;
use MooseX::Types::Moose qw(Str Int ArrayRef);
use namespace::autoclean;
use Data::Dumper;

has 'user'      => ( is => 'ro', required => 1, weak_ref => 1 );
has 'session'   => ( is => 'ro', required => 1, weak_ref => 1 );
has 'session_id'   => ( is => 'ro', required => 1, weak_ref => 1 );
has 'schema'    => ( is => 'rw', required => 1, handles => [qw / resultset /] );

# process order
sub process_order {
    my $self = shift;

    convert_cart_to_order($self);
}

# convert cart to order
sub convert_cart_to_order {
    my $self = shift;
    my $customer_email = $self->user->username;
    my $cart;
    my $cart_items;
    my $customer;
    my %order_args;
    my $order;
    my $order_id;
    my %order_items;

    $customer
        = $self->resultset('Customer')->get_customer_by_email($customer_email);

    $cart = $self->resultset('Cart')->get_cart_by_cid($self->user->id);

    foreach my $key (keys %$customer) {
        $order_args{$key} = $customer->{$key};
    }

    foreach my $key (keys %$cart) {
        next if ($key eq 'session_id');
        $order_args{$key} = $cart->{$key};
    }

    # Fixing
    $order_args{customer_id} = $order_args{id};
    delete $order_args{id};
    $order_args{payment_amount} 
        = $self->resultset('CartItem')->sum_items($cart->{id});
    $order_args{payment_total}
        = $order_args{payment_amount} + $order_args{shipping_amount};

    # Create order
    $order = $self->resultset('Orders')->create(\%order_args);

    $order_id = $order->id;

    if ($order_id) {
        $cart_items = $self->resultset('CartItem')->get_items($cart->{id});

        foreach my $row ( @$cart_items ) {
            $order_items{order_id}  = $order_id;
            $order_items{order_sku} = $order_id.''.$row->sku;
            $order_items{sku}       = $row->sku;
            $order_items{quantity}  = $row->quantity;
            $order_items{price}     = $row->product->price;

            $self->resultset('OrdersItem')->add_item(\%order_items);
        }
    }


}

# process payment

# return customer authorization #

# email copy of order
 

1;
