package Paquette::Controller::Admin::Products;

use Moose;
BEGIN { extends 'Catalyst::Controller' }
use Paquette::Form::Admin::Product;
use Data::Dumper;

has 'product_form' => (
    isa => 'Paquette::Form::Admin::Product',
    is => 'ro',
    lazy => 1,
    default => sub { Paquette::Form::Admin::Product->new },
);

=head1 NAME

Paquette::Controller::Admin::Products - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub auto : Private {
    my ( $self, $c ) = @_;

    $c->stash->{wrapper_admin}  = "1";
}

sub index :Chained('base') :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $page = $c->req->param('page') || 1;
    my $products = [$c->model('PaquetteDB::Product')->search(
        undef,
        {
            prefetch    => 'category',
            order_by    => { -asc =>  'category.name' },
        }
    )];

    $c->stash->{'products'}    = $products;
    $c->stash->{wrapper_admin}  = "1";
    $c->stash->{template} = 'admin/products_list.tt2';

    return;
}

sub base :Chained('/') :PathPart('admin/products') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash->{wrapper_admin}  = "1";
}

sub load : Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $product;
    
    if($id) {

        $c->stash->{product_id} = $id;
        $product    = $c->model('PaquetteDB::Product')->find($id);

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

    return;
}

sub create : Local {
    my ( $self, $c ) = @_;
    my $row;
    my $form;

    # Get a new empty row
    $row = $c->model('PaquetteDB::Product')->new_result({});

    # Set our template and form to use
    $c->stash(
        template    => 'admin/product.tt2',
        form        => $self->product_form,
    );

    # Process our form
    $form =  $self->product_form->process (
        item            => $row,
        params          => $c->req->params,
    );

    # If the form has been submited sucessfully, then redirect to confirm page
    if ($form) {
        $c->res->redirect( $c->uri_for($self->action_for('index')) );
    }

}

sub edit : Chained('load') : PathPart('edit') : Args(0) {
    my ( $self, $c ) = @_;
    my $product_id;
    my $row;
    my $form;
    my $cmd;
    my $item_photos_path
        = '/mnt/www/www.saborespanol.com/Paquette/root/static/item_photos';
    my $item_photos_fullpath
        = $item_photos_path . '/' . $c->req->param('url_name') . '.jpg';
    my $old_item_photos_fullpath;

    $product_id = $c->stash->{product_id};

    # Get a new empty row
    $row = $c->model('PaquetteDB::Product')->find_product($product_id);

    # if the form has been submited and the url name of the item has changed
    # then we are going to rename item photo to match the new url name
    if ( $c->req->params->{submit} && 
            ($row->url_name ne $c->req->params->{url_name}) ) {

        $old_item_photos_fullpath
            = $item_photos_path . '/' . $row->url_name . '.jpg';

        $cmd = "/bin/mv $old_item_photos_fullpath $item_photos_fullpath"; 
        system($cmd);
        $c->log->debug("cmd: ". $cmd);

    }
    
    # Set our template and form to use
    $c->stash(
        template    => 'admin/product.tt2',
        form        => $self->product_form,
    );

    # Process our form
    $form =  $self->product_form->process (
        item            => $row,
        params          => $c->req->params,
    );

    # If the form has been submited sucessfully, then redirect to confirm page
    if ($form) {
        $c->res->redirect( $c->uri_for($self->action_for('index')) );
    }
}


sub photo_upload : Chained('load') : PathPart('photo_upload') : Args(0) {
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
            $c->log->debug("cmd: ". $cmd);
            
            $photo = 1;
        }
        
        # keep photo value if it already has a photo
        if ($c->req->param('has_photo')) { $photo = 1 }

        # update database with new values
        $product->update(
            {
                photo               => $photo,
            }
        );        

        $c->res->redirect( $c->uri_for($self->action_for('index')) );
        
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
