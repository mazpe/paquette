package Paquette::Schema::ResultSet::Product;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use Data::Dumper;

=head1 NAME

Paquette::Schema::ResultSet::Product - ResultSet 

=head1 DESCRIPTION

Products ResultSet

=cut

sub get_item_by_sku {
    my ( $self, $sku ) = @_;

    my $item = $self->find( { sku => $sku } );

    return $item;
}

=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

