#!perl

use 5.010;
use strict;
use warnings;

use Test::More 0.98;

use SHARYANTO::MaybeXS qw(clone uniq);

# XXX test uniq

subtest "uniq" => sub {
    is_deeply([uniq(1, 3, 2, 1, 3, 4)], [1, 3, 2, 4]);
};

DONE_TESTING:
done_testing();
