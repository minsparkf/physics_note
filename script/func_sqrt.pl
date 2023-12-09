#! /usr/bin/perl -w
use strict;
use warnings;
our $loopmax=5;
our $step=0.1;
for (my $i=-1*($loopmax); $i<$loopmax; $i+=$step){
    printf("%lf, %lf\n", $i, $i**2);
}
