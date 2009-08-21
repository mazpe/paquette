package Paquette::Controller::WebTools;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Paquette::Controller::WebTools - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Paquette::Controller::WebTools in WebTools.');
}

sub random_images : Local {
    my ( $self, $c ) = @_;
    
    my $random_image = $c->model('PaquetteDB::RandomImage')->search(
        { },
        { order_by => 'RAND()' },
    )->first;

    $c->stash->{random_image} = $random_image;
    $c->stash->{template} = 'webtools/random_image.tt2';
    $c->forward( $c->view('TTNoWrapper') );
}

=head1 AUTHOR

Lester Ariel Mesa,,lesterm@gmail.com,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
