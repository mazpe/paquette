package Paquette::Schema::ResultSet::Orders;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use Data::Dumper;

=head1 NAME

Paquette::Schema::ResultSet::Orders - ResultSet 

=head1 DESCRIPTION

Orderss ResultSet

=cut

sub create_order {
    my ( $self, $args ) = @_;
    my $order;

    print Dumper $args;
    $order = $self->create($args);

    return $order;
}

sub delete {
    my ( $self, $args ) = @_;
    my $order;

    $order = $self->find($args);

    $order->delete if ($order);

}

sub get_order_id {
    my ( $self, $args ) = @_;
    my $order;

    $order = $self->find($args);

    return $order;
}


=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

