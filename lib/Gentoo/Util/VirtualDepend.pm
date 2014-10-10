use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Gentoo::Util::VirtualDepend;

our $VERSION = '0.001000';

# ABSTRACT: Hard-coded replacements for perl-core/ dependencies and dependencies with odd names in Gentoo

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
  my $fh = path( dist_file( $DIST, $MOD2GENTOO_FILE ) )->openr_raw;
  while ( my $line = <$fh> ) {
    chomp $line;
    my ( $module, $map ) = split /,/, $line;    ## no critic (RegularExpressions)
    $MOD2GENTOO{$module} = $map;
  }
  return $MOD2GENTOO_LOADED = 1;
}

sub _load_dist2gentoo {
  return if $DIST2GENTOO_LOADED;
  my $fh = path( dist_file( $DIST, $DIST2GENTOO_FILE ) )->openr_raw;
  while ( my $line = <$fh> ) {
    chomp $line;
    my ( $module, $map ) = split /,/, $line;    ## no critic (RegularExpressions)
    $DIST2GENTOO{$module} = $map;
  }
  return $DIST2GENTOO_LOADED = 1;
}

sub has_module_override {
  my ( undef, $module ) = @_;
  _load_mod2gentoo unless $MOD2GENTOO_LOADED;
  return exists $MOD2GENTOO{$module};
}

sub get_module_override {
  my ( undef, $module ) = @_;
  _load_mod2gentoo unless $MOD2GENTOO_LOADED;
  return $MOD2GENTOO{$module};
}

sub has_dist_override {
  my ( undef, $dist ) = @_;
  _load_dist2gentoo unless $DIST2GENTOO_LOADED;
  return exists $DIST2GENTOO{$dist};
}

sub get_dist_override {
  my ( undef, $dist ) = @_;
  _load_mod2gentoo unless $DIST2GENTOO_LOADED;
  return $DIST2GENTOO{$dist};
}
no Moo;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Gentoo::Util::VirtualDepend - Hard-coded replacements for perl-core/ dependencies and dependencies with odd names in Gentoo

=head1 VERSION

version 0.001000

=head1 SYNOPSIS

  use Gentoo::Util::VirtualDepend;

  my $v = Gentoo::Util::VirtualDepend->new();

  # somewhere in complex dependency resolution

  my $cpan_module = spooky_function();
  my $gentoo_dependency;

  if ( $v->has_module_override( $cpan_module ) ) {
    $gentoo_dependency = $v->get_module_override( $cpan_module );
  } else {
    # do it the hard way.
  }

If you're trying to be defensive and you're going to map the modules to distributions
the hard way ( trust me, the code is really ugly ), then you may instead want

  if ( $v->has_dist_override( $cpan_dist ) ) {
    $gentoo_dependency = $v->get_dist_override( $cpan_dist );
  } else {
    # fallback to using dev-perl/Foo-Bar
  }

Which basically serves as a distribution name translator.

=head2 WHY YOU WANT TO DO THAT

Well ...

     { requires => { Foo => 1.0 }}

     Foo is in Bar

     Foo 1.0 could have been shipped in in Bar-1.0, Bar-0.5, or Bar-2.0 for all you know.

That's the unfortunate reality of C<CPAN> dependencies.

So if you naively map

    Foo-1.0 → >=dev-lang/Bar-1.0

You might get breakage if C<Foo 1.0> didn't ship till C<Bar-2.0>, and the user has C<Bar-1.0> → Shower of sparks.

=head1 DESCRIPTION

This module serves as a low level glue layer for the handful of manual mappings
that are needed in Gentoo due to things not strictly tracking upstream.

C<CPANPLUS::Dist::Gentoo> has similar logic to this, but not as simple ( or for that matter, usable without C<CPANPLUS> )

This module is not intended to be used entirely on its own, but as a short-circuit before calling
complicated C<MetaCPAN> code.

=head1 METHODS

=head2 has_module_override

  $v->has_module_override( $module )

Returns true if there is a known mapping for C<$module> in C<Gentoo> that is unusual and may require translation.

Will return true for anything that is either a C<virtual> or has an unusual
name translation separating it from C<CPAN>.

=head2 get_module_override

  $v->get_module_override( $module )

Returns a C<Gentoo> dependency atom corresponding to C<$module> if there is a known mapping for C<$module>.

For instance,

  $v->get_module_override('ExtUtils::MakeMaker')

Emits:

  virtual/perl-ExtUtilsMakeMaker

If C<ExtUtils::MakeMaker> is one day de-cored (Hah!, dreams are free) then
C<has_module_override> will return false, and that instructs you to go back
to assuming it is in C<dev-perl/>

=head2 has_dist_override

  $v->has_dist_override( $distname )

Similar to C<has_module_override> but closer to the dependency spec.

Will return true for anything that is either a C<virtual> or has an unusual
name translation separating it from C<CPAN>.

=head2 get_dist_override

  $v->get_dist_override( $distname )

Similar to C<get_module_override> but closer to the dependency spec.

For instance:

  $v->get_dist_override('PathTools')

Emits:

  virtual/perl-File-Spec

Because C<Gentoo> is quirky like that.

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
