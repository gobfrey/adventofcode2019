#!/usr/bin/perl

use strict;
use warnings;

my $input = '1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,19,5,23,2,23,13,27,1,10,27,31,2,31,6,35,1,5,35,39,1,39,10,43,2,9,43,47,1,47,5,51,2,51,9,55,1,13,55,59,1,13,59,63,1,6,63,67,2,13,67,71,1,10,71,75,2,13,75,79,1,5,79,83,2,83,9,87,2,87,13,91,1,91,5,95,2,9,95,99,1,99,5,103,1,2,103,107,1,10,107,0,99,2,14,0,0';

#my $input = '1,0,0,0,99';
#my $input = '2,4,4,5,99,0';
#my $input = '1,1,1,4,99,5,6,0,99';

my @program = split(',',$input);


my $OPS = {
	'1' => sub { my ($a, $b) = @_; return $a + $b; },
	'2' => sub { my ($a, $b) = @_; return $a * $b; }
};

foreach my $noun (0..99)
{
	foreach my $verb (0..99)
	{
		initialise_program();
		$program[1] = $noun;
		$program[2] = $verb;
		execute_program();
		print "$noun,$verb => " . join(',',@program) . "\n";
		if ($program[0] == 19690720)
		{
			exit;
		}
	}
}


sub initialise_program
{
	@program = split(',',$input);
}

sub execute_program
{
	my $position = 0;
	while ($program[$position] != '99')
	{
		operate($position);
		$position += 4;
	}
}

print join(',',@program);


sub operate
{
	my ($position) = @_;

	my $opcode = $program[$position];

	die "Unexpected opcode $opcode\n" unless valid_opcode($opcode);

	my $result = &{$OPS->{$opcode}}($program[$program[$position+1]],$program[$program[$position+2]]);
	$program[$program[$position+3]] = $result;

}

sub valid_opcode
{
	my ($opcode) = @_;

	return 1 if $OPS->{$opcode};
	return 0;
}

