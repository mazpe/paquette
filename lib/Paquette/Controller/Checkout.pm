package Paquette::Controller::Checkout;

use Moose;
use Data::Dumper;
BEGIN { extends 'Catalyst::Controller' }
use Paquette::Form::Checkout::Customer;
use Paquette::Form::Checkout::Shipping;
use Paquette::Form::Checkout::Payment;

has 'customer_form' => ( 
    isa => 'Paquette::Form::Checkout::Customer', 
    is => 'rw',
    lazy => 1, 
    default => sub { Paquette::Form::Checkout::Customer->new } 
);
has 'shipping_form' => (
    isa => 'Paquette::Form::Checkout::Shipping',
    is => 'rw',
    lazy => 1,
    default => sub { Paquette::Form::Checkout::Shipping->new }
);
has 'payment_form' => (
    isa => 'Paquette::Form::Checkout::Payment',
    is => 'rw',
    lazy => 1,
    default => sub { Paquette::Form::Checkout::Payment->new }
);




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

sub customer : Local {
    my ( $self, $c ) = @_;
    my $auth;
    my $customer;
    my $username;
    my $password;
    my $form;

    # Check if we are logged in
    if ($c->user_exists) {
    # Customer is logged in
        
        # Get our customer object row
        $customer = $c->model('Customer')->get_customer($c->user->id)
    } else {
    # Custmer is not logged it

        # Hold a new row in the database for our record
        $customer = $c->model('PaquetteDB::Customer')->new_result({})
    }

    # Set our template and form to use
    $c->stash( 
        cart_items  => $c->model('Cart')->get_items_in_cart,
        countries   => [$c->model('PaquetteDB::Countries')->all],
        states      => [$c->model('PaquetteDB::States')->all],
        template    => 'checkout/customer.tt2',
        form        => $self->customer_form,
    );
    
    # Process our form
    $form =  $self->customer_form->process (
        item            => $customer,
        params          => $c->req->params,
    );

    # If the form is processed then automatically authenticate the user. 
    # Else return the form with errors.
    if ( $form ) { 
    # The form was processed

        # Set our username and password for authentication
        $username    = $c->req->params->{email};
        $password    = $c->req->params->{password};

        # If username and password are set then authenticate user.
        # Else we would give an error_msg
        if ($username && $password) {
        # The username and password are set

            # Attempt to log the user in
            # Using searchargs to authenticate cause non-standard table layout
            # We can also use it to accept username or nickname
            my $auth = $c->authenticate(
            {   
                password    => $password,
                'dbix_class' => {
                    searchargs => [
                        {   
                            'email' => $username,
                        }
                    ]
                },
            }
            );
        }

        # If customer was authenticated, then redirect him to his account
        if ($auth || $c->user_exists) {

            # Assign cart_id/session_id to user
            $c->model('Cart')->assign_cart;

            # Forward to shipping
            $c->res->redirect( $c->uri_for($self->action_for('shipping')) );
        }

    } else { 
    # Username or password were not defined 

        # TODO: display error message via ->flash->{error_msg} ?
        # Mean while we will display a message in debug
        $c->log->debug("not submited");

        return;

    }

}

