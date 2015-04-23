#!/usr/bin/env perl
use strict;
use CPAN::Meta::Requirements;

my($module, $want_version) = @ARGV;
$want_version ||= 0;

my $reqs = CPAN::Meta::Requirements->from_string_hash({ $module => $want_version });

open my $fh, '<', 'packages.txt' or die $!;
while (<$fh>) {
    if (/^$module /o) {
        my($module, $version, $distfile) = split / /;
        if ($reqs->accepts_module($module, $version)) {
            warn $_;
        }
    }
}

        
