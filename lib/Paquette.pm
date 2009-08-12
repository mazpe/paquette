package Paquette;

use strict;
use warnings;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use parent qw/Catalyst/;
use Catalyst qw/-Debug
                ConfigLoader
                Static::Simple

                StackTrace
                SubRequest
            
                Authentication

                Session
                Session::Store::File
                Session::State::Cookie
/;
our $VERSION = '0.05';

# Configure the application.
#
# Note that settings in paquette.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( 
    name        => 'Paquette',
    session     => {flash_to_stash => 1},
#    'View::Email' => {
#        # Where to look in the stash for the email information.
#        # 'email' is the default, so you don't have to specify it.
#        stash_key => 'email',
#        # Define the defaults for the mail
#        default => {
#            # Defines the default content type (mime type). Mandatory
#            content_type => 'text/plain',
#            # Defines the default charset for every MIME part with the 
#            # content type text.
#            # According to RFC2049 a MIME part without a charset should
#            # be treated as US-ASCII by the mail client.
#            # If the charset is not set it won't be set for all MIME parts
#            # without an overridden one.
#            # Default: none
#            charset => 'utf-8'
#        },
#        # Setup how to send the email
#        # all those options are passed directly to Email::Send
#        sender => {
#            mailer => 'SMTP',
#            # mailer_args is passed directly into Email::Send 
#            mailer_args => {
#                Host     => 'mail.gbrnd.com', # defaults to localhost
#                username => 'web71_admin',
#                password => '4dm1n',
#            }
#        }
#    },
#    'View::Email::Template' => {
#        template_prefix => 'src/email',
#        default => {
#            view => 'TT',
#        },
#    },

);

__PACKAGE__->config->{'Plugin::Authentication'} = {
        default => {
            class           => 'SimpleDB',
            user_model      => 'PaquetteDB::User',
            password_type   => 'self_check',
        },

    };

# Start the application
__PACKAGE__->setup();


=head1 NAME

Paquette - Catalyst based application

=head1 SYNOPSIS

    script/paquette_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Paquette::Controller::Root>, L<Catalyst>

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
