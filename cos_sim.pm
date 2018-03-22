#!/usr/bin/perl

package cos_sim;
use Math::Complex;

sub get_cos_sim {
    my @vector0 = @{$_[0]};
    my @vector1 = @{$_[1]};

    # Make sure vectors are of equal size
    if (scalar @vector0 != scalar @vector1) {
        die "Vectors are not of equal size. Error";
    }

    # Calculate dot product
    my $size = scalar @vector0;
    my $dot_prod = 0;
    foreach(0..$size) {
        $dot_prod += $vector0[$_] * $vector1[$_];
    }

    # If dot product is 0, stop calculation
    if ($dot_prod == 0) {
        return $dot_prod;
    }

    # Calculate eucledian magnitude
    my $eucl_len0 = 0;
    my $eucl_len1 = 0;
    foreach(0..$size) {
        $eucl_len0 += $vector0[$_]**2;
        $eucl_len1 += $vector1[$_]**2;
    }
    my $eucl_magn = sqrt($eucl_len0) * sqrt($eucl_len1);

    # Return cosine similarity
    return $dot_prod / $eucl_magn;
}

1;
