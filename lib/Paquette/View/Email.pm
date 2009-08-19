package Paquette::View::Email;

use strict;
use base 'Catalyst::View::Email';

__PACKAGE__->config(
    stash_key => 'email'
);

=head1 NAME

Paquette::View::Email - Email View for Paquette

=head1 DESCRIPTION

View for sending email from Paquette. 

=head1 AUTHOR

Lester Ariel Mesa,,lesterm@gmail.com,

=head1 SEE ALSO

L<Paquette>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
