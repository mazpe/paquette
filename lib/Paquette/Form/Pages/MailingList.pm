package Paquette::Form::Pages::MailingList;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars' );
extends 'HTML::FormHandler::Model::DBIC';
use Data::Dumper;

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

has '+item_class' => ( default => 'Lead' );

has_field 'first_name'        => ( 
    type                => 'Text', 
    label               => 'First Name', 
    required            => 1,
    required_message    => 'You must enter your first name', 
    css_class           => 'form_col_a',
);
has_field 'last_name'        => (
    type                => 'Text',
    label               => 'Last Name',
    required            => 1,
    required_message    => 'You must enter your last name',
    css_class           => 'form_col_a',
);
has_field 'email'        => (
    type                => 'Email',
    label               => 'Email',
    required            => 1,
    required_message    => 'You must enter your email address',
    css_class           => 'form_col_a',
);
has_field 'type'        => (
    type                => 'Hidden',
    required            => 1,
);
has_field 'opt_in'        => (
    type                => 'Hidden',
    required            => 1,
);


has_field 'submit'       => ( type => 'Submit', value => 'Save' );

no HTML::FormHandler::Moose;
1;
