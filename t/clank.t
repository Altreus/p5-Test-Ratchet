#!perl

use strict;
use warnings;

use Test::Ratchet qw(ratchet clank);
use Test::Most 'no_plan';
use Try::Tiny;

subtest "Clank runs" => sub {
    my $clank = clank sub {
        ok "Clank runs";
    };
    $clank->();
};

subtest "Clank doesn't run" => sub {
    die_on_fail;
    dies_ok {
        do {
            my $clank = clank sub {
                fail "Clank ran!";
            }
        }
    };

    restore_fail;
};

subtest "Clank in a ratchet" => sub {
    subtest "Everything runs" => sub {
        my $ratchet = ratchet(
            clank sub { ok "Clank1" },
            clank sub { ok "Clank2" }
        );

        $ratchet->();
        $ratchet->();
    };

    subtest "One doesn't run" => sub {
        TODO: {
            local $TODO = "Clank expected to fail";
            do {
                my $ratchet = ratchet(
                    sub { note "Not a clank" }, # Can't be an ok or TODO would be sad
                    clank sub { ok "Clank2" }
                );

                $ratchet->();
            }
        }
    }
};

done_testing;
