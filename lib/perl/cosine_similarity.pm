#!/usr/bin/perl

package cos_sim;

sub get_cos_sim {
    my ($size, $a, $b) = @_;
    my $n = $size-1;

    # Calculate eucledian magnitude
    my $a_len = 0;
    my $b_len = 0;
    foreach(0..$n) {
        $a_len += (@$a[$_]**2);
        $b_len += (@$b[$_]**2);
    }
    my $eucl_magn = sqrt($a_len * $b_len);

    # If 0, stop calculation
    if ($eucl_magn == 0) {
        return undef;
    }

    # Calculate dot product
    my $dot_prod = 0;
    foreach(0..$n) {
        $dot_prod += (@$a[$_] * @$b[$_]);
    }

    # Return cosine similarity
    return $dot_prod / $eucl_magn;
}

1;
