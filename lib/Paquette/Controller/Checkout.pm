package Paquette::Controller::Checkout;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Data::Dumper;

=head1 NAME

Paquette::Controller::Checkout - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 auto

Check if there is a user and, if not, forward to login page

=cut

sub authenticate : Local {
    my ($self, $c) = @_;

    if ($c->controller eq $c->controller('Checkout::Login')) {
        return 1;
    }

    # If a user doesn't exist, force login
    if (!$c->user_exists) {
        # Dump a log message to the development server debug output
        $c->log->debug('Checkout::auto User not found, fwd to /checkout/login');
        # Redirect the user to the login page
        $c->response->redirect($c->uri_for('/checkout/login'));
        # Retr 0 to cancel 'post-auto' processing and prevent use of application
        return 0;
    }

    # User found, so return 1 to continue with processing after this 'auto'
    return 1;
}


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
}

sub customer_info : Local {
    my ( $self, $c ) = @_;

    # Load our countries and states
    $c->stash->{countries}  = [$c->model('PaquetteDB::Countries')->all];
    $c->stash->{states}     = [$c->model('PaquetteDB::States')->all];

    # If customer is already logged in pull his customer information or load
    # registration page
    if ( $c->user_exists ) {
    # Customer logged in 
        
        # pull customer information from db
        my $a_customer 
            = $c->model('Customer')->get_customer($c->user->username);

        # fill form with customer info
        $c->stash->{customer} = $a_customer;

        # Load items from cart
        $c->stash->{cart_items} = $c->model('Cart')->get_items_in_cart;
        # Set the template to use
        $c->stash->{template} = 'checkout/customer_info.tt2';

    } else {
    # Customer not logged in
        
        # register
        # Load items from cart
        $c->stash->{cart_items} = $c->model('Cart')->get_items_in_cart;
        # Set the template to use
        $c->stash->{template}   = 'checkout/customer_info.tt2';

        # login
    }

}

sub customer_info_do : Local {
    my ( $self, $c ) =  @_;
    my $cart;
    my $customer;

    if ( $c->req->params->{submit} ) {

        if ( $c->user_exists ) {
        # Customer logged in
            
            # Assign our user the cart with we are working on
            $cart = $c->model('Cart')->assign_cart;

        } else {
        # Customer not logged in

            my $username = $c->req->params->{email};
            my $password = $c->req->params->{password};

            # Create customer object
            $customer = $c->model('Customer')->create_customer(
                $c->req->params
            );
            
            # Login customer
            if ( !$c->authenticate( { 
                username => $username, password => $password, 
            } ) ) 
            { 
                print "Authentication Failed\n";
                    
            }

            # Assign our user to the cart we are workig on
            $cart = $c->model('Cart')->assign_cart;

        }

        # Forward to shipping information
        $c->response->redirect(
                $c->uri_for( $self->action_for('shipping_info') )
            . '/' );

    } else {



    }
    
}

sub shipping_info : Local {
    my ( $self, $c ) = @_;

    $c->stash->{customer} 
        = $c->model('Customer')->get_customer($c->user->username);
    $c->stash->{template} = 'checkout/shipping_info.tt2';

}

sub shipping_info_do : Local {
    my ( $self, $c ) = @_;
    my @shipping_info;
    my $shipping;

    if ( $c->req->params->{submit} ) {
    # Form submited
     
        my @shipping_info = split(/:/, $c->req->params->{shipping});

        ## Set our shipping information
        $shipping = $c->model('Cart')->set_shipping( {
            shipping_type    => $shipping_info[0],
            shipping_amount  => $shipping_info[1]
        } );

        # Forward to shipping information
        $c->response->redirect(
                $c->uri_for( $self->action_for('payment_info') )
            . '/' );

    } else {
    # Form not subimited

    }


}

sub payment_info : Local {
    my ( $self, $c ) = @_;

    if (!$c->user_exists) {
        $c->response->redirect($c->uri_for('/customers/login'));
        return 0;
    }

    $c->stash->{customer}
        = $c->model('Customer')->get_customer($c->user->username);
    $c->stash->{template} = 'checkout/payment_info.tt2';
}

sub payment_info_do : Local {
    my ( $self, $c ) = @_;
    my @payment_info;
    my $payment;

    if (!$c->user_exists) {
        $c->response->redirect($c->uri_for('/customers/login'));
        return 0;
    }

    if ( $c->req->params->{submit} ) {
    # Form submited

        ## Set our shipping information
        $payment = $c->model('Cart')->set_payment( $c->req->params );

        # Forward to shipping information
        $c->response->redirect(
                $c->uri_for( $self->action_for('confirm_order') )
            . '/' );

    } else {
    # Form not subimited

    }

}

sub confirm_order : Local {
    my ( $self, $c ) = @_;

    if (!$c->user_exists) {
        $c->response->redirect($c->uri_for('/customers/login'));
        return 0;
    }


    # Load items from cart
    $c->stash->{cart_items} = $c->model('Cart')->get_items_in_cart;

    $c->stash->{customer}
        = $c->model('Customer')->get_customer($c->user->username);
    $c->stash->{cart}
        = $c->model('Cart')->get_cart;
    $c->stash->{template} = 'checkout/confirm_order.tt2';

}

sub process_order : Local {
    my ( $self, $c ) = @_;
    my $order;

    $order = $c->model('Checkout')->process_order;

    print $order;

}


=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
