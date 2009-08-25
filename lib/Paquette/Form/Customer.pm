package Paquette::Form::Customer;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars', 'NotAllDigits' );
extends 'HTML::FormHandler::Model::DBIC';

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

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
    label               => 'Company Name',
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
    type                => 'Text',
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
    type                => 'Text',
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
    label               => 'Company Name',
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
    type                => 'Text',
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
    type                => 'Text',
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
    minlength           => 7,
    label               => 'Password',
    required            => 1,
    required_message    => 'You must provide a password',
    apply               => [ NoSpaces, WordChars, NotAllDigits ],
    css_class           => 'form_col_a',
);
has_field 'password_conf'   => (
    type                => 'PasswordConf',
    label               => 'Confirm',
    password_field      => 'password',
    css_class           => 'form_col_a',
);

has_field 'submit'       => ( type => 'Submit', value => 'Save' );


no HTML::FormHandler::Moose;
1;
