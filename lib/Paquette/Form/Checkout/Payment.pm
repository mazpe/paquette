package Paquette::Form::Checkout::Payment;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars' );
extends 'HTML::FormHandler::Model::DBIC';
use Data::Dumper;

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

after 'setup_form' => sub {
    my $self = shift;

    if ( $self->params->{payment_type} eq "CC" ) {
        $self->field('paypal_email')->inactive(1);
    } elsif ( $self->params->{payment_type} eq "PayPal" )  {

        $self->field('credit_card_number')->inactive(1);
        $self->field('credit_card_expiration')->inactive(1);
        $self->field('credit_card_cvv')->inactive(1);
    }

};

has '+item_class' => ( default => 'Cart' );

has_field 'payment_type'        => ( 
    type                => 'Text', 
    label               => 'Payment Type', 
    required            => 1,
    required_message    => 'You must enter a shipping type', 
    css_class           => 'form_col_a',
);
has_field 'payment_amount'        => (
    type                => 'Hidden',
    label               => 'Payment Amount',
    required            => 1,
    required_message    => 'You must enter a shipping amount',
    css_class           => 'form_col_a',
);
has_field 'credit_card_number'        => (
    type                => 'Text',
    label               => 'Credit Card #',
    required            => 1,
    required_message    => 'You must enter a credit card number',
    css_class           => 'form_col_a',
);
has_field 'credit_card_expiration'        => (
    type                => 'Text',
    label               => 'Expiration (MM/YY)',
    required            => 1,
    required_message    => 'You must enter a credit card expiration',
    css_class           => 'form_col_a',
);
has_field 'credit_card_cvv'        => (
    type                => 'Text',
    label               => 'CVV',
    required            => 1,
    required_message    => 'You must enter a credit card cvv',
    css_class           => 'form_col_a',
);
has_field 'paypal_email'        => (
    type                => 'Text',
    label               => 'Paypal Email',
    required            => 1,
    required_message    => 'You must enter a paypal email',
    css_class           => 'form_col_a',
);



has_field 'submit'       => ( type => 'Submit', value => 'Save' );

no HTML::FormHandler::Moose;
1;
