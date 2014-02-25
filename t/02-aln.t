use Test::More tests => 3;
use Test::Exception;
use Test::Moose;
use MooseX::ClassCompositor;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Data::Dumper;
use Env qw(TMPDIR);

my $test_class_factory = MooseX::ClassCompositor->new(
	{ class_basename => 'Test' }
	);
my $bwa_test_class = $test_class_factory->class_for('NGS::Tools::BWA');

my $fasta = "$Bin/example/fasta/test.fasta";
my $index = "$Bin/example/fasta/test.fasta";
my $fastq_dir = "$Bin/example/fastq";
my $fastq1 = join('/', $fastq_dir, 'file1.fastq');
my $fastq2 = join('/', $fastq_dir, 'file2.fastq');

lives_ok
	{
		$bwa = $bwa_test_class->new()
		}
	'BWA class instantiated ok';

#my $aln1_values = $bwa->aln(fastq => $fastq1, output => join('/', $TMPDIR, 'output.sai'));
my $aln1_values = $bwa->aln(fastq => $fastq1, output => 'file1.sai', index => $index);
my $expected_aln1_command = "bwa aln -t 4 -f file1.sai $Bin/example/fasta/test.fasta $Bin/example/fastq/file1.fastq";
is($aln1_values->{'cmd'}, $expected_aln1_command, 'aln command ok');
my $aln2_values = $bwa->aln(fastq => $fastq2, output => 'file2.sai', index => $index);
my $expected_aln2_command = "bwa aln -t 4 -f file2.sai $Bin/example/fasta/test.fasta $Bin/example/fastq/file2.fastq";
is($aln2_values->{'cmd'}, $expected_aln2_command, 'aln command ok');
