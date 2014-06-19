use Test::More tests => 2;
use Test::Moose;
use Test::Exception;
use MooseX::ClassCompositor;
use Test::Files;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use File::Temp qw(tempfile tempdir);
use Data::Dumper;

# setup the class creation process
my $test_class_factory = MooseX::ClassCompositor->new(
	{ class_basename => 'Test' }
	);

# create a temporary class based on the given Moose::Role package
my $test_class = $test_class_factory->class_for('NGS::Tools::BWA::Roles::Mem');

# setup a few variables
my $fasta = "$Bin/example/fasta/test.fasta";
my $index = "$Bin/example/fasta/test.fasta";
my $fastq_dir = "$Bin/example/fastq";
my $fastq1 = join('/', $fastq_dir, 'file1.fastq');
my $fastq2 = join('/', $fastq_dir, 'file2.fastq');

# instantiate the test class based on the given role
my $bwa;
lives_ok
	{
		$bwa = $test_class->new();
		}
	'Class instantiated';


my @additional_options = ();
my $bwa_run = $bwa->mem(
	fastq1 => $fastq1,
	fastq2 => $fastq2,
	reference => $index,
	options => \@additional_options
	);

my $expected_command = join(' ',
	'bwa mem -t 2 ',
	"$Bin/example/fasta/test.fasta",
	"$Bin/example/fastq/file1.fastq",
	"$Bin/example/fastq/file2.fastq",
	'> file1.sam'
	);
is($bwa_run->{'cmd'}, $expected_command, 'command matches expected');
