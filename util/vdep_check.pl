#!/usr/bin/env perl
# FILENAME: vdep_check.pl
# CREATED: 06/02/15 12:43:42 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Show result of CPAN version deltas in terms of virtuals.

use 5.020;
use warnings;

use Capture::Tiny qw(capture_stdout);
use Data::Dump qw( pp );
use Gentoo::Util::VirtualDepend;
use List::UtilsBy qw( uniq_by );
use Gentoo::PerlMod::Version qw( gentooize_version );
my $v = Gentoo::Util::VirtualDepend->new();

my ( $lines, ) = capture_stdout {
  system( 'corelist', '--diff', '5.20.2', '5.22.0' );
};

my $table = {};

for my $line ( split /\n/, $lines ) {
  my ( $module, $old, $new ) = $line =~ /\A(\S+)\s+(\S+)\s+(\S+)\s*\z/;

  # these versions for the sake of upgrade testing don't exist
  next if $old eq '(absent)' and $new eq '(undef)';

  my $type;
  if ( $new eq '(absent)' ) {
    $type = 'REMOVE';
  }
  elsif ( $old eq '(absent)' ) {
    $type = "ADD";
  }
  else {
    $type = "UPGRADE";
  }
  my $override = "untracked";
  if ( $v->has_module_override($module) ) {
    $override = $v->get_module_override($module);
  }
  $type = simplify( [ $type, $old, $new ] ) if $override eq 'untracked';
  $table->{$override} //= {};
  $table->{$override}->{$module} = [ $type, $old, $new ];
}

for my $key ( keys %$table ) {
  next if $key eq 'untracked';
  my $entries = $table->{$key};
  my (@ev) = values %{$entries};
  my (@types) = uniq_by { $_->[0] } @ev;

  if ( 1 == @types && $types[0]->[0] eq 'REMOVE' ) {
    $table->{$key} = ['REMOVE'];
    next;
  }
  my (@vnew) = uniq_by { $_->[2] } @ev;
  my (@vold) = uniq_by { $_->[1] } @ev;

  if ( 1 == @vnew and 1 == @vold ) {
    $table->{$key} = [ "UPGRADE", $vold[0]->[1], $vnew[0]->[2] ];
    next;
  }
  elsif ( 1 == @vnew ) {
    $table->{$key} = [ "UPGRADE", "mixed", $vnew[0]->[2] ];
    next;
  }
}

for my $key ( sort keys %$table ) {
  next if $key eq 'untracked';
  if ( ref $table->{$key} eq 'ARRAY' ) {
    if ( $table->{$key}->[0] eq 'REMOVE' ) {
      printf "%-40sremoved from perl\n", $key;
      next;
    }
    if ( $table->{$key}->[0] eq 'ADD' ) {
      my $v = gentooize_version( $table->{$key}->[1], { lax => 1 } );
      printf "%-40s+%-30s\t\t[=%s, new distribution+virtual in perl]\n", $key, $v, $table->{$key}->[1];
    }
    if ( $table->{$key}->[0] eq 'UPGRADE' ) {
      my $v = gentooize_version( $table->{$key}->[2], { lax => 1 } );
      printf "%-40s+%-30s\t\t[=%s, was %s]\n", $key, $v, $table->{$key}->[2], $table->{$key}->[1];
      next;
    }
    if ( $table->{$key}->[0] eq 'NOCHANGE' ) {
      printf "%-40sno change between perls\n", $key;
      next;
    }
  }
  printf "%s:\n---\t\t%s\n", $key, pp $table->{$key};
}

sub simplify {
  my ($node) = @_;
  return $node->[0] if $node->[0] eq 'REMOVE';
  return sprintf '%s: %3$s',         @{$node} if $node->[0] eq 'ADD';
  return sprintf '%s: %2$s => %3$s', @{$node} if $node->[0] eq 'UPGRADE';
  die "What is $node?";
}
