#!/usr/bin/perl

use strict;
use warnings;

my $input_file = $ARGV[0];

die "process.pl *input_file*\n" unless $input_file;

open (my $fh, "<", $input_file) or die "Couldn't open $input_file\n";

my $top;
my $bodies = {};

while (my $line = <$fh>)
{
	chomp $line;
	my ($parent, $child) = split(/\)/,$line);

	if (!$bodies->{$parent})
	{
		$bodies->{$parent} = {};
	}
	if ($bodies->{$child})
	{
		$bodies->{$child} = {};
	}

	push @{$bodies->{$parent}->{children}}, $child;
	$bodies->{$child}->{parent} = $parent;
}


my $total_orbits = 0;
foreach my $body (sort keys %{$bodies})
{
	$total_orbits += distance_to_top($bodies, $body);
}

print "$total_orbits\n";
my $santa_path = path_from_top($bodies, 'SAN');
my $you_path = path_from_top($bodies, 'YOU');

my $nearest_common_ancestor;

my $i = 0;
while ($santa_path->[$i] eq $you_path->[$i])
{
	$nearest_common_ancestor = $you_path->[$i];
	$i++;
}

my $transfers = (scalar @{$you_path} - $i) + (scalar @{$santa_path} - $i) -2;
print "$transfers\n";


sub distance_to_top
{
	my ($tree, $node_id) = @_;

	my $i = 0;

	while ($tree->{$node_id}->{parent})
	{
		$i++;
		$node_id = $tree->{$node_id}->{parent};
	}

	return $i;
}


sub path_from_top
{
	my ($tree, $node_id) = @_;

	my $path = [];

	while ($tree->{$node_id}->{parent})
	{
		unshift @{$path}, $node_id;
		$node_id = $tree->{$node_id}->{parent};
	}
	return $path;
}
