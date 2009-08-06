package Paquette::Controller::Admin::Users;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Paquette::Controller::Admin::Users - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Paquette::Controller::Admin::Users in Admin::Users.');
}

sub set_password : Local  {
    my ( $self, $c ) = @_;

    my @users = $c->model('PaquetteDB::User')->all;

    foreach my $user (@users) {

        $user->password('admin');
        $user->update;
    }

    $c->response->body('done');

}

=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
