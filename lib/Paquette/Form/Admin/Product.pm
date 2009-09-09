package Paquette::Form::Admin::Product;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars' );
extends 'HTML::FormHandler::Model::DBIC';
use Data::Dumper;

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

has '+item_class' => ( default => 'Product' );

has_field 'category_id'        => ( 
    type                => 'Select', 
    label               => 'Category', 
    required            => 1,
    required_message    => 'You must select a category', 
    css_class           => 'form_col_a',
);
has_field 'sku'        => (
    type                => 'Text',
    label               => 'SKU',
    required            => 1,
    required_message    => 'You must enter a SKU number',
    unique              => 1,
    unique_message      => 'Your SKU is already in the database',
    css_class           => 'form_col_a',
);
has_field 'name'        => (
    type                => 'Text',
    label               => 'Name',
    required            => 1,
    required_message    => 'You must enter a name',
    css_class           => 'form_col_a',
);
has_field 'url_name'        => (
    type                => 'Text',
    label               => 'URL Name',
    required            => 1,
    required_message    => 'You must enter a URL Name',
    unique              => 1,
    unique_message      => 'Your URL Name is already in the database',
    css_class           => 'form_col_a',
);
has_field 'brief_description'        => (
    type                => 'Text',
    label               => 'Brief Description',
    css_class           => 'form_col_a',
);
has_field 'description'        => (
    type                => 'TextArea',
    label               => 'Description',
    css_class           => 'form_col_a',
    cols                => 30,
    rows                => 5,
);
has_field 'price'        => (
    type                => 'Text',
    label               => 'Price',
    required            => 1,
    required_message    => 'You must enter a Price',
    css_class           => 'form_col_a',
);
has_field 'submit' => ( type => 'Submit', value => 'Submit' );


sub options_category_id {
    my $self = shift;
    my $rows;

    return unless $self->schema;

    $rows = $self->schema->resultset( 'Categories' )->get_categories;

    return $rows;
}

no HTML::FormHandler::Moose;
1;
