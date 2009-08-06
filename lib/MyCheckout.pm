package MyCheckout;

use Moose;
use MooseX::Types::Moose qw(Str Int ArrayRef);
use namespace::autoclean;
use Data::Dumper;

has 'user'      => ( is => 'ro', required => 1, weak_ref => 1 );
has 'session'   => ( is => 'ro', required => 1, weak_ref => 1 );
has 'schema'    => ( is => 'rw', required => 1, handles => [qw / resultset /] );
has 'sku'       => ( is => 'ro', isa => Str );
has 'qty'       => ( is => 'ro', isa => Int, default => 0 );

has '_items'    => ( is => 'ro', isa => ArrayRef, lazy_build => 1 );

# customer login or signup 

# shipping 

# payment

# order confirmation

# process order
 

1;
