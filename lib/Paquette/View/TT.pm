package Paquette::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION  => '.tt2',
    INCLUDE_PATH        => [
        Paquette->path_to ( 'root', 'src' ),
    ],
    TIMER               => 1,
    WRAPPER             => 'wrapper.tt2',
);

=head1 NAME

Paquette::View::TT - TT View for Paquette

=head1 DESCRIPTION

TT View for Paquette. 

=head1 SEE ALSO

L<Paquette>

=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
