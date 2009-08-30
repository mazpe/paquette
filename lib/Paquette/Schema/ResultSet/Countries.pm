package Paquette::Schema::ResultSet::Countries;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

=head1 NAME

Paquette::Schema::ResultSet::Countries - ResultSet 

=head1 DESCRIPTION

Countriess ResultSet

=cut

sub get_country_names {
    my $self = shift;
    my $rows;

    $rows = [ map { $_->abbr => $_->name } $self->all ];

    return $rows;
}
    


=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

