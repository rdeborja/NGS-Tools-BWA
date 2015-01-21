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
my $test_class = $test_class_factory->class_for('NGS::Tools::BWA::Roles::SplitFastq');

# instantiate the test class based on the given role
my $fastq;
my $fastq_file = 'test.fastq.gz';
lives_ok
	{
		$fastq = $test_class->new(
			fastq => $fastq_file
			);
		}
	'Class instantiated';
my $split_output = $fastq->split_fastq();

my $expected_cmd = join(' ',
	'split',
	'-l 10000000',
	'-d test.fastq.gz',
	'test.fastq.gz.',
	);
is($split_output->{'cmd'}, $expected_cmd, 'split command matches expected');