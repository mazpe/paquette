use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Paquette' }
BEGIN { use_ok 'Paquette::Controller::Admin::Users' }

ok( request('/admin/users')->is_success, 'Request should succeed' );


