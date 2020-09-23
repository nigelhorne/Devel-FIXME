#!/usr/bin/perl

use strict;
use warnings;

use Module::Build;

Module::Build->new(
	dist_author         => 'Nigel Horne <njh@bandsman.co.uk>',
	dist_version_from   => 'lib/Devel/FIXME.pm',
	module_name => 'Devel::FIXME',
	license => 'perl',
	requires => {
		'perl'	=> '5.8.0',
	},
	build_requires => {
		'Test::Most' => 0,
		'Test::Warn' => '0.10',
		'Test::NoWarnings' => 0,
		'Text::Soundex' => 0, # used in testing
	},
	create_makefile_pl => 'traditional',
	# sign => 1,
	add_to_cleanup      => [ 'Devel-FIXME-*' ],
	meta_merge => {
		resources => {
			repository => 'http://github.com/nigelhorne/Devel-FIXME/tree/master',
		}
	},
)->create_build_script()
