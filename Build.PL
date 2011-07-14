
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'File::Find' => '0',
    'File::Temp' => '0',
    'Module::Build' => '0.3601',
    'Test::MockObject' => '1.09',
    'Test::MockObject::Extends' => '1.09',
    'Test::More' => '0.96'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Provide version using git-describe',
  'dist_author' => [
    'Randy Stauner <rwstauner@cpan.org>'
  ],
  'dist_name' => 'Dist-Zilla-Plugin-Git-DescribeVersion',
  'dist_version' => '1.003',
  'license' => 'perl',
  'module_name' => 'Dist::Zilla::Plugin::Git::DescribeVersion',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Dist::Zilla' => '4',
    'Dist::Zilla::Role::VersionProvider' => '0',
    'Git::DescribeVersion' => '0',
    'Moose' => '0',
    'perl' => '5.006'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
