package NGS::Tools::BWA::Roles::Mem;
use Moose::Role;
use MooseX::Params::Validate;

use strict;
use warnings FATAL => 'all';
use namespace::autoclean;
use autodie;
use File::Basename;
use Data::UUID;

=head1 NAME

NGS::Tools::BWA::Roles::Mem

=head1 SYNOPSIS

A Perl Moose Role for the BWA mem alignment algorithm.

=head1 ATTRIBUTES AND DELEGATES

=head1 SUBROUTINES/METHODS

=head2 $obj->mem()

Run the BWA mem alignment algorithm.

=head3 Arguments:

=over 2

=item * fastq1: FASTQ file for read 1 (required)

=item * fastq2: FASTQ file for read 2 (required)

=item * reference: reference index (required)

=item * output: name of output file to write data to (default: <fastq1 prefix>.sam)

=item * bwa: full path to the BWA program (default: bwa)

=item * threads: number of threads to execute BWA with (default: 1)

=item * options: additional options to pass to BWA (optional)

=item * readgroup: read group string to be used in SAM/BAM header

=item * samtools: name of samtools program (default: samtools)

=back

=cut

sub mem {
	my $self = shift;
	my %args = validated_hash(
		\@_,
		fastq1 => {
			isa         => 'Str',
			required    => 1
			},
		fastq2 => {
			isa			=> 'Str',
			required	=> 1
			},
		reference => {
			isa			=> 'Str',
			required	=> 1
			},
		output => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		bwa => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'bwa'
			},
		threads => {
			isa			=> 'Int',
			required	=> 0,
			default		=> 1
			},
		options => {
			isa			=> 'ArrayRef',
			required	=> 0,
			default		=> []
			},
		readgroup => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		samtools => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'samtools'
			}
		);

	# check for output file in the arguments, if it doesn't exist,
	# use the fastq1 prefix for the filename and append ".sam"
	my $output;
	if ($args{'output'} eq '') {
		$output = join('.',
			basename($args{'fastq1'}, qw(.fastq .fq. .fastq.gz .fq.gz)),
			'bam'
			);
		}
	else {
		$output = $args{'output'};
		}

	# the program to use is "bwa mem", here we're appending the full path to
	# the bwa program
	my $program = join(' ',
		$args{'bwa'},
		'mem'
		);

	# create a string for additional options as provided in the passed
	# arguments
	my $additional_options = '';
	if (@{$args{'options'}} != 0) {
		foreach my $option (@{$args{'options'}}) {
			$additional_options = join(' ',
				$additional_options,
				$option
				);
			}
		}

	# for now, we're using a subset of options, as time progresses we'll expand the
	# list to the full set of options
	my $options;
	if ($args{'readgroup'} ne '') {
		my $readgroup = join('',
			"\'",
			$args{'readgroup'},
			"\'"
			);
		$options = join(' ',
			'-t', $args{'threads'},
			'-R', $readgroup,
			$additional_options,
			$args{'reference'},
			$args{'fastq1'},
			$args{'fastq2'},
			'|',
			$args{'samtools'},
			'view -S -b -',
			'>',
			$output
			);
		}
	else {
		$options = join(' ',
			'-t', $args{'threads'},
			$additional_options,
			$args{'reference'},
			$args{'fastq1'},
			$args{'fastq2'},
			'|',
			$args{'samtools'},
			'view -S -b -',
			'>',
			$output
			);
		}

	# finally, construct the command that can be executed
	my $cmd = join(' ',
		$program,
		$options
		);

	# we will be returning a hash reference that contains the final output
	# file and the command to be executed, gives us flexibility for pipeline
	# development
	my %return_values = (
		cmd => $cmd,
		output => $output
		);

	return(\%return_values);
	}

=head2 $obj->create_read_group()

Construct the read group string that will be used in the BAM header.

=head3 Arguments:

=over 2

=item * id: (optional) unique id for the read group, will autogenerate a UUID if none provided

=item * sample: (required) name of the sample

=item * library: (required) name of the library

=item * center: (required) center where sample/library was sequenced

=item * platform: (default: ILLUMINA) sequencer technology used for sequence data

=item * platform_unit: (default: NONE) flowcell barcode

=back

=cut

sub create_read_group {
	my $self = shift;
	my %args = validated_hash(
		\@_,
		id => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		sample => {
			isa         => 'Str',
			required    => 1
			},
		library => {
			isa			=> 'Str',
			required	=> 1
			},
		center => {
			isa			=> 'Str',
			required	=> 1
			},
		platform => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'ILLUMINA'
			},
		platform_unit => {
			isa			=> 'Str',
			required	=> 0,
			default 	=> 'NONE'
			}

		);

	my $uuid_string;
	if ($args{'id'} eq '') {
		# create a UUID for the read group
		my $uuid_object = Data::UUID->new();
		my $uuid = $uuid_object->create();
		$uuid_string = $uuid_object->to_string($uuid);
		}
	else {
		$uuid_string = $args{'id'};
		}

	# construct the read group as reuqired
	my $read_group_string = join('\t',
		'@RG',
		'ID:' . $uuid_string,
		'SM:' . $args{'sample'},
		'LB:' . $args{'library'},
		'PL:' . $args{'platform'},
		'PU:' . $args{'platform_unit'},
		'CN:' . $args{'center'}
		);

	return($read_group_string);
	}

=head1 AUTHOR

Richard de Borja, C<< <richard.deborja at sickkids.ca> >>

=head1 ACKNOWLEDGEMENT

Dr. Adam Shlien, PI -- The Hospital for Sick Children

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-test at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=test-test>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NGS::Tools::BWA::Roles::Mem

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=test-test>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/test-test>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/test-test>

=item * Search CPAN

L<http://search.cpan.org/dist/test-test/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2014 Richard de Borja.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

no Moose::Role;

1; # End of NGS::Tools::BWA::Roles::Mem
