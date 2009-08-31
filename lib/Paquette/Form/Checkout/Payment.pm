package Paquette::Form::Checkout::Payment;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars' );
extends 'HTML::FormHandler::Model::DBIC';
use Data::Dumper;

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

before 'setup_form' => sub {
    my $self = shift;

    #if (1) {
        #$self->field('password')->inactive(1);
        #$self->field('password_conf')->inactive(1);
    #}
};

has '+item_class' => ( default => 'Customer' );

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
    css_class           => 'form_col_a',
);
has_field 'bill_company'        => (
    type                => 'Text',
    label               => 'Company',
    css_class           => 'form_col_a',
);
has_field 'bill_address1'        => (
    type                => 'Text',
    label               => 'Address 1',
    required            => 1,
    required_message    => 'You must enter your Address1',
    css_class           => 'form_col_a',
);
has_field 'bill_address2'        => (
    type                => 'Text',
    label               => 'Address 2',
    css_class           => 'form_col_a',
);
has_field 'bill_city'        => (
    type                => 'Text',
    label               => 'City',
    required            => 1,
    required_message    => 'You must enter your City',
    css_class           => 'form_col_a',
);
has_field 'bill_state'        => (
    type                => 'Select',
    label               => 'State',
    required            => 1,
    required_message    => 'You must enter your State',
    css_class           => 'form_col_a',
);
has_field 'bill_zip_code'        => (
    type                => 'Text',
    label               => 'Zip Code',
    required            => 1,
    required_message    => 'You must enter your Zip Code',
    css_class           => 'form_col_a',
);
has_field 'bill_country'        => (
    type                => 'Select',
    label               => 'Country',
    required            => 1,
    required_message    => 'You must enter your Country',
    css_class           => 'form_col_a',
);
has_field 'bill_phone'        => (
    type                => 'Text',
    label               => 'Phone',
    required            => 1,
    required_message    => 'You must enter your Phone',
    css_class           => 'form_col_a',
);

has_field 'ship_first_name'        => (
    type                => 'Text',
    label               => 'First Name',
    required            => 1,
    required_message    => 'You must enter your first name',
    css_class           => 'form_col_a',
);
has_field 'ship_last_name'        => (
    type                => 'Text',
    label               => 'Last Name',
    required            => 1,
    required_message    => 'You must enter your last name',
    css_class           => 'form_col_a',
);
has_field 'ship_company'        => (
    type                => 'Text',
    label               => 'Company',
    css_class           => 'form_col_a',
);
has_field 'ship_address1'        => (
    type                => 'Text',
    label               => 'Address 1',
    required            => 1,
    required_message    => 'You must enter your Address1',
    css_class           => 'form_col_a',
);
has_field 'ship_address2'        => (
    type                => 'Text',
    label               => 'Address 2',
    css_class           => 'form_col_a',
);
has_field 'ship_city'        => (
    type                => 'Text',
    label               => 'City',
    required            => 1,
    required_message    => 'You must enter your City',
    css_class           => 'form_col_a',
);
has_field 'ship_state'        => (
    type                => 'Select',
    label               => 'State',
    required            => 1,
    required_message    => 'You must enter your State',
    css_class           => 'form_col_a',
);
has_field 'ship_zip_code'        => (
    type                => 'Text',
    label               => 'Zip Code',
    required            => 1,
    required_message    => 'You must enter your Zip Code',
    css_class           => 'form_col_a',
);
has_field 'ship_country'        => (
    type                => 'Select',
    label               => 'Country',
    required            => 1,
    required_message    => 'You must enter your Country',
    css_class           => 'form_col_a',
);
has_field 'ship_phone'        => (
    type                => 'Text',
    label               => 'Phone',
    required            => 1,
    required_message    => 'You must enter your Phone',
    css_class           => 'form_col_a',
);
has_field 'email'        => (
    type                => 'Email',
    label               => 'Email',
    required            => 1,
    required_message    => 'You must enter your first name',
    unique              => 1,
    unique_message      => 'Your email address is already in database',
    css_class           => 'form_col_a',
);
has_field 'password'    => (
    type                => 'Password',
    minlength           => 6,
    label               => 'Password',
    required            => 1,
    required_message    => 'You must provide a password',
    apply               => [ NoSpaces, WordChars ],
    css_class           => 'form_col_a',
);
has_field 'password_conf'   => (
    type                => 'PasswordConf',
    label               => 'Confirm',
    password_field      => 'password',
    css_class           => 'form_col_a',
);

has_field 'submit'       => ( type => 'Submit', value => 'Save' );

sub options_bill_state {
    my $self = shift;
    my $rows;

    return unless $self->schema;

    $rows = $self->schema->resultset( 'States' )->get_state_names;

    return $rows;
}

sub options_bill_country {
    my $self = shift;
    my $rows;

    return unless $self->schema;

    $rows = $self->schema->resultset( 'Countries' )->get_country_names;

    return $rows;
}

sub options_ship_state {
    my $self = shift;
    my $rows;

    return unless $self->schema;

    $rows = $self->schema->resultset( 'States' )->get_state_names;

    return $rows;
}

sub options_ship_country {
    my $self = shift;
    my $rows;

    return unless $self->schema;

    $rows = $self->schema->resultset( 'Countries' )->get_country_names;

    return $rows;
}


no HTML::FormHandler::Moose;
1;
