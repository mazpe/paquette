package Paquette::Form::User;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars', 'NotAllDigits' );
extends 'HTML::FormHandler::Model::DBIC';

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

has '+item_class' => ( default => 'User' );

has_field 'bill_first_name'        => (
    type                => 'Text',
    label               => 'First Name',
    required            => 1,
    required_message    => 'You must enter your first name',
    css_class           => 'form_col_a',
);
has_field 'bill_last_name'        => (
    type                => 'Text',
    label               => 'Last Name',
    required            => 1,
    required_message    => 'You must enter your last name',
    css_class           => 'form_col_b',
);

no HTML::FormHandler::Moose;
1;
