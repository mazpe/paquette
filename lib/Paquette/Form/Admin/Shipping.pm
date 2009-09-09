package Paquette::Form::Checkout::Shipping;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars' );
extends 'HTML::FormHandler::Model::DBIC';
use Data::Dumper;

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

has '+item_class' => ( default => 'Cart' );

has_field 'shipping_type'        => ( 
    type                => 'Text', 
    label               => 'Shipping Type', 
    required            => 1,
    required_message    => 'You must enter a shipping type', 
    css_class           => 'form_col_a',
);
has_field 'shipping_amount'        => (
    type                => 'Text',
    label               => 'Shipping Amount',
    required            => 1,
    required_message    => 'You must enter a shipping amount',
    css_class           => 'form_col_a',
);

has_field 'submit'       => ( type => 'Submit', value => 'Save' );

no HTML::FormHandler::Moose;
1;
