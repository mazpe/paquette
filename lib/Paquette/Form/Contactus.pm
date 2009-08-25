package Paquette::Form::Product;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Renderer::Simple';

has '+item_class' => ( default => 'Product' );

has_field 'first_name' => ( type => 'Text' );
has_field 'last_name' => ( type => 'Text' );
has_field 'email' => ( type => 'Email' );
has_field 'city' => ( type => 'Text' );
has_field 'state' => ( type => 'Select' );
has_field 'zip_code' => ( type => 'Select' );
has_field 'country' => ( type => 'Select' );


has '+dependency' => ( default => sub {
      [ ['address', 'city', 'state'], ]
   }
);

no HTML::FormHandler::Moose;
1;
