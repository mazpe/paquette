package Paquette::Controller::Customers;

use Moose;
BEGIN { extends 'Catalyst::Controller' }
use Paquette::Form::Customer;
use Data::Dumper;

has 'form' => ( 
    isa => 'Paquette::Form::Customer', 
    is => 'ro',
    lazy => 1, 
    default => sub { Paquette::Form::Customer->new },
);

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

    # Set our template
    $c->stash->{template} = 'customers/index.tt2';
}

sub login : Local {
    my ($self, $c) = @_;

    # Get the username and password from form
    my $username = $c->request->params->{username} || "";
    my $password = $c->request->params->{password} || "";

    # If the username and password values were found in form
    if ($username && $password) {

        # Attempt to log the user in
        # Using searchargs to authenticate because of non-standard table layout
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
    
        if ($auth) {

            # Assign cart_id/session_id to user
            $c->model('Cart')->assign_cart;

            # If successful, then let them use the application
            $c->response->redirect($c->uri_for(
                $c->controller('Customers')->action_for('index')));

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

sub account : Local {
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
        template    => 'customers/account.tt2',
        form        => $self->form,
    );
    
    # Process our form
    $form =  $self->form->process (
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
        if ($auth) {
            # Assign cart_id/session_id to user
            $c->model('Cart')->assign_cart;

            $c->res->redirect( $c->uri_for($self->action_for('index')) );
        }

    } else { 
    # Username or password were not defined 

        # TODO: display error message via ->flash->{error_msg} ?
        # Mean while we will display a message in debug
        $c->log->debug("not submited");

        return;

    }

}

sub register_do : Local {
    my ( $self, $c ) = @_;
    my $customer;

    if ( $c->req->params->{submit} ) {
    # Form submited

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

        if ( $customer ) {
        # Customer was created and cart was imported

            $c->response->redirect(
                    $c->uri_for( $self->action_for('index') )
                . '/' );

        } else {
        # Customer or Cart were not created

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

sub orders : Local {
    my ( $self, $c ) = @_;

    # Set our template
    $c->stash->{template} = 'customers/orders.tt2';
}

sub items : Local {
    my ( $self, $c ) = @_;
    
    # Set our template
    $c->stash->{template} = 'customers/items.tt2';
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
