package Paquette::Schema::ResultSet::States;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

=head1 NAME

Paquette::Schema::ResultSet::States - ResultSet 

=head1 DESCRIPTION

Statess ResultSet

=cut

sub get_state_names {
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

