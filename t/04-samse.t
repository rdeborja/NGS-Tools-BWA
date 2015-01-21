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
my $test_class = $test_class_factory->class_for('NGS::Tools::BWA::Roles::Align');

# a couple of input variables
my $fastq = 'input.fastq';
my $index = 'test.fa';

# instantiate the test class based on the given role
my $bwa;
lives_ok
	{
		$bwa = $test_class->new();
		}
'Class instantiated';

my $bwa_aln = $bwa->aln(
	fastq => $fastq,
	index => $index
	);
my $bwa_samse = $bwa->samse(
	fastq => $fastq,
	aln => $bwa_aln->{'output'},
	index => $index
	);

my $expected_cmd = join(' ',
	'bwa samse',
	'-f input.sam',
	'test.fa',
	'input.sai',
	'input.fastq'
	);

is($bwa_samse->{'cmd'}, $expected_cmd, 'BWA samse command matches expected');

SKIP: {

	}
