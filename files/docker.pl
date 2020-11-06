#!/usr/bin/perl

use strict;
use warnings;

my $needed = <<EOF;
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "5m",
        "max-file": "3"
   }
}
EOF

my $exists = open my $daemon_json, '<', '/etc/docker/daemon.json';
my $found = $exists ? do { local $/; <$daemon_json> } : '';

if ($needed ne $found) {
    system('apt-get', 'update');
    system('apt-get', 'install', '-y', 'docker.io');
    open(FH, '>', '/etc/docker/daemon.json') or die $!;
    print FH $needed;
    system('systemctl', 'restart', 'docker');
}
