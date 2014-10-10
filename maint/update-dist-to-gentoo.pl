#!/usr/bin/env perl
# FILENAME: update-dist-to-gentoo.pl
# CREATED: 10/11/14 03:21:18 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Update dist-to-gentoo file.

use strict;
use warnings;
use utf8;

my %premap = ();

my (@normal_virtuals) = qw(
  Archive-Tar
  Attribute-Handlers
  AutoLoader
  autodie
  B-Debug
  CGI
  CPAN
  CPAN-Meta
  CPAN-Meta-YAML
  Carp
  Compress-Raw-Bzip2
  Compress-Raw-Zlib
  DB_File
  Data-Dumper
  Devel-PPPort
  Digest
  Digest-MD5
  Digest-SHA
  Dumpvalue
  Encode
  Exporter
  ExtUtils-CBuilder
  ExtUtils-Command
  ExtUtils-Constant
  ExtUtils-Install
  ExtUtils-MakeMaker
  ExtUtils-Manifest
  ExtUtils-ParseXS
  File-Path
  File-Temp
  Filter-Simple
  Getopt-Long
  HTTP-Tiny
  I18N-LangTags
  IO
  IO-Compress
  IO-Zlib
  JSON-PP
  Locale-Maketext
  Locale-Maketext-Simple
  MIME-Base64
  Math-BigInt
  Math-BigInt-FastCalc
  Math-BigRat
  Math-Complex
  Memoize
  Module-Build
  Module-CoreList
  Module-Load
  Module-Load-Conditional
  Module-Loaded
  Module-Metadata
  Module-Pluggable
  Net-Ping
  Package-Constants
  Params-Check
  Parse-CPAN-Meta
  Perl-OSType
  Pod-Escapes
  Pod-Parser
  Pod-Simple
  Safe
  Scalar-List-Utils
  Socket
  Storable
  Sys-Syslog
  Term-ANSIColor
  Test
  Test-Harness
  Test-Simple
  Text-Balanced
  Text-ParseWords
  Text-Tabs+Wrap
  Thread-Queue
  Thread-Semaphore
  Tie-RefHash
  Time-HiRes
  Time-Local
  Time-Piece
  Version-Requirements
  XSLoader
  autodie
  bignum
  if
  libnet
  parent
  podlators
  threads
  threads-shared
  version
  Devel-SelfStubber
  File-Fetch
  IPC-SysV
  NEXT
  Pod-Checker
  Pod-Perldoc
  Pod-Plainer
  Pod-Usage
  SelfLoader
  Unicode-Collate
  Unicode-Normalize
  constant
);

for my $normal (@normal_virtuals) {
  $premap{$normal} = 'virtual/perl-' . $normal;
}
use Data::Handle;
my $handle = Data::Handle->new('main');

use FindBin;
use Path::Tiny qw(path);

while ( my $line = <$handle> ) {
  chomp $line;
  my ( $key, $value ) = split /,/, $line;
  if ( not $key ) {
    warn "> $line ";
    next;
  }
  $premap{$key} = $value;
}

my $target = path($FindBin::Bin)->sibling('share')->child('dist-to-gentoo.csv');
my $fh     = $target->openw_raw;
for my $key ( sort keys %premap ) {
  $fh->printf( "%s,%s\n", $key, $premap{$key} );
}

package main;

__DATA__
App-SVN-Bisect,dev-utils/App-SVN-Bisect
Autodia,dev-utils/autodia
BioPerl,sci-biology/bioperl
BioPerl-DB,sci-biology/bioperl-db
BioPerl-Network,sci-biology/bioperl-network
BioPerl-Run,sci-biology/bioperl-run
CGI-Simple,dev-perl/Cgi-Simple
Config-General,dev-perl/config-general
Crypt-CBC,dev-perl/crypt-cbc
Date-Manip,dev-perl/Date-Manip
ExtUtils-Depends,dev-perl/extutils-depends
ExtUtils-PkgConfig,dev-perl/extutils-pkgconfig
GBrowse,sci-biology/GBrowse
Glib,dev-perl/glib-perl
Image-ExifTool,media-libs/exiftool
Net-Server,dev-perl/net-server
Padre,app-editors/padre
PathTools,virtual/perl-File-Spec
Perl-Tidy,dev-perl/perltidy
SVK,dev-vcs/svk
Set-Scalar,dev-perl/set-scalar
Snapback2,app-backup/snapback2
Text-Template,dev-perl/text-template
XML-XSH2,app-editors/XML-XSH2
YAML,dev-perl/yaml
ack,sys-apps/ack
