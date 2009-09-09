package Paquette::Controller::Admin::Login;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Paquette::Controller::Admin::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index : Local {
    my ($self, $c) = @_;

    # Get the username and password from form
    my $username = $c->request->params->{username} || "";
    my $password = $c->request->params->{password} || "";

    # If the username and password values were found in form
    if ($username && $password) {

        # Attempt to log the user in
        # Using searchargs to authenticate because of non-standard table layout
        # We can also use it to accept username or nickname
        my $auth = $c->authenticate(
            {
                password    => $password,
                'dbix_class' => {
                    searchargs => [
                        {
                            'email' => $username,
                        }
                    ]
                },
            }
        );

        if ($auth) {

            # If successful, then let them use the application
            $c->response->redirect($c->uri_for(
                $c->controller('Admin')->action_for('index')));

        } else {
            # Set an error message
            $c->stash->{error_msg} = "Bad username or password.";
        }

    }

    # If either of above don't work out, send to the login page
    $c->stash->{wrapper_admin} = 1;
    $c->stash->{template} = 'admin/login.tt2';

}


=head1 AUTHOR

Lester Ariel Mesa,,305-402-6717,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
