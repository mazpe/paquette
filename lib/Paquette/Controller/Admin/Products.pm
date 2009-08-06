package Paquette::Controller::Admin::Products;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Data::Dumper;

=head1 NAME

Paquette::Controller::Admin::Products - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Chained('base') :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $page = $c->req->param('page') || 1;
    my $products = [$c->model('PaquetteDB::Product')->search(
        undef,
        {
            page => $page,
            rows => 100
        }
    )];

    $c->stash->{'products'}    = $products;
    $c->stash->{wrapper_admin}  = "1";
    $c->stash->{template} = 'admin/products/list.tt2';

    return;
}

sub base :Chained('/') :PathPart('admin/products') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash->{wrapper_admin}  = "1";
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

sub create: Local {
    my ( $self, $c ) = @_;
    my $cmd;
    my $upload;
    my $photo = 0;
    my $item_photos_path
        = '/mnt/www/www.saborespanol.com/Paquette/root/static/item_photos';
    my $item_photos_fullpath
        = $item_photos_path . '/' . $c->req->param('url_name') . '.jpg';

    if ($c->req->param('submit')) {

       # upload photo
        $upload = $c->request->upload('item_photo');
        if ($upload) {
            # copy the photo to our photo gallery
            $cmd = '/bin/mv '.$upload->tempname.' '.$item_photos_fullpath;
            system($cmd);

            $photo = 1;
        }

        # keep photo value if it already has a photo
        if ($c->req->param('has_photo')) { $photo = 1 }

        my $product = $c->model('PaquetteDB::Product')->create(
            {
                category_id         => $c->req->param('category_id'),
                sku                 => $c->req->param('sku'),
                name                => $c->req->param('name'),
                url_name            => $c->req->param('url_name'),
                brief_description   => $c->req->param('brief_description'),
                description         => $c->req->param('description'),
                price               => $c->req->param('price'),
                photo               => $photo,
            }
        );

        $c->response->redirect(
            $c->uri_for( $self->action_for('edit'), [ $product->id ] )
              . '/' );

    } else {

        $c->stash->{categories} = [$c->model('PaquetteDB::Categories')->all];
        $c->stash->{wrapper_admin}  = "1";
        $c->stash->{template} = 'admin/products/create.tt2';

    }

    return;
}

sub edit : Chained('load') : PathPart('edit') : Args(0) {
    my ( $self, $c ) = @_;
    my $photo;
    my $id;
    my $product;
    my $cmd;
    my $upload;
    my $item_photos_path 
        = '/mnt/www/www.saborespanol.com/Paquette/root/static/item_photos';
    my $item_photos_fullpath
        = $item_photos_path . '/' . $c->req->param('url_name') . '.jpg';

    if ($c->req->param('submit')) {
        
        $id = $c->stash->{'product_id'};
        $product = $c->stash->{product};

        # upload photo
        $upload = $c->request->upload('item_photo');
        if ($upload) {
            # copy the photo to our photo gallery
            $cmd = '/bin/mv '.$upload->tempname.' '.$item_photos_fullpath;
            system($cmd);
            
            $photo = 1;
        }
        
        # keep photo value if it already has a photo
        if ($c->req->param('has_photo')) { $photo = 1 }

        # update database with new values
        $product->update(
            {
                category_id         => $c->req->param('category_id'),
                sku                 => $c->req->param('sku'),
                name                => $c->req->param('name'),
                url_name            => $c->req->param('url_name'),
                brief_description   => $c->req->param('brief_description'),
                description         => $c->req->param('description'),
                price               => $c->req->param('price'),
                photo               => $photo,
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

sub delete : Chained('load') : PathPart('delete') : Args(0) {
    my ( $self, $c ) = @_;

    my $product = $c->stash->{product};

    if ($product) {

        $product->delete;

        $c->response->redirect(
            $c->uri_for( $self->action_for('index')) . '/' );

    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}

=head1 AUTHOR

Lester Ariel Mesa

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

1;
