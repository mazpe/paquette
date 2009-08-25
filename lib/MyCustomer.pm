package MyCustomer;

use Moose;
use MooseX::Types::Moose qw(Str Int ArrayRef);
use namespace::autoclean;
use Data::Dumper;

has 'user'      => ( is => 'ro', required => 1, weak_ref => 1 );
has 'session'   => ( is => 'ro', required => 1, weak_ref => 1 );
has 'schema'    => ( is => 'rw', required => 1, handles => [qw / resultset /] );

# create customer
sub create_customer {
    my ( $self, $args ) = @_;
    my $customer;
    my $user_account;

    if ( $args ) {
    # We have arguments

        # Create a new hash with our submitted arguments
        my $customer_args = $args;
        my %email_args = ( 
            username => $customer_args->{email},
            password => $customer_args->{password},
        );

        # Remove arguments not used by Customer resultset
        delete $customer_args->{same_as}; 
        delete $customer_args->{submit}; 
        delete $customer_args->{password}; 
        delete $customer_args->{verify_password}; 

        # Create a customer
        $customer 
            = $self->resultset('Customer')->create_customer( $customer_args ); 

        if ( $customer ) {
        # Customer was created       

            # Create customer login account
            $user_account 
                = $self->resultset('User')->create_user_account( {
                username            => $email_args{username},
                password            => $email_args{password},
            } );
            
        } else {
        # Customer was not created
            
            
        }
    
    } else {
    # No arguments submited

    }

} 
# get customer
sub get_customer { # Return list of items
    my ( $self, $args ) = @_;
    my $a_customer;


    if ( $args ) {
    # we have arguments
        $a_customer 
            = $self->resultset('Customer')->get_customer_by_email($args);
                

    } else {    
    # we have no arguments


    }

    return $a_customer ? $a_customer : 0;
}

sub get_customer_row { # Return list of items
    my ( $self, $args ) = @_;
    my $a_customer;


    if ( $args ) {
    # we have arguments
        $a_customer
            = $self->resultset('Customer')->get_customer($args);


    } else {
    # we have no arguments


    }

    return $a_customer ? $a_customer : 0;
}


# update customer

# delete customer



1;
