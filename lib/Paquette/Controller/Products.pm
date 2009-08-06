package Paquette::Controller::Products;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Paquette::Controller::Products - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

#sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;

#    $c->response->body('Matched Paquette::Controller::Products in Products.');
#}


=cut

sub index :Chained('base') :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $page = $c->req->param('page') || 1;
    my $products = [$c->model('PaquetteDB::Product')->search(
        undef,
        {
            page => $page,
            rows => 10
        }
    )];

    $c->stash->{'products'}    = $products;
    $c->stash->{template} = 'admin/products/list.tt2';

    return;
}

sub base :Chained('/') :PathPart('products') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

}

sub load : Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $product;
    my $attributes;

    if($id) {

        $c->stash->{product_id} = $id;
        $product    = $c->model('PaquetteDB::Product')->find($id);
        $attributes = [$c->model('PaquetteDB::ProductAttribute')->search({
            product_id => $id
        })];

    } else {

        $c->response->status(404);
        $c->detach;

    }

    if ($product) {

        $c->stash->{'product'} = $product;

    } else {

        $c->response->status(404);
        $c->detach;

    }

    $c->stash->{'attributes'} = $attributes if ($attributes);

    return;
}

sub list : Chained('load') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;

    if ($c->req->param('submit')) {

        my $id = $c->stash->{'product_id'};
        my $product = $c->stash->{product};

        $product->update(
            {
                category_id         => $c->req->param('category_id'),
                sku                 => $c->req->param('sku'),
                name                => $c->req->param('name'),
                brief_description   => $c->req->param('brief_description'),
                description         => $c->req->param('description'),
                price               => $c->req->param('price'),
            }
        );

       $c->response->redirect(
            $c->uri_for( $self->action_for('edit'), [ $product->id ] )
              . '/' );

    } else {

        $c->stash->{categories} = [$c->model('PaquetteDB::Categories')->all];
        $c->stash->{template} = 'admin/products/edit.tt2';

    }

    return;
}


=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
