package Paquette::Controller::Checkout;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Paquette::Controller::Checkout - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 auto

Check if there is a user and, if not, forward to login page

=cut

sub auto : Private {
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

    $c->response->body('Matched Paquette::Controller::Checkout in Checkout.');
}

sub register_do : Local {
    my ( $self, $c ) = @_;

    my $bill_first_name     = $c->req->param('bill_first_name');
    my $bill_last_name      = $c->req->param('bill_last_name');
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

    my $email               = $c->req->param('email');

    my $customer = $c->model('PaquetteDB::Customer')->create({
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
    });

    my $user = $c->model('PaquetteDB::User')->create({
        user                => '$email',
        
    });
    
}

sub view_cart : Local {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'checkout/cart.tt2';
}

=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
