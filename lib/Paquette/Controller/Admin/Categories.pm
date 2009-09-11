package Paquette::Controller::Admin::Categories;

use Moose;
BEGIN { extends 'Catalyst::Controller' }
use Paquette::Form::Admin::Category;
use Data::Dumper;

has 'category_form' => (
    isa => 'Paquette::Form::Admin::Category',
    is => 'ro',
    lazy => 1,
    default => sub { Paquette::Form::Admin::Category->new },
);


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
    $c->stash->{template} = 'admin/categories_list.tt2';

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

sub create : Local {
    my ( $self, $c ) = @_;
    my $row;
    my $form;

    # Get a new empty row
    $row = $c->model('PaquetteDB::Categories')->new_result({});

    # Set our template and form to use
    $c->stash(
        wrapper_admin   => 1,
        template        => 'admin/category.tt2',
        form            => $self->category_form,
    );

    # Process our form
    $form =  $self->category_form->process (
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
    my $category_id;
    my $row;
    my $form;
    my $cmd;
    my $categories_photos_path
      = '/mnt/www/www.saborespanol.com/Paquette/root/static/categories_photos';
    my $categories_photos_fullpath
        = $categories_photos_path . '/' . $c->req->param('url_name') . '.jpg';
    my $old_categories_photos_fullpath;

    $category_id = $c->stash->{category_id};

    # Get a new empty row
    $row = $c->model('PaquetteDB::Categories')->find_category($category_id);

    # if the form has been submited and the url name of the item has changed
    # then we are going to rename item photo to match the new url name
    if ( $c->req->params->{submit} &&                                                       ($row->url_name ne $c->req->params->{url_name}) ) {

        $old_categories_photos_fullpath
            = $categories_photos_path . '/' . $row->url_name . '.jpg';

        $cmd = "/bin/mv $old_categories_photos_fullpath ";
        $cmd .= $categories_photos_fullpath;
        system($cmd);
        $c->log->debug("cmd: ". $cmd);

    }

    # Set our template and form to use
    $c->stash(
        template    => 'admin/category.tt2',
        form        => $self->category_form,
    );

    # Process our form
    $form =  $self->category_form->process (
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
    my $photo = 0;
    my $id;
    my $category;
    my $cmd;
    my $upload;

    my $categories_photos_path
      = '/mnt/www/www.saborespanol.com/Paquette/root/static/categories_photos';

    my $categories_photos_fullpath
        = $categories_photos_path . '/' . $c->req->param('url_name') . '.jpg';

    if ($c->req->param('submit')) {

        $id = $c->stash->{'category_id'};
        $category = $c->stash->{category};

        # upload photo
        $upload = $c->request->upload('category_photo');

        if ($upload) {
            # copy the photo to our photo gallery
            $cmd = '/bin/mv '.$upload->tempname.' '.$categories_photos_fullpath;

            $c->log->debug("cmd: ". $cmd);

            system($cmd);

            $photo = 1;

        }

        # keep photo value if it already has a photo
        if ($c->req->param('has_photo')) { $photo = 1 }


        # update category
        $category->update( { photo => $photo, } );

        $c->response->redirect(
            $c->uri_for( $self->action_for('edit'), [ $category->id ] )
              . '/' );

    } else {

        $c->stash->{template} = 'admin/categories_list.tt2';

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
