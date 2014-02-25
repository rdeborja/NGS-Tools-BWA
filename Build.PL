use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'NGS::Tools::BWA',
    license             => 'perl',
    dist_author         => q{Richard de Borja <richard.deborja@oicr.on.ca>},
    dist_version_from   => 'lib/NGS/Tools/BWA.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
        },
    build_requires => {
        'Test::More' => 0,
        },
    requires => {
        'Carp'                      => 0,
        'File::Basename'            => 0,
        'Moose::Role'               => 0,
        'autodie'                   => 0,
        'namespace::autoclean'      => 0,
        'MooseX::Params::Validate'  => 0
        },
    add_to_cleanup     => [ 'NGS-Tools-BWA-*' ],
    create_makefile_pl => 'traditional',
    );

$builder->create_build_script();
