package Paquette::Form::Product;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Render::Simple';

has '+item_class' => ( default => 'Product' );

has_field 'category'    => ( type => 'Select' );
has_field 'sku'         => ( type => 'Text' );
has_field 'name'        => ( type => 'Text' );
has_field 'url_name'    => ( type => 'Text' );
has_field 'description' => ( type => 'Select' );
has_field 'price'    => ( type => 'Select' );


no HTML::FormHandler::Moose;
1;
