use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Paquette' }
BEGIN { use_ok 'Paquette::Controller::Admin::Logout' }

ok( request('/admin/logout')->is_success, 'Request should succeed' );


