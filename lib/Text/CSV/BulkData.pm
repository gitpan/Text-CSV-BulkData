package Text::CSV::BulkData;

use strict;
use warnings;

our $VERSION = '0.01';

sub new { 
    my ($class, $output_file, $format) = @_;
    bless { 
        output_file => $output_file,
        format => $format,
    }, $class;
} 

sub set_format {
    my ($self, $format) = @_;
    $self->{format} = $format;
    return $self;
}

sub set_pattern {
    my $self = shift;
    $self->{pattern} = shift;
    return $self;
}

sub set_start {
    my ($self, $start) = @_;
    $self->{start} = $start;
    return $self;
}

sub set_end {
    my ($self, $end) = @_;
    $self->{end} = $end;
    return $self;
}

sub initialize {
    my $self = shift;
    my $output_file = $self->{output_file};
    unlink $output_file or die $! if -f $output_file;
    return $self;
}

sub make {
    my $self = shift;
    my ($output_file, $start, $end, $format, $pattern ) = 
        ( $self->{output_file}, $self->{start}, $self->{end}, $self->{format}, $self->{pattern} );
    open FH, ">> $output_file" or die $!;
    for (my $i = $start; $i <= $end; $i++){
        my @input = ();
        for (my $j = 0; $j < ($format =~ s/%/%/g); $j++) {
            my $pattern = $$pattern[$j];
            if ( ! defined $pattern ) { 
                push @input, $i;
                next;
            }
            push @input, $self->_calculate($pattern, $i);
        }
        printf FH $format, @input;
    }
    close FH;
    return $self;
}

sub _calculate {
    my ($self, $pattern, $i) = @_;
    if ( $pattern =~ m{\*(\d+)} ) {
        my $res = $i*$1;
        $pattern =~ s{(\*\d+?\w)|(\*\d+$)}{$res};
        $self->_calculate($pattern, $i);
    } elsif ( $pattern =~ m{/(\d+)} ) {
        my $res = $i/$1;
        $pattern =~ s{(/\d+?\w)|(/\d+$)}{$res};
        $self->_calculate($pattern, $i);
    } elsif ( $pattern =~ m{%(\d+)} ) {
        my $res = $i%$1;
        $pattern =~ s{(%\d+?\w)|(%\d+$)}{$res};
        $self->_calculate($pattern, $i);
    } elsif ( $pattern =~ m{\+(\d+)} ) {
        my $res = $i+$1;
        $pattern =~ s{(\+\d+?\w)|(\+\d+$)}{$res};
        $self->_calculate($pattern, $i);
    } elsif ( $pattern =~ m{-(\d+)} ) {
        my $res = $i-$1;
        $pattern =~ s{(-\d+?\w)|(-\d+$)}{$res};
        $self->_calculate($pattern, $i);
    } else {
        return $pattern;
    }
}

1;
__END__

=head1 NAME

Text::CSV::BulkData - generate csv file with bulk data

=head1 SYNOPSIS

  use Text::CSV::BulkData;

  my $output_file = "/your/dir/example.dat";
  my $format = "0907000%04d,JPN,160-%04d,type000%04d,0120444%04d,20080418100000\n";

  my $gen = Text::CSV::BulkData->new($output_file, $format);

  my $pattern_1 = [undef,'*2','+2',undef];
  $gen->initialize
      ->set_pattern($pattern_1)
      ->set_start(1)
      ->set_end(5)
      ->make;
  my $pattern_2 = [undef,'/10','-2','%2'];
  $gen->set_pattern($pattern_2)
      ->set_start(6)
      ->set_end(10)
      ->make;

This sample generates following csv file.

  09070000001,JPN,160-0002,type0000003,01204440001,20080418100000
  09070000002,JPN,160-0004,type0000004,01204440002,20080418100000
  09070000003,JPN,160-0006,type0000005,01204440003,20080418100000
  09070000004,JPN,160-0008,type0000006,01204440004,20080418100000
  09070000005,JPN,160-0010,type0000007,01204440005,20080418100000
  09070000006,JPN,160-0000,type0000004,01204440000,20080418100000
  09070000007,JPN,160-0000,type0000005,01204440001,20080418100000
  09070000008,JPN,160-0000,type0000006,01204440000,20080418100000
  09070000009,JPN,160-0000,type0000007,01204440001,20080418100000
  09070000010,JPN,160-0001,type0000008,01204440000,20080418100000
  
=head1 DESCRIPTION

Text::CSV::BulkData is a Perl module which generates csv files with bulk data.
You can modify incremented values with using 4 arithmetic operations and residue.

=head1 SEE ALSO

None

=head1 AUTHOR

Kazuhiro Sera, E<lt>webmaster@seratch.ath.cx<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Kazuhiro Sera

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
