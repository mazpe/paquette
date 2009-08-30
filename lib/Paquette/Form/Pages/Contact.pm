package Paquette::Form::Pages::Contact;
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
has_field 'company'        => (
    type                => 'Text',
    label               => 'Company',
    css_class           => 'form_col_a',
);
has_field 'address1'        => (
    type                => 'Text',
    label               => 'Address 1',
    css_class           => 'form_col_a',
);
has_field 'address2'        => (
    type                => 'Text',
    label               => 'Address 2',
    css_class           => 'form_col_a',
);
has_field 'city'        => (
    type                => 'Text',
    label               => 'City',
    css_class           => 'form_col_a',
);
has_field 'state'        => (
    type                => 'Select',
    label               => 'State',
    css_class           => 'form_col_a',
);
has_field 'zip_code'        => (
    type                => 'Text',
    label               => 'Zip Code',
    css_class           => 'form_col_a',
);
has_field 'country'        => (
    type                => 'Select',
    label               => 'Country',
    css_class           => 'form_col_a',
);
has_field 'phone'        => (
    type                => 'Text',
    label               => 'Phone',
    css_class           => 'form_col_a',
);
has_field 'message'        => (
    type                => 'TextArea',
    label               => 'Message',
    rows                => 5,
    cols                => 17,
    required            => 1,
    required_message    => 'You must enter your Message',
    css_class           => 'form_col_a',
);
has_field 'email'        => (
    type                => 'Email',
    label               => 'Email',
    required            => 1,
    required_message    => 'You must enter your email address',
    css_class           => 'form_col_a',
);

has_field 'submit'       => ( type => 'Submit', value => 'Save' );

sub options_state {
    my $self = shift;
    my $rows;

    return unless $self->schema;

    $rows = $self->schema->resultset( 'States' )->get_state_names;

    return $rows;
}

sub options_country {
    my $self = shift;
    my $rows;

    return unless $self->schema;

    $rows = $self->schema->resultset( 'Countries' )->get_country_names;

    return $rows;
}

no HTML::FormHandler::Moose;
1;
