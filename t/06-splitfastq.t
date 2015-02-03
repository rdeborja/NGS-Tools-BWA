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
my $fastq_file = "$Bin/example/fastq/read1.fastq.gz";
lives_ok
	{
		$fastq = $test_class->new();
		}
	'Class instantiated';
my $split_output = $fastq->split_fastq(
	fastq => $fastq_file,
	number_of_reads => 4000,
	is_gzipped => 'true'
	);

my $expected_cmd = join(' ',
	'zcat',
	"$Bin/example/fastq/read1.fastq.gz",
	'|',
	'split',
	'-l 4000',
	"-d",
	"-",
	'read1.fastq.',
	);
is($split_output->{'cmd'}, $expected_cmd, 'split command matches expected');
