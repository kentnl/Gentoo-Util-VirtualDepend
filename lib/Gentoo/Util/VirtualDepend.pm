use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Gentoo::Util::VirtualDepend;

our $VERSION = '0.001000';

# ABSTRACT: Hardcoded replacements for perl-core/ deps and deps with odd names in Gentoo

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moo;
use Path::Tiny qw( path );
use File::ShareDir qw( dist_file );

my %MOD2GENTOO;
my $MOD2GENTOO_LOADED;
my $MOD2GENTOO_FILE = 'module-to-gentoo.csv';

my %DIST2GENTOO;
my $DIST2GENTOO_LOADED;
my $DIST2GENTOO_FILE = 'dist-to-gentoo.csv';

my $DIST = q[Gentoo-Util-VirtualDepend];

sub _load_mod2gentoo {
  return if $MOD2GENTOO_LOADED;
  my $fh = path(dist_file($DIST, $MOD2GENTOO_FILE ))->openr_raw;
  while( my $line = <$fh> ) {
    chomp $line;
    my ( $module, $map ) = split /,/, $line;
    $MOD2GENTOO{ $module } = $map;
  }
  return $MOD2GENTOO_LOADED = 1;
}
sub _load_dist2gentoo {
  return if $DIST2GENTOO_LOADED;
  my $fh = path(dist_file($DIST, $DIST2GENTOO_FILE ))->openr_raw;
  while ( my $line = <$fh> ) {
    chomp $line;
    my ( $module, $map ) = split /,/, $line;
    $DIST2GENTOO{ $module } = $map;
  }
  return $DIST2GENTOO_LOADED = 1;
}


sub has_module_override {
  my ( undef, $module  ) = @_;
  _load_mod2gentoo unless $MOD2GENTOO_LOADED;
  return exists $MOD2GENTOO{$module};
}
sub get_module_override {
  my ( undef, $module  ) = @_;
  _load_mod2gentoo unless $MOD2GENTOO_LOADED;
  return $MOD2GENTOO{$module};
}
sub has_dist_override {
  my ( undef, $dist  ) = @_;
  _load_dist2gentoo unless $DIST2GENTOO_LOADED;
  return exists $DIST2GENTOO{$dist};
}
sub get_dist_override {
  my ( undef, $dist  ) = @_;
  _load_mod2gentoo unless $DIST2GENTOO_LOADED;
  return $DIST2GENTOO{$dist};
}
no Moo;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Gentoo::Util::VirtualDepend - Hardcoded replacements for perl-core/ deps and deps with odd names in Gentoo

=head1 VERSION

version 0.001000

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
