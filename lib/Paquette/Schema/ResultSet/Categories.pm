package Paquette::Schema::ResultSet::Categories;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

=head1 NAME

Paquette::Schema::ResultSet::Categories - ResultSet 

=head1 DESCRIPTION

Categoriess ResultSet

=cut

sub get_categories {
    my $self = shift;
    my $rows;

    $rows = [ map { $_->id => $_->name } $self->all ];

    return $rows;
}
    


=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

