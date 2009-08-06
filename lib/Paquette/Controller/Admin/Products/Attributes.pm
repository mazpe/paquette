package Paquette::Controller::Admin::Products::Attributes;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Paquette::Controller::Admin::Products::Attributes - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base :Chained('/') :PathPart('admin') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

}

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $page = $c->req->param('page') || 1;
    my $attributes = [$c->model('PaquetteDB::ProductAttribute')->search(
        undef,
        {
            page => $page,
            rows => 10
        }
    )];

    $c->stash->{'attributes'}    = $attributes;

    $c->stash->{template} = 'admin/attributes/list.tt2';

    return;
}

sub base :Chained('/admin/products/load') :PathPart('attributes') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

}

sub load : Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $attribute;
    
    if($id) {

        $c->stash->{attribute_id} = $id;
        $attribute = $c->model('PaquetteDB::ProductAttribute')->find($id);

    } else {

        $c->response->status(404);
        $c->detach;

    }

    if ($attribute) {

        $c->stash->{'attribute'} = $attribute;

    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}

sub create: Local {
    my ( $self, $c ) = @_;
    
    if ($c->req->param('submit')) {

        my $attribute = $c->model('PaquetteDB::ProductAttribute')->create(
            {
                name        => $c->req->param('name'),
                value       => $c->req->param('value') 
            }
        );

        $c->response->redirect(
            $c->uri_for( $self->action_for('edit'), [ $attribute->id ] )
              . '/' );

    } else {

        $c->stash->{template} = 'admin/attributes/create.tt2';

    }

    return;
}

sub edit : Chained('load') : PathPart('edit') : Args(0) {
    my ( $self, $c ) = @_;

    if ($c->req->param('submit')) {
        
        my $id = $c->stash->{'attribute_id'};
        my $attribute = $c->stash->{attribute};

        $attribute->update(
            {
                name        => $c->req->param('name'),
                description => $c->req->param('description'),
                price       => $c->req->param('price'),
            }
        );        
    
       $c->response->redirect(
            $c->uri_for( $self->action_for('edit'), [ $attribute->id ] )
              . '/' );
        
    } else {
    
        $c->stash->{template} = 'admin/attributes/edit.tt2';
    
    }   

    return;
}

sub delete : Chained('load') : PathPart('delete') : Args(0) {
    my ( $self, $c ) = @_;

    my $attribute = $c->stash->{attribute};

    if ($attribute) {

        $attribute->delete;

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
