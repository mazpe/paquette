package Paquette::View::Email::Template;

use strict;
use base 'Catalyst::View::Email::Template';

__PACKAGE__->config(
    stash_key       => 'email',
    template_prefix => ''
);

=head1 NAME

Paquette::View::Email::Template - Templated Email View for Paquette

=head1 DESCRIPTION

View for sending template-generated email from Paquette. 

=head1 AUTHOR

Lester Ariel Mesa,,lesterm@gmail.com,

=head1 SEE ALSO

L<Paquette>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
