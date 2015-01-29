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

# instantiate the test class based on the given role
my $bwa;
lives_ok
    {
        $bwa = $test_class->new();
        }
    'Class instantiated';

my $bwa_read_group = $bwa->create_read_group(
    id => 'testid',
    sample => 'testsample',
    library => 'testlibrary',
    center => 'DPLM'
    );
my $expected_bwa_read_group = '@RG\tID:testid\tSM:testsample\tLB:testlibrary\tPL:ILLUMINA\tPU:NONE\tCN:DPLM';
is($bwa_read_group, $expected_bwa_read_group, 'Command matches expected');