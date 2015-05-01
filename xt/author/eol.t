use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::EOL 0.17

use Test::More 0.88;
use Test::EOL;

my @files = (
    'lib/Gentoo/Util/VirtualDepend.pm',
    't/00-compile/lib_Gentoo_Util_VirtualDepend_pm.t',
    't/00-report-prereqs.dd',
    't/00-report-prereqs.t',
    't/basic.t',
    't/range-deprecated.t',
    't/simulate-map.t'
);

eol_unix_ok($_, { trailing_whitespace => 1 }) foreach @files;
done_testing;