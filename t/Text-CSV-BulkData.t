use strict;
#use Test::More qw(no_plan);
use Test::More tests=>29;

BEGIN { use_ok('Text::CSV::BulkData') };

my $output_filename = 'example.dat';
my $format = "0907000%04d,JPN,160-%04d,type000%04d,0120444%04d,20080418100000\n";
my $gen = Text::CSV::BulkData->new($output_filename, $format);

my $res;
my $pattern_1 = [undef,'*2','-2','*2+1'];
ok ref $pattern_1 eq 'ARRAY', 'pattern_1 data';

$gen->_set_debug;

ok $res = $gen->initialize, '$obj->initialize';
is $res, $gen, 'returns $self';

ok $res = $gen->set_pattern($pattern_1), '$obj->set_pattern($array_ref)';
is $res, $gen, 'returns $self';

ok $res = $gen->set_start(1), '$obj->set_start($int)';
is $res, $gen, 'returns $self';
is $gen->{start}, 1, 'set_start';

ok $res = $gen->set_end(3), '$obj->set_end($int)';
is $res, $gen, 'returns $self';
is $gen->{end}, 3, 'set_end';

ok $res = $gen->make, '$obj->make';
is $$res[0], "09070000001,JPN,160-0002,type0000000,01204440003,20080418100000\n", 'calc result';
is $$res[1], "09070000002,JPN,160-0004,type0000000,01204440005,20080418100000\n", 'calc result';
is $$res[2], "09070000003,JPN,160-0006,type0000001,01204440007,20080418100000\n", 'calc result';

my $pattern_2 = [undef,'/10','*3/2','%2']; 
ok ref $pattern_2 eq 'ARRAY', 'pattern_2 data';

ok $res = $gen->set_pattern($pattern_2), '$obj->set_pattern($array_ref)';
is $res, $gen, 'returns $self';

ok $res = $gen->set_start(8), '$obj->set_start($int)';
is $res, $gen, 'returns $self';
is $gen->{start}, 8, 'set_start';

ok $res = $gen->set_end(10), '$obj->set_end($int)';
is $res, $gen, 'returns $self';
is $gen->{end}, 10, 'set_end';

ok $res = $gen->make, '$obj->make';
is $$res[0], "09070000008,JPN,160-0000,type0000012,01204440000,20080418100000\n", 'calc result';
is $$res[1], "09070000009,JPN,160-0000,type0000013,01204440001,20080418100000\n", 'calc result';
is $$res[2], "09070000010,JPN,160-0001,type0000015,01204440000,20080418100000\n", 'calc result';

__END__
