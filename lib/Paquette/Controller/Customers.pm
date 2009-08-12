package Paquette::Controller::Customers;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Data::Dumper;

=head1 NAME

Paquette::Controller::Customers - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Paquette::Controller::Customers in Customers.');
}

sub login : Local {
    my ($self, $c) = @_;

    # Get the username and password from form
    my $username = $c->request->params->{username} || "";
    my $password = $c->request->params->{password} || "";

    # If the username and password values were found in form
    if ($username && $password) {
        # Attempt to log the user in
        if ($c->authenticate({ username => $username,
                               password => $password  } )) {

            # Assign cart_id/session_id to user
            $c->model('Cart')->assign_cart;

            # If successful, then let them use the application
            $c->response->redirect($c->uri_for(
                $c->controller('Customers')->action_for('index')));
            return;
        } else {
            # Set an error message
            $c->stash->{error_msg} = "Bad username or password.";
        }

    }

    # If either of above don't work out, send to the login page
    $c->stash->{template} = 'customers/login.tt2';
}

sub logout : Local {
    my ( $self, $c ) = @_;

    # Clear the user's state
    $c->logout;

    # Send the user to the starting point
    $c->response->redirect($c->uri_for('/'));

}

sub register : Local {
    my ( $self, $c ) = @_;

    # Get items in the shopping cart and set them in stash
    $c->stash->{cart_items} = $c->model('Cart')->get_items_in_cart;

    # Get countries and states from database and set them in stash 
    $c->stash->{countries}  = [$c->model('PaquetteDB::Countries')->all];
    $c->stash->{states}     = [$c->model('PaquetteDB::States')->all];

    # Set template to be used
    $c->stash->{template}   = 'customers/register.tt2';
}

sub register_do : Local {
    my ( $self, $c ) = @_;

    if ( $c->req->params->{submit} ) {
    # Form submited

        # Get our fields from form
        my $bill_first_name     = $c->req->params->{'bill_first_name'};
        my $bill_last_name      = $c->req->params->{'bill_last_name'};
        my $bill_company        = $c->req->param('bill_company');
        my $bill_address1       = $c->req->param('bill_address1');
        my $bill_address2       = $c->req->param('bill_address2');
        my $bill_city           = $c->req->param('bill_city');
        my $bill_state          = $c->req->param('bill_state');
        my $bill_country        = $c->req->param('bill_country');
        my $bill_zip_code       = $c->req->param('bill_zip_code');
        my $bill_phone          = $c->req->param('bill_phone');
        my $ship_first_name     = $c->req->param('ship_first_name');
        my $ship_last_name      = $c->req->param('ship_last_name');
        my $ship_company        = $c->req->param('ship_company');
        my $ship_address1       = $c->req->param('ship_address1');
        my $ship_address2       = $c->req->param('ship_address2');
        my $ship_city           = $c->req->param('ship_city');
        my $ship_state          = $c->req->param('ship_state');
        my $ship_country        = $c->req->param('ship_country');
        my $ship_zip_code       = $c->req->param('ship_zip_code');
        my $ship_phone          = $c->req->param('ship_phone');
        my $email               = $c->req->params->{'email'};
        my $password            = $c->req->params->{'password'};
        
        my $customer = $c->model('Customer')->create_customer({
            bill_first_name     => $bill_first_name,
            bill_last_name      => $bill_last_name,
            bill_company        => $bill_company,
            bill_address1       => $bill_address1,
            bill_address2       => $bill_address2,
            bill_city           => $bill_city,
            bill_state          => $bill_state,
            bill_country        => $bill_country,
            bill_zip_code       => $bill_zip_code,
            bill_phone          => $bill_phone,
            ship_first_name     => $ship_first_name,
            ship_last_name      => $ship_last_name,
            ship_company        => $ship_company,
            ship_address1       => $ship_address1,
            ship_address2       => $ship_address2,
            ship_city           => $ship_city,
            ship_state          => $ship_state,
            ship_country        => $ship_country,
            ship_zip_code       => $ship_zip_code,
            ship_phone          => $ship_phone,
            email               => $email,
            password            => $password,
        });

        if ( $customer ) {
        # Customer created

            # Authenticate customer
            if ( $c->authenticate( {
                username => $email,
                password => $password
            } ) ) {
            # Authenticated

                # Checkout mode 
                    $c->response->redirect(
                        $c->uri_for( 
                            $c.controller('Checkout')->action_for('shipping'), )
                    . '/' );


            } else {

                print "no go\n";
            }

        } else {
        # Customer not created
            #print "Customer not created - ". $customer . "\n";        

        } 

    } else {
    # Form not submited

    }
}

=head2 pre_registration

Display pre_registration form

=cut

sub pre_registration :Local {
    my ( $self, $c ) = @_;

    $c->stash->{template} = "customers/pre_registration.tt2";

}

sub pre_registration_do :Local {
    my ( $self, $c ) = @_;

    # Retrieve values from form
    my $first_name          = $c->req->params->{first_name};
    my $last_name           = $c->req->params->{last_name};
    my $city                = $c->req->params->{city};
    my $state               = $c->req->params->{state};
    my $email               = $c->req->params->{email};

if ($first_name && $email) {
    # Create a record for the pre-registration
    my $pre_req = $c->model('PaquetteDB::PreRegistration')->create({
        first_name          => $first_name,
        last_name           => $last_name,
        city                => $city,
        state               => $state,
        email               => $email,
    });

    # Notify client that they have been added
    if ($pre_req) {
        $c->flash->{status_msg} = "You have been added to our database";
    }

} else {

        $c->flash->{error_msg} = "First name and Email are required";

}

    # Redirect visitors to the pre_registration page
    $c->response->redirect($c->uri_for($self->action_for('pre_registration')));    

}

#sub send_email : Local {
#    my ( $self, $c ) = @_;
#
#    $c->stash->{email} = {
#        to          => 'lesterm@gmail.com',
#        from        => 'info@saborespanol.com',
#        subject     => 'Pre Registration',
#        template    => 'pre_registration.tt2',
#        content_type => 'multipart/alternative',
#    };
#
#    $c->forward( $c->view('Email::Template') );
    
#    if ( scalar( @{ $c->error } ) ) {
#        $c->error(0); # Reset the error condition if you need to
#        $c->response->body('Error: email not sent');
#    } else {
#        $c->response->body('Email sent');
#    }

#}

=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
