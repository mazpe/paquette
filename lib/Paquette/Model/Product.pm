package Paquette::Model::Product;

use Moose;
use MyCart;
use namespace::autoclean;
extends 'Catalyst::Model';

#with 'Catalyst::Component::InstancePerContext';

=head1 NAME

Paquette::Model::Product - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=cut

sub product_exists {
    my ( $self, $c ) = @_;

}

=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
