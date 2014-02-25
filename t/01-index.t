use Test::More tests => 2;
use Test::Exception;
use Test::Moose;
use MooseX::ClassCompositor;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Data::Dumper;

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
	'BWA class instantiated';

my $index_values = $bwa->index_ref(ref => $fasta);
my $expected_index_command = "bwa index -a bwtsw $Bin/example/fasta/test.fasta";
is($index_values->{'cmd'}, $expected_index_command, 'index command ok');
