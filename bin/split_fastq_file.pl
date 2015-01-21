#!/usr/bin/env perl

### split_fastq_file.pl ##############################################################################
# Split a FASTQ file into multiple FASTQ files for parallelization.

### HISTORY #######################################################################################
# Version       Date            Developer           Comments
# 0.01          2014-06-27		rdeborja            initial development

### INCLUDES ######################################################################################
use warnings;
use strict;
use Carp;
use Getopt::Long;
use Pod::Usage;
use NGS::Tools::BWA;

### COMMAND LINE DEFAULT ARGUMENTS ################################################################
# list of arguments and default values go here as hash key/value pairs
our %opts = (
	fastq => undef,

    );

### MAIN CALLER ###################################################################################
my $result = main();
exit($result);

### FUNCTIONS #####################################################################################

### main ##########################################################################################
# Description:
#   Main subroutine for program
# Input Variables:
#   %opts = command line arguments
# Output Variables:
#   N/A

sub main {
    # get the command line arguments
    GetOptions(
        \%opts,
        "help|?",
        "man",
        "fastq|f=s",

        ) or pod2usage(64);
    
    pod2usage(1) if $opts{'help'};
    pod2usage(-exitstatus => 0, -verbose => 2) if $opts{'man'};

    while(my ($arg, $value) = each(%opts)) {
        if (!defined($value)) {
            print "ERROR: Missing argument $arg\n";
            pod2usage(128);
            }
        }

    return 0;
    }


__END__


=head1 NAME

split_fastq_file.pl

=head1 SYNOPSIS

B<split_fastq_file.pl> [options] [file ...]

    Options:
    --help          brief help message
    --man           full documentation

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exit.

=item B<--man>

Print the manual page.

=back

=head1 DESCRIPTION

B<split_fastq_file.pl> Split a FASTQ file into multiple FASTQ files for parallelization.

=head1 EXAMPLE

split_fastq_file.pl

=head1 AUTHOR

Richard de Borja -- Molecular Genetics

The Hospital for Sick Children

=head1 SEE ALSO

=cut

