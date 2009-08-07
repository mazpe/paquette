package MyCustomer;

use Moose;
use MooseX::Types::Moose qw(Str Int ArrayRef);
use namespace::autoclean;
use Data::Dumper;

has 'user'      => ( is => 'ro', required => 1, weak_ref => 1 );
has 'session'   => ( is => 'ro', required => 1, weak_ref => 1 );
has 'schema'    => ( is => 'rw', required => 1, handles => [qw / resultset /] );
has 'bill_first_name'       => ( is => 'ro', isa => Str );
has 'bill_last_name'        => ( is => 'ro', isa => Str );
has 'email'                 => ( is => 'ro', isa => Str );

# create customer
sub create_customer {
    my ( $self, $args ) = @_;

    if ( $args ) {
    # We have arguments

        $self->resultset('Customer')->create_customer( $args ); 
    
    } else {
    # No arguments submited

    }

} 
# get customer

# update customer

# delete customer



1;
