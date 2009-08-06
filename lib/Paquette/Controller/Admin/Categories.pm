package Paquette::Controller::Admin::Categories;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Paquette::Controller::Admin::Categories - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Chained('based') :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $categories = [$c->model('PaquetteDB::Categories')->search(
        undef,
        { order_by => [qw/parent_id name/] }
    )];

    $c->stash->{categories} = $categories;

    $c->stash->{wrapper_admin}  = "1";
    $c->stash->{template} = 'admin/categories/list.tt2';

    return;
}

sub base :Chained('/') :PathPart('admin/categories') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash->{wrapper_admin}  = "1";
}

sub load : Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $category;

    if($id) {

        $c->stash->{category_id} = $id;
        $category    = $c->model('PaquetteDB::Categories')->find($id);

    } else {

        $c->response->status(404);
        $c->detach;

    }

    if ($category) {

        $c->stash->{'category'} = $category;

    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}

sub create: Local {
    my ( $self, $c ) = @_;
    my $photo = 0;
    my $id;
    my $category;
    my $cmd;
    my $upload;
    my $url_name = $c->req->param('url_name');
    my $categories_photos_path
      = '/mnt/www/www.saborespanol.com/Paquette/root/static/categories_photos';
    my $categories_photos_fullpath
        = $categories_photos_path . '/' . $url_name . '.jpg';

    $c->log->debug("name ". $c->req->param('name'));
    $c->log->debug("url_name ". $url_name);
    $c->log->debug("fullpath ".$categories_photos_fullpath);

    if ($c->req->param('submit')) {

        # upload photo
        $upload = $c->request->upload('category_photo');
        if ($upload) {
            # copy the photo to our photo gallery
            $cmd = '/bin/mv '.$upload->tempname.' '.$categories_photos_fullpath;
            $c->log->debug("cmd ". $cmd);
            system($cmd);

            $photo = 1;
        }

        # keep photo value if it already has a photo
        if ($c->req->param('has_photo')) { $photo = 1 }

        $category = $c->model('PaquetteDB::Categories')->create(
            {
                parent_id           => $c->req->param('parent_id'),
                name                => $c->req->param('name'),
                url_name            => $c->req->param('url_name'),
                brief_description   => $c->req->param('brief_description'),
                description         => $c->req->param('description'),
                photo               => $photo,
            }
        );

        $c->response->redirect(
            $c->uri_for( $self->action_for('edit'), [ $category->id ] )
              . '/' );

    } else {

        $c->stash->{categories} = [$c->model('PaquetteDB::Categories')->all];
        $c->stash->{wrapper_admin}  = "1";
        $c->stash->{template} = 'admin/categories/create.tt2';

    }

    return;
}

sub edit : Chained('load') : PathPart('edit') : Args(0) {
    my ( $self, $c ) = @_;
    my $photo = 0;
    my $id;
    my $category;
    my $cmd;
    my $upload;
    my $categories_photos_path
      = '/mnt/www/www.saborespanol.com/Paquette/root/static/categories_photos';
    my $categories_photos_fullpath
        = $categories_photos_path . '/' . $c->req->param('url_name') . '.jpg';

    $c->log->debug("fullpath ".$categories_photos_fullpath);
    $c->log->debug("url_name ". $c->req->param('url_name'));

    if ($c->req->param('submit')) {

        $id = $c->stash->{'category_id'};
        $category = $c->stash->{category};

        # upload photo
        $upload = $c->request->upload('category_photo');
        if ($upload) {
            # copy the photo to our photo gallery
            $cmd = '/bin/mv '.$upload->tempname.' '.$categories_photos_fullpath;
            $c->log->debug("cmd ". $cmd);
            system($cmd);

            $photo = 1;
        }

        # keep photo value if it already has a photo
        if ($c->req->param('has_photo')) { $photo = 1 }

        # update category
        $category->update(
            {
                parent_id           => $c->req->param('parent_id'),
                name                => $c->req->param('name'),
                url_name            => $c->req->param('url_name'),
                brief_description   => $c->req->param('brief_description'),
                description         => $c->controller('Utils')->trailing_spaces(
                    $c, $c->req->param('description')
                ),
                photo               => $photo,
            }
        );

        $c->response->redirect(
            $c->uri_for( $self->action_for('edit'), [ $category->id ] )
              . '/' );

    } else {

        $c->stash->{categories} = [$c->model('PaquetteDB::Categories')->all];
        $c->stash->{template} = 'admin/categories/edit.tt2';

    }

    return;
}

sub delete : Chained('load') : PathPart('delete') : Args(0) {
    my ( $self, $c ) = @_;
    my $cmd;
    my $category = $c->stash->{category};
    my $categories_photos_path
      = '/mnt/www/www.saborespanol.com/Paquette/root/static/categories_photos';
    my $categories_photos_fullpath
        = $categories_photos_path . '/' . $c->stash->{category}->url_name . '.jpg';



    if ($category) {

        my $is_deleted = $category->delete;
        
        $cmd = '/bin/rm -Rf '. $categories_photos_fullpath;
        system ($cmd) if ($is_deleted);

        $c->log->debug($cmd);

        $c->response->redirect(
            $c->uri_for( $self->action_for('index')) . '/' );

    } else {

        $c->response->status(404);
        $c->detach;

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
