Throttle
========

An API throttling library for [Elixir](http://elixir-lang.org) and
[Plug](https://github.com/elixir-lang/plug)

This Plug uses an implementation of the [Leaky Bucket algorithm](#) for rate
limiting.

Still a work in progress

## TODO

* --Leaky Bucket processes--
* --Supervision Tree--
* --Bucket Manager--
* --Fail Over Storage--
* --Timer--
* -- Start timer as part of the OTP app --
* -- Register buckets with timer --
* Plug
* Recovery of Failed Buckets
* Buckets should probably disappear if they leak completely
* Deploy to Hex
* Update README with usage details
* Update README with contributing details
* Contributors file
