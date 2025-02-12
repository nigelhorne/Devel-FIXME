#!/usr/bin/perl

use strict;
use warnings;
use Test::Most;
use Devel::FIXME qw(FIXME);

# Test object creation
subtest 'Object creation' => sub {
	my $fixme = Devel::FIXME->new(text => 'This needs fixing', file => 'test.pl', line => 42);
	isa_ok($fixme, 'Devel::FIXME', 'FIXME object created successfully');
	is($fixme->{'text'}, 'This needs fixing', 'Text stored correctly');
	is($fixme->{'file'}, 'test.pl', 'File stored correctly');
	is($fixme->{'line'}, 42, 'Line number stored correctly');
};

# Test regex matching for FIXME comments
subtest 'Regex matching' => sub {
	my $regex = Devel::FIXME->regex();
	my $sample_comment = '# FIXME: This is a problem';
	like($sample_comment, $regex, 'Regex correctly matches FIXME comment');

	my $non_fixme_comment = '# This is a normal comment';
	unlike($non_fixme_comment, $regex, 'Regex correctly ignores non-FIXME comment');
};

# Test the FIXME function behaviour
subtest 'FIXME function' => sub {
	my $warning;
	{
		local $SIG{__WARN__} = sub { $warning = shift };
		FIXME('This is a test FIXME');
	}
	like($warning, qr/FIXME: This is a test FIXME/, 'FIXME function emits correct warning');
};

done_testing();
