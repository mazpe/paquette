package Paquette::Controller::Pages;

use Moose;
BEGIN { extends 'Catalyst::Controller' }
use Paquette::Form::Pages::Contact;
use Paquette::Form::Pages::MailingList;
use Data::Dumper;

has 'contact_form' => (
    isa => 'Paquette::Form::Pages::Contact',
    is => 'ro',
    lazy => 1,
    default => sub { Paquette::Form::Pages::Contact->new },
);
has 'mailing_list_form' => (
    isa => 'Paquette::Form::Pages::MailingList',
    is => 'ro',
    lazy => 1,
    default => sub { Paquette::Form::Pages::MailingList->new },
);


=head1 NAME

Paquette::Controller::Pages - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub auto : Local {
    my ( $self, $c ) = @_;

    $c->stash->{random_image} = $c->subreq(
        '/webtools/random_images', { template => 'webtools/random_image.tt2' }
    );

}

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Paquette::Controller::Pages in Pages.');
}

sub about_us : Path('/about_us') {
    my ( $self, $c ) = @_;


    $c->stash->{template} = 'pages/about_us.tt2';
}

sub contact_us : Path('/contact_us') {
    my ( $self, $c ) = @_;
    my $row;
    my $form;

    # Get a new empty row
    $row = $c->model('PaquetteDB::Lead')->new_result({});
    
    # Set our template and form to use
    $c->stash(
        template    => 'pages/contact.tt2',
        form        => $self->contact_form,
    );

    # Process our form
    $form =  $self->contact_form->process (
        item            => $row,
        params          => $c->req->params,
    );
    
    # If the form has been submited sucessfully, then redirect to confirm page
    if ($form) {
        $c->res->redirect( $c->uri_for($self->action_for('contact_confirm')) );
    }
}

sub contact_confirm : Path('/contact_us_confirm') {
    my ( $self, $c ) = @_;

    # Set our template
    $c->stash->{template} = 'pages/contact_thank_you.tt2';

}

sub privacy_policy : Path('/privacy_policy') {
    my ( $self, $c ) = @_;


    $c->stash->{template} = 'pages/privacy_policy.tt2';
}

sub site_map : Path('/site_map') {
    my ( $self, $c ) = @_;


    $c->stash->{template} = 'pages/site_map.tt2';
}

sub mailing_list : Path('/mailing_list') {
    my ( $self, $c ) = @_;
    my $row;
    my $form;

    # Get a new row 
    $row = $c->model('PaquetteDB::Lead')->new_result({});

    # Set our template and form to use
    $c->stash(
        template    => 'pages/mailing_list.tt2',
        form        => $self->mailing_list_form,
    );

    # Process our form
    $form =  $self->mailing_list_form->process (
        item            => $row,
        params          => $c->req->params,
    );

    # if the form has been submited succesfully, the redirect to confirm page
    if ($form) {
        $c->res->redirect( 
            $c->uri_for($self->action_for('mailing_list_confirm')) 
        );
    }

}

sub mailing_list_confirm : Path('/mailing_list_confirm') {
    my ( $self, $c ) = @_;

    # Set our template
    $c->stash->{template} = 'pages/mailing_list_confirm.tt2';

}


sub aux_order_catalog : Path('/aux/order_catalog') {
    my ( $self, $c ) = @_;


    $c->stash->{template} = 'pages/aux_order_catalog.tt2';
}

sub aux_cooking_lessons : Path('/aux/cooking_lessons') {
    my ( $self, $c ) = @_;


    $c->stash->{template} = 'pages/aux_cooking_lessons.tt2';
}

sub promo_opening : Path('/promotions/opening_special') {
    my ( $self, $c ) = @_;


    $c->stash->{template} = 'pages/promo_opening_special.tt2';
}

sub promo_wines : Path('/promotions/wines') {
    my ( $self, $c ) = @_;


    $c->stash->{template} = 'pages/promo_wines.tt2';
}

sub promo_share_recipe : Path('/promotions/share_recipe') {
    my ( $self, $c ) = @_;


    $c->stash->{template} = 'pages/promo_share_recipe.tt2';
}



=head1 AUTHOR

Lester Ariel Mesa,,lesterm@gmail.com,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
