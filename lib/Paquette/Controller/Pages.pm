package Paquette::Controller::Pages;

use strict;
use warnings;
use parent 'Catalyst::Controller';

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
    my $full_name;

    if (  $c->req->params->{submit} ) {

        $full_name 
            = $c->req->params->{first_name} .', '. $c->req->params->{last_name};

       # Send email
        $c->stash->{email} = {
            to      => 'info@saborespanol.com',
            from    => $c->req->params->{email},
            subject => 'Contact Us: '. $full_name,
            template => 'contact_us.tt2',
            content_type => 'multipart/alternative'
        };

        $c->forward( $c->view('Email::Template') );

        $c->stash->{template} = 'pages/contact_us_confirm.tt2';

    } else {

    $c->stash->{template} = 'pages/contact_us.tt2';
    
    }
}

sub privacy_policy : Path('/privacy_policy') {
    my ( $self, $c ) = @_;


    $c->stash->{template} = 'pages/privacy_policy.tt2';
}

sub site_map : Path('/site_map') {
    my ( $self, $c ) = @_;


    $c->stash->{template} = 'pages/site_map.tt2';
}

sub aux_signup : Path('/aux/signup') {
    my ( $self, $c ) = @_;


    $c->stash->{template} = 'pages/aux_signup.tt2';
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
