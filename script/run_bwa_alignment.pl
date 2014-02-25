#!/usr/bin/perl

### run_bwa_alignment.pl ##########################################################################
# A wrapper script for the BWA alignment pipeline.

### HISTORY #######################################################################################
# Version       Date            Developer           Comments
# 0.01			2014-02-24		rdeborja			Initial development

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
	fastq1 => undef,
	fastq2 => undef,
	ref => undef,
	sample => undef,
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
        "fastq1=s",
        "fastq2=s",
        "ref|r=s",
        "sample|s=s"
        ) or pod2usage(64);
    
    pod2usage(1) if $opts{'help'};
    pod2usage(-exitstatus => 0, -verbose => 2) if $opts{'man'};

    while(my ($arg, $value) = each(%opts)) {
        if (!defined($value)) {
            print "ERROR: Missing argument \n";
            pod2usage(128);
            }
        }

    my $bwa = NGS::Tools::BWA->new(
    	fastq1 => $opts{'fastq1'},
    	fastq2 => $opts{'fastq2'},
    	index => $opts{'ref'},

    	);


    return 0;
    }


__END__


=head1 NAME

run_bwa_alignment.pl

=head1 SYNOPSIS

B<run_bwa_alignment.pl> [options] [file ...]

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

B<run_bwa_alignment.pl> A wrapper script for the BWA alignment pipeline.

=head1 EXAMPLE

run_bwa_alignment.pl

=head1 AUTHOR

Richard de Borja -- Shlien Lab

The Hospital for Sick Children

=head1 SEE ALSO

=cut

