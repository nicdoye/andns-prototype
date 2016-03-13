#!/usr/bin/env perl

# This is a Proof of Concept and not meant to be perfect code

use strict;
use warnings;
use Net::DNS;
use Net::DNS::Resolver;
use Redis;

use Data::Dumper;
use Time::HiRes qw( usleep ualarm gettimeofday tv_interval nanosleep
                      clock_gettime clock_getres clock_nanosleep clock
                      stat lstat );
use feature qw /say/;

use constant DOCKER_MACHINE => '192.168.99.100';

# Local docker image
our $redis = Redis->new(server => DOCKER_MACHINE . ':6379');
# Also a docker image
our $res   = Net::DNS::Resolver->new(nameservers => [DOCKER_MACHINE]);

sub demo {
    my $t0 = [gettimeofday];
    foreach my $str ("aa" .. "zz") {
        try_get("www.${str}.com");
    }
    my $t1 = [gettimeofday];
    my $t0_t1 = tv_interval $t0, $t1;
    say "";
    say $t0_t1;
}

sub key { return $_[0] . ".." . $_[1];}

sub try_set {
    my $host = shift;

    my $reply = $res->search($host);

    if ($reply) {
        foreach my $rr ($reply->answer) {
            next unless $rr->type eq "A";
            # Note this only sets one value per host
            $redis->set(key($host, "A"), $rr->address, 'EX', $rr->ttl, 'NX')
                unless( $rr->ttl == 0 );
        }
    }
}

sub try_get {
    my $host = shift;

    return $redis->get(key($host, "A")) || try_set($host);
}

demo();
