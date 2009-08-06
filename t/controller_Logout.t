use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Paquette' }
BEGIN { use_ok 'Paquette::Controller::Logout' }

ok( request('/logout')->is_success, 'Request should succeed' );


