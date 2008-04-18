use strict;
use Test::More qw(no_plan);

BEGIN { use_ok('Text::CSV::BulkData') };

my $output_filename = 'example.dat';
my $format = "0907000%04d,JPN,160-%04d,type000%04d,0120444%04d,20080418100000\n";
my $gen = Text::CSV::BulkData->new($output_filename, $format);

my $res;
my $pattern_1 = [undef,'*2','+2',undef];
ok ref $pattern_1 eq 'ARRAY', 'pattern_1 data';
ok $res = $gen->initialize, '$obj->initialize';
is $res, $gen, 'returns $self';
ok $res = $gen->set_pattern($pattern_1), '$obj->set_pattern($array_ref)';
is $res, $gen, 'returns $self';
ok $res = $gen->set_start(1), '$obj->set_start($int)';
is $res, $gen, 'returns $self';
is $gen->{start}, 1, 'set_start';
ok $res = $gen->set_end(5), '$obj->set_end($int)';
is $res, $gen, 'returns $self';
is $gen->{end}, 5, 'set_end';

my $pattern_2 = [undef,'/10','-2','%2']; 
ok $res = $gen->set_pattern($pattern_2), '$obj->set_pattern($array_ref)';
is $res, $gen, 'returns $self';
ok $res = $gen->set_start(6), '$obj->set_start($int)';
is $res, $gen, 'returns $self';
is $gen->{start}, 6, 'set_start';
ok $res = $gen->set_end(10), '$obj->set_end($int)';
is $res, $gen, 'returns $self';
is $gen->{end}, 10, 'set_end';

__END__