sub shipping : Local {
    my ( $self, $c ) = @_;
    my $auth;
    my $customer;
    my $cart;
    my $form;

    # If shipping has not been defined and the form has been submited,
    # display an error in the form.
    # Else parse the shipping parameter.
    if (!$c->req->params->{shipping} && $c->req->params->{submit}) {
        
        $c->flash->{form_error} = "Please select a shipping method";

        $c->res->redirect( $c->uri_for($self->action_for('shipping')) );
    } else {

        my @shipping_info = split(/:/, $c->req->params->{shipping});

        $c->req->params->{shipping_type}    = $shipping_info[0];
        $c->req->params->{shipping_amount}  = $shipping_info[1];

    }

    if ($c->user_exists) {
    # Customer is logged in
       
        # Get our customer object row
        $customer = $c->model('Customer')->get_customer($c->user->id)
    } 

    # Get the customer cart by his id
    $cart = $c->model('Cart')->get_cart({
        customer_id => $customer->id,
    });

    # Set our template and form to use
    $c->stash( 
        cart_items  => $c->model('Cart')->get_items_in_cart,
        customer    => $customer,
        template    => 'checkout/shipping.tt2',
        form        => $self->shipping_form,
    );
 
    # Process our form
    $form =  $self->shipping_form->process (
        item            => $cart,
        params          => $c->req->params,
    );

    # If the form is processed then we move to payment information. 
    # Else return the form with errors.
    if ( $form ) { 
    # The form was processed

        # Redirect to payment information
        $c->res->redirect( $c->uri_for($self->action_for('payment')) );

    } else { 
    # Username or password were not defined 

        # TODO: display error message via ->flash->{error_msg} ?
        # Mean while we will display a message in debug
        $c->log->debug("not submited");

        return;

    }

}

sub payment : Local {
    my ( $self, $c ) = @_;
    my $auth;
    my $customer;
    my $cart;
    my $form;

    if ($c->user_exists) {
    # Customer is logged in

        # Get our customer object row
        $customer = $c->model('Customer')->get_customer($c->user->id)
    }

    # Get the customer cart by his id
    $cart = $c->model('Cart')->get_cart({ customer_id => $customer->id, });

    # Set our template and form to use
    $c->stash(
        customer    => $customer,
        cart_items  => $c->model('Cart')->get_items_in_cart,
        amount      => $c->model('Cart')->sum_items_in_cart,
        template    => 'checkout/payment.tt2',
        form        => $self->payment_form,
    );

    # Process our form
    $form =  $self->payment_form->process (
        item            => $cart,
        params          => $c->req->params,
    );

    # If the form is processed then we move to payment information.
    # Else return the form with errors.
    if ( $form ) {
    # The form was processed

        # Redirect to payment information
        $c->res->redirect( $c->uri_for($self->action_for('confirmation')) );

    } else {
    # Username or password were not defined

        # TODO: display error message via ->flash->{error_msg} ?
        # Mean while we will display a message in debug
        $c->log->debug("not submited");

        return;

    }

}

sub confirmation : Local {
    my ( $self, $c ) = @_;
    my $customer;
    my $cart;

    if (!$c->user_exists) {
        $c->response->redirect($c->uri_for('/customers/login'));
        return 0;
    }

    # Get the customer cart by his id
    $cart = $c->model('Cart')->get_cart({ customer_id => $c->user->id, });

    # Set our template and form to use
    $c->stash(
        customer    => $c->model('Customer')->get_customer($c->user->id),
        cart        => $cart,
        cart_items  => $c->model('Cart')->get_items_in_cart,
        amount      => $c->model('Cart')->sum_items_in_cart,
        template    => 'checkout/confirmation.tt2',
    );

}

sub process_order : Local {
    my ( $self, $c ) = @_;
    my $order;

    $order = $c->model('Checkout')->process_order;

    $c->model('Cart')->destroy_cart;

        $c->response->redirect(
                $c->uri_for( $self->action_for('send_email') )
            . '/' );


}

sub send_email : Local {
    my ( $self, $c ) = @_;

    # Load items from cart
    $c->stash->{cart_items} = $c->model('Cart')->get_items_in_cart;
    $c->stash->{customer}
        = $c->model('Customer')->get_customer($c->user->username);
    $c->stash->{cart}
        = $c->model('Cart')->get_cart;

    # Send email
    $c->stash->{email} = {
            to      => $c->stash->{customer}->{email},
            bcc      => 'info@saborespanol.com',
            from    => 'sales@saborespanol.com',
            subject => 'Order',
            template => 'order_formation.tt2',
            content_type => 'multipart/alternative'
        };
        
        $c->forward( $c->view('Email::Template') );

        $c->response->redirect( $c->uri_for( '/' ) );


}


=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
