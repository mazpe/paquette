package Paquette::Schema::ResultSet::MailingList;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use Data::Dumper;

=head1 NAME

Paquette::Schema::ResultSet::MailingList - ResultSet 

=head1 DESCRIPTION

MailingLists ResultSet

=cut

sub join_mailing_list {
    my ( $self, $args ) = @_;

    my $entry = $self->find_or_new ( $args, { key => 'email' } );

    unless ( $entry->in_storage ) {
    # MailingList not found
    
        # Create cart
        $entry->insert;
    
    } else {

        # Update cart
        $entry->update( $args );
    
    }

    return $entry;
}

=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

