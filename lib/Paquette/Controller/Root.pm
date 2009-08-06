package Paquette::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

Paquette::Controller::Root - Root Controller for Paquette

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

sub auto : Local {
    my ( $self, $c ) = @_;

    # How many items are in store in the session.
    my $hash_ref = $c->session->{items};
    my $cart_size = 0;
    $cart_size += keys %$hash_ref;

    # Get all my parent categories
    my $categories = [$c->model('PaquetteDB::Categories')->search(
        { parent_id => 0 },
    )];


    $c->stash->{cart_size}  = $cart_size;
    $c->stash->{categories} = $categories;
}

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $categories = [$c->model('PaquetteDB::Categories')->search(
        { parent_id => 0 },
    )];

    $c->stash->{'categories'}    = $categories;

#    $c->response->redirect($c->uri_for($c->controller('Customers')->action_for(
#        'pre_registration'
#    )));
    
    my $url = "/css";

    $c->log->debug($c->uri_for('/static/css/style.css'));
    
    $c->stash->{template} = "index.tt2";
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
