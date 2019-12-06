#!/usr/bin/perl

use strict;
use warnings;

my $input = '278384-824795';

my ($low,$high) = split(/-/,$input);

my $candidate_count;
foreach my $i ($low..$high)
{
	if (is_candidate($i))
	{
		print "$i\n";
		$candidate_count++;
	}
}

print "Count: $candidate_count\n";

sub is_candidate
{
	my ($number) = @_;

	my @digits = split(//,$number);


	my $flags = {
		not_decreasing => 1,
		matched_pair => 0,
	};
	foreach my $i (0 .. ($#digits - 1))
	{
		$flags->{not_decreasing} = 0 if ($digits[$i+1] < $digits[$i]);
	}

	foreach my $i (0 .. ($#digits - 1))
	{
		if ($i == 0)
		{
			$flags->{matched_pair} = 1 if
			(
				$digits[$i] == $digits[$i+1]
				&& $digits[$i] != $digits[$i+2]
			)

		}
		elsif ($i == $#digits-1)
		{
			$flags->{matched_pair} = $i if
			(
				$digits[$i] == $digits[$i+1]
				&& $digits[$i] != $digits[$i-1]
			);
		}
		else
		{
			$flags->{matched_pair} = $i if (
				$digits[$i] == $digits[$i+1] 
				&& $digits[$i] != $digits[$i+2]
				&& $digits[$i] != $digits[$i-1]
			)
		}
	}

	foreach my $f (values %{$flags})
	{
		return 0 unless $f;
	}
	return 1;
}




