package Paquette::Form::Admin::Category;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars' );
extends 'HTML::FormHandler::Model::DBIC';
use Data::Dumper;

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

has '+item_class' => ( default => 'Category' );

has_field 'parent_id'        => ( 
    type                => 'Select', 
    label               => 'Parent ID', 
    required            => 1,
    required_message    => 'You must select a category', 
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
has_field 'submit' => ( type => 'Submit', value => 'Submit' );

sub options_parent_id {
    my $self = shift;
    my $rows;

    return unless $self->schema;

    $rows = $self->schema->resultset( 'Categories' )->get_categories;

    return $rows;
}

no HTML::FormHandler::Moose;
1;
