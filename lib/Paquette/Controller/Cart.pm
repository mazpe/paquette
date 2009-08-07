package Paquette::Controller::Cart;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Data::Dumper;

=head1 NAME

Paquette::Controller::Cart - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Paquette::Controller::Cart in Cart.');
}

sub base :Chained('/') :PathPart('cart') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

}

sub load : Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $sku ) = @_;
    my $item;

    if($sku) {

        $c->stash->{sku} = $sku;

    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}

sub add_item : Local {
    my ( $self, $c ) = @_;
    
    if ( $c->req->param('submit.x') && $c->req->param('submit.y') ) {
    # Form submited
    
        # Add items to the shopping cart
        my $add_to_cart = $c->model('Cart')->add_items_to_cart( {
            sku => $c->req->params->{sku},
            qty => $c->req->params->{qty},
        } );

        if ( $add_to_cart ) {
        # Item added to cart

            $c->response->redirect(
                $c->uri_for( $self->action_for('view') ) . '/' );

        } else {
        # Item not added to cart

        }

    } else {
    # Form not submited

        $c->response->status(404);
        $c->detach;
        
    }
}

sub remove_item : Chained('load') : PathPart('remove_item') : Args(0) {
    my ( $self, $c) = @_;
    my $sku;

    if ($c->stash->{sku}) {
    # Found sku in stash

        # Remove items from the shopping cart
        my $remove_from_cart = $c->model('Cart')->remove_items_from_cart(
            { sku => $c->stash->{sku} },
        );

        if ( $remove_from_cart ) {
        # Item removed from shoping cart

            $c->response->redirect(
                $c->uri_for( $self->action_for('view') ) . '/' );

        } else {
        # Item not removed from shopping cart
        
        }

    } else {
    # Sku not found in stash
    
        $c->response->status(404);
        $c->detach;    

    }

}

sub view : Local {
    my ( $self, $c ) = @_;

    my $items_in_cart = $c->model('Cart')->get_items_in_cart;

    if ($items_in_cart) {
    # Found items in cart
    
        $c->stash->{cart_items}         = $items_in_cart;
        $c->stash->{template}           = 'cart/view.tt2';

    } else {
    # Items not found in car

    }
}

sub clear : Local {
    my ( $self, $c ) = @_;

    my $clear_cart = $c->model('Cart')->clear_cart();

    if ( $clear_cart ) {
    # Cart has been cleared

        $c->response->redirect(
            $c->uri_for( $self->action_for('view') ) . '/' );

    } else {
    # Sku not found in stash

        $c->response->status(404);
        $c->detach;

    }

}

sub update : Local {
    my ( $self, $c ) = @_;

    my $update_cart = $c->model('Cart')->update_items_in_cart( {
        items => $c->req->params
    } );

    if ( $update_cart ) { 
    # Items updated

        $c->response->redirect(
            $c->uri_for( $self->action_for('view') ) . '/' );
    
    } else {
    # Items did not update

        $c->response->status(404);
        $c->detach;

    }
        
}

=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
