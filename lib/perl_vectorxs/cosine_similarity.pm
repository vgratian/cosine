#!/usr/bin/perl

package cos_sim;
use Math::Vector::Real; # Math::Vector::Real::XS

sub get_cos_sim {
    my ($size, $a, $b) = @_;
    my $n = $size-1;

    my $va = V(@$a);
    my $vb = V(@$b);
    # Calculate eucledian magnitude
    my $a_len = abs($va);
    my $b_len = abs($vb);

    my $eucl_magn = sqrt($a_len * $b_len);

    # If 0, stop calculation
    if ($eucl_magn == 0) {
        return undef;
    }

    # Calculate dot product
    my $dot_prod = $va * $vb;

    # Return cosine similarity
    return $dot_prod / $eucl_magn;
}

1;
