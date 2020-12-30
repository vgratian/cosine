#!/usr/bin/perl

use strict;
use Time::HiRes;
use lib '.'; #Redundant if @IRC includes current dir
use cos_sim;

my $size = 50000;
my (@A, @B);
print("Generating 2 vectors of size $size. Similarity should be: -1.0'.\n");

# Generate random values in vectors
foreach(0..$size) {
    $A[$_] = -10;
    $B[$_] = 10;
}

my $repeat = 50;
print("Calculating Cosine Similarity. Repeating $repeat x.\n");
my $avg_runtime = 0;
my $similarity;
foreach(0..100) {
  my $begin = Time::HiRes::time();
  $similarity = &cos_sim::get_cos_sim(\@A, \@B);
  my $end = Time::HiRes::time();
  $avg_runtime += ($end-$begin);
}
$avg_runtime /= $repeat;
printf("Done. Average runtime: %.4f s. Similarity: %0f.\n", $avg_runtime, $similarity);
