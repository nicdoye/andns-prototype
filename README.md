# andns-prototype
Perl Prototype For ANDNS

Proof of concept and eventual prototype for ANDNS. Why Perl? Because I'm most fluent in it.

Running demo.pl on Perl 5.23.8 on El Capitan over a 100Mb home connection, using Redis 3.0.7 (Alpine docker image) and BIND 9.9.5-3ubuntu0.7-Ubuntu (docker iamge) on docker-machine.

* Netgear Router & empty Redis Cache: c.360-420s (620s on first run)
* BIND 9.9.5-3ubuntu0.7-Ubuntu (Docker) & empty Redis Cache: c.470s
* BIND 9.9.5-3ubuntu0.7-Ubuntu (Docker) & Redis code commented out: c.460s
* Redis: 270s (within 0.5s)

I think this shows, despite the limitations of the test, that the Redis version is faster, and that's with only *one* Redis server. More intelligent hashing of results could allow for sharding (for *big* sites/network operators).

Nic Doye - 2016.03.13
