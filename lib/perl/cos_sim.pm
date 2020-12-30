#!/usr/bin/perl

package cos_sim;
use Math::Complex;

sub get_cos_sim {
    my @A = @{$_[0]};
    my @B = @{$_[1]};

    # Make sure vectors are of equal size
    if (scalar @A != scalar @B) {
        die "Vectors are not of equal size. Error";
    }
    my $size = scalar @A;

    # Calculate eucledian magnitude
    my $A_len = 0;
    my $B_len = 0;
    foreach(0..$size) {
        $A_len += $A[$_]**2;
        $B_len += $B[$_]**2;
    }
    my $eucl_magn = sqrt($A_len * $B_len);

    # If 0, stop calculation
    if ($eucl_magn == 0) {
        return undef;
    }

    # Calculate dot product
    my $dot_prod = 0;
    foreach(0..$size) {
        $dot_prod += $A[$_] * $B[$_];
    }

    # Return cosine similarity
    return $dot_prod / $eucl_magn;
}

1;
