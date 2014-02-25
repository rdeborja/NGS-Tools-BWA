use Test::More tests => 2;
use Test::Exception;
use Test::Moose;
use MooseX::ClassCompositor;
use FindBin qw($Bin);
use lib "$Bin/../lib";

my $test_class_factory = MooseX::ClassCompositor->new(
    { class_basename => 'Test' }
    );
my $bwa_test_class = $test_class_factory->class_for('NGS::Tools::BWA');

my $fasta = "$Bin/example/fasta/test.fasta";
my $index = "$Bin/example/fasta/test.fasta";
my $fastq_dir = "$Bin/example/fastq";
my $fastq1 = join('/', $fastq_dir, 'file1.fastq');
my $fastq2 = join('/', $fastq_dir, 'file2.fastq');
my $bwa;
lives_ok
    {
        $bwa = $bwa_test_class->new()
        }
    'BWA class instantiated ok';

my $aln1_values = $bwa->aln(fastq => $fastq1, output => 'file1.sai', index => $index);
my $aln2_values = $bwa->aln(fastq => $fastq2, output => 'file2.sai', index => $index);
my $sampe_values = $bwa->sampe(
    fastq1 => $fastq1,
    fastq2 => $fastq2,
    aln1 => $aln1_values->{'output'},
    aln2 => $aln2_values->{'output'},
    output => 'output.sam',
    index => $index
    );

my $expected_sampe_cmd = "bwa sampe -f output.sam $Bin/example/fasta/test.fasta file1.sai file2.sai $Bin/example/fastq/file1.fastq $Bin/example/fastq/file2.fastq";
is($sampe_values->{'cmd'}, $expected_sampe_cmd, 'sampe command ok');
