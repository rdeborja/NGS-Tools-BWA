#!/usr/bin/env perl

### run_bwa_mem.pl ################################################################################
# Run the BWA Mem pipeline.

### HISTORY #######################################################################################
# Version       Date            Developer           Comments
# 0.01          2015-01-27      rdeborja            initial development
# 0.02          2015-02-03      rdeborja            added qsub submission to main program, fixed
#                                                   read group issue

### INCLUDES ######################################################################################
use warnings;
use strict;
use Carp;
use Getopt::Long;
use Pod::Usage;
use NGS::Tools::BWA;
use IPC::Run3;
use Data::Dumper;
use HPF::PBS;
use File::ShareDir ':ALL';
use IPC::Run3;

### COMMAND LINE DEFAULT ARGUMENTS ################################################################
# list of arguments and default values go here as hash key/value pairs
our %opts = (
    sample => undef,
    library => undef,
    center => 'ca.sickkids.dplm',
    fastq1 => undef,
    fastq2 => undef,
    reference => undef,
    options => ''
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
        "sample|s=s",
        "library|l=s",
        "center|c:s",
        "fastq1=s",
        "fastq2=s",
        "reference|r=s",
        "options|o:s"
        ) or pod2usage(64);
    
    pod2usage(1) if $opts{'help'};
    pod2usage(-exitstatus => 0, -verbose => 2) if $opts{'man'};

    while(my ($arg, $value) = each(%opts)) {
        if (!defined($value)) {
            print "ERROR: Missing argument $arg\n";
            pod2usage(128);
            }
        }

    my $bwa = NGS::Tools::BWA->new();
    my $readgroup = $bwa->create_read_group(
        sample => $opts{'sample'},
        library => $opts{'library'},
        center => $opts{'center'}
        );
    my $bwa_mem_run;
    if ($opts{'options'} eq '') {
        $bwa_mem_run = $bwa->mem(
            fastq1 => $opts{'fastq1'},
            fastq2 => $opts{'fastq2'},
            reference => $opts{'reference'},
            readgroup => $readgroup
            );
        }
    else {
        $bwa_mem_run = $bwa->mem(
            fastq1 => $opts{'fastq1'},
            fastq2 => $opts{'fastq2'},
            reference => $opts{'reference'},
            readgroup => $readgroup,
            options => $opts{'options'}
            );
        }
    my $template_dir = join('/', dist_dir('HPF'), 'templates');
    my $template = 'submit_to_pbs.template';
    my @modules_to_load = ("bwa", "samtools");
    my $pbs = HPF::PBS->new();
    my $bwa_pbs = $pbs->create_cluster_shell_script(
        jobname => join('_', $opts{'sample'}, "bwa", "mem"),
        command => $bwa_mem_run->{'cmd'},
        memory => 32,
        template_dir => $template_dir,
        template => $template,
        modules_to_load => \@modules_to_load,
        walltime => '240:00:00',
        submit => 'true'
        );
    $pbs->submit_job(
        script => $bwa_pbs->{'output'}
        );

    return 0;
    }


__END__


=head1 NAME

run_bwa_mem.pl

=head1 SYNOPSIS

B<run_bwa_mem.pl> [options] [file ...]

    Options:
    --help          brief help message
    --man           full documentation
    --sample        name of sample
    --library       name of library
    --center        name of sequencing center (default: ca.sickkids.dplm)
    --fastq1        FASTQ file for read 1
    --fastq2        FASTQ file for read 2
    --reference     reference genome for alignnment in FASTA format
    --options       list of options to pass to bwa mem

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exit.

=item B<--man>

Print the manual page.

=item B<--sample>

Name of sample to process using BWA.  This will be used in the BAM read group.

=item B<--library>

Name of library to prcoes using BWA.  This will be used in the BAM read group.

=item B<--center>

Name of sequencing center who generated the data (default: ca.sickkids.dplm)

=item B<--fastq1>

FASTQ file for read 1.

=item B<--fastq2>

FASTQ file for read 2.

=item <--reference>

Reference genome in FASTA format.

=item B<--options>



=back

=head1 DESCRIPTION

B<run_bwa_mem.pl> Run the BWA Mem pipeline.

=head1 EXAMPLE

run_bwa_mem.pl

=head1 AUTHOR

Richard de Borja <richard.deborja@sickkids.ca> -- The Hospital for Sick Children

=head1 ACKNOWLEDGEMENTS

Dr. Adam Shlien -- The Hospital for Sick Children

=cut

