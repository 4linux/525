#!/usr/bin/perl

use strict;
use IO::Socket;

my %machines = (
        'jenkins' => '172.27.11.10:8080',
        'gitea' => '172.27.11.10:3000',
        'docker' => '255.255.255.255:65535'
);

my $status = 0;

while (my ($machine, $address) = each %machines) {

        my ($host, $port) = split(/:/, $address);
        my $socket = IO::Socket::INET->new(PeerAddr => $host,
                                        PeerPort => $port,
                                        Proto    => "tcp");
        my $msg = "ok";
        if (!$socket) {
                $status = 1;
                $msg = "erro";
        }

        printf "%-10s em %-22s %s!\n", $machine, $address, $msg;
        eval {
                close($socket);
        }
}

exit $status; # diferente de zero, problemas
