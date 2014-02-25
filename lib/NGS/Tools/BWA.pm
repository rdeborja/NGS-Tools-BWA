package NGS::Tools::BWA;
use Moose::Role;
use MooseX::Params::Validate;

use namespace::autoclean;
use autodie;
use Carp;
use File::Basename;

=head1 NAME

NGS::Tools::BWA - Perl wrapper for the BWA alignment tool.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

A Moose Role containing methods that perform BWA alignment.  This can be used
by any Moose class to simplify its construction.

    package <package::name>
    use Moose;
    with 'NGS::Tools::BWA';

=head1 VARIABLES

=head1 SUBROUTINES/METHODS

=head2 $obj->sampe()

Performed a paired-end analysis and output data as a SAM file.

=head3 Arguments:

=over 2

=item * fastq1: FASTQ file for read 1

=item * fastq2: FASTQ file for read 2

=item * aln1: Alignment file from bwa aln for read 1

=item * aln1: Alignment file from bwa aln for read 2

=item * index: index prefix

=item * output: output filename used to write output data to

=back

=head3 Return:

=over 2

=item * $return_values->{'cmd'}: command to be executed

=item * $return_values->{'output'}: output SAM file containing processed data

=back

=cut

sub sampe {
    my $self = shift;
    my %args = validated_hash(
        \@_,
        fastq1 => {
            isa         => 'Str',
            required    => 1
            },
        fastq2 => {
            isa         => 'Str',
            required    => 1
            },
        aln1 => {
            isa         => 'Str',
            required    => 1
            },
        aln2 => {
            isa         => 'Str',
            required    => 1
            },
        index => {
            isa         => 'Str',
            required    => 1,
            },
        output => {
            isa         => 'Str',
            required    => 0,
            default     => ''
            },
        bwa => {
            isa         => 'Str',
            required    => 0,
            default     => 'bwa'
            }
        );

    my $output; 
    if ('' eq $args{'output'}) {
        $output = join('.',
            basename($args{'fastq1'}, qw(.fastq .fq .fastq.gz .fq.gz)),
            'sam'
            );
        }
    else {
        $output = $args{'output'};
        }

    my $program = join(' ',
        $args{'bwa'},
        'sampe'
        );

    my $options = join(' ',
        '-f', $output,
        $args{'index'},
        $args{'aln1'},
        $args{'aln2'},
        $args{'fastq1'},
        $args{'fastq2'}
        );

    my $cmd = join(' ',
        $program,
        $options
        );

    my %return_values = (
        cmd => $cmd,
        output => $output
        );

    return(\%return_values);
    }

=head2 $obj->aln()

Align the FASTQ file using the BWA index.

=head3 Arguments:

=over 2

=item * fastq: FASTQ file to align to reference genome

=item * index: Reference genome index.

=back

=head3 Return:

=over 2

=item * $return_values->{'cmd'}: command to be executed

=item * $return_values->{'output'}: name of output from bwa aln command

=back

=cut

sub aln {
    my $self = shift;
    my %args = validated_hash(
        \@_,
        fastq => {
            isa => 'Str',
            required => 1
            },
        index => {
            isa => 'Str',
            required => 1
            },
        threads => {
            isa => 'Int',
            required => 0,
            default => 4
            },
        output => {
            isa => 'Str',
            required => 0,
            default => ''
            },
        bwa => {
            isa => 'Str',
            required => 0,
            default => 'bwa'
            }
        );

    # if output file is not defined, create a default output filename based on the
    # FASTQ input files.
    my $output;
    if ('' eq $args{'output'}) {
        $output = join('',
            basename($args{'fastq'}, qw(.fastq.gz .fastq .fq)),
            '.sai'
            );
        }
    else {
        $output = $args{'output'};
        }

    my $program = join(' ',
        $args{'bwa'},
        'aln'
        );

    my $options = join(' ',
        '-t', $args{'threads'},
        '-f', $output,
        $args{'index'},
        $args{'fastq'}
        );

    my $cmd = join(' ',
        $program,
        $options
        );

    my %return_values = (
        cmd     => $cmd,
        output  => $output
        );

    return(\%return_values);
    }

=head2 $obj->index_ref()

Create a reference index from a FASTA file.

=head3 Arguments:

=over 2

=item * ref: FASTA reference file to be processed

=itme # type: index type (default: 'bwtsw')

=back

=head3 Return:

=over 2

=item * $return_values->{'cmd'}: command to be executed

=item * $return_values->{'output'}: Index file prefix used in subsequent BWA commands

=back

=cut

sub index_ref {
    my $self = shift;
    my %args = validated_hash(
        \@_,
        ref => {
            isa => 'Str',
            required => 1
            },
        type => {
            isa => 'Str',
            required => 0,
            default => 'bwtsw'
            },
        bwa => {
            isa => 'Str',
            required => 0,
            default => 'bwa'
            }
        );

    unless(-e $args{'ref'}) {
        Carp::croak("FASTA file $args{'ref'} does not exist, exiting...")
        }

    my $program = join(' ',
        $args{'bwa'},
        'index'
        );

    my $options = join(' ',
        '-a', $args{'type'},
        $args{'ref'}
        );

    my $cmd = join(' ',
        $program,
        $options
        );

    my %return_values = (
        cmd     => $cmd,
        output  => $args{'ref'}
        );

    return(\%return_values);
    }  

=head1 AUTHOR

Richard de Borja, C<< <richard.deborja at oicr.on.ca> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ngs-tools-bwa at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=NGS-Tools-BWA>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NGS::Tools::BWA


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=NGS-Tools-BWA>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/NGS-Tools-BWA>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/NGS-Tools-BWA>

=item * Search CPAN

L<http://search.cpan.org/dist/NGS-Tools-BWA/>

=back


=head1 ACKNOWLEDGEMENTS

Dr. Adam Shlien, PI -- The Hospital for Sick Children

Dr. Roland Arnold -- The Hospital for Sick Children

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Richard de Borja.

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

1; # End of NGS::Tools::BWA

no Moose::Role;
