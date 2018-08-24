#!/usr/bin/perl

use strict;
use Time::HiRes;
use lib '.'; #Redundant if @IRC includes current dir
use cos_sim;

my $size = 10000;
my (@vect0, @vect1);
print("Generating 2 vectors of size $size with random values in range -10 to 10.\n");

# Generate random values in vectors
foreach(0..$size) {
    $vect0[$_] = int(rand(20)) + -10;
    $vect1[$_] = int(rand(20)) + -10;
}

my $begin = Time::HiRes::time();
print("Calculating Cosine Similarity Repeating 100x.\n");
foreach(0..100) {
    my $sim = &cos_sim::get_cos_sim(\@vect0, \@vect1);
}
my $end = Time::HiRes::time();
my $runtime = $end - $begin;

printf("Done. Runtime: %.3f s.\n", $runtime);
