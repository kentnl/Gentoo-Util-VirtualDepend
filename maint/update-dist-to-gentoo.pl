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
AcePerl,dev-perl/Ace
App-SVN-Bisect,dev-util/App-SVN-Bisect
Autodia,dev-util/autodia
BioPerl,sci-biology/bioperl
BioPerl-DB,sci-biology/bioperl-db
BioPerl-Network,sci-biology/bioperl-network
BioPerl-Run,sci-biology/bioperl-run
CGI-Simple,dev-perl/Cgi-Simple
CGI-SpeedyCGI,dev-perl/SpeedyCGI
Cache-Mmap,dev-perl/cache-mmap
Class-Loader,dev-perl/class-loader
Class-ReturnValue,dev-perl/class-returnvalue
Config-General,dev-perl/config-general
Convert-ASCII-Armour,dev-perl/convert-ascii-armour
Convert-PEM,dev-perl/convert-pem
Crypt-CBC,dev-perl/crypt-cbc
Crypt-DES_EDE3,dev-perl/crypt-des-ede3
Crypt-DH,dev-perl/crypt-dh
Crypt-DSA,dev-perl/crypt-dsa
Crypt-IDEA,dev-perl/crypt-idea
Crypt-Primes,dev-perl/crypt-primes
Crypt-RSA,dev-perl/crypt-rsa
Crypt-Random,dev-perl/crypt-random
DBIx-SearchBuilder,dev-perl/dbix-searchbuilder
Data-Buffer,dev-perl/data-buffer
Date-Manip,dev-perl/DateManip
Digest-BubbleBabble,dev-perl/digest-bubblebabble
Digest-MD2,dev-perl/digest-md2
ExtUtils-Depends,dev-perl/extutils-depends
ExtUtils-PkgConfig,dev-perl/extutils-pkgconfig
Frontier-RPC,dev-perl/frontier-rpc
GBrowse,sci-biology/GBrowse
Glib,dev-perl/glib-perl
Gnome2,dev-perl/gnome2-perl
Gnome2-Canvas,dev-perl/gnome2-canvas
Gnome2-VFS,dev-perl/gnome2-vfs-perl
Gnome2-Wnck,dev-perl/gnome2-wnck
Gtk2,dev-perl/gtk2-perl
Gtk2-Ex-FormFactory,dev-perl/gtk2-ex-formfactory
Gtk2-GladeXML,dev-perl/gtk2-gladexml
Gtk2-Spell,dev-perl/gtk2-spell
Gtk2-TrayIcon,dev-perl/gtk2-trayicon
Gtk2-TrayManager,dev-perl/gtk2-traymanager
Gtk2Fu,dev-perl/gtk2-fu
Image-ExifTool,media-libs/exiftool
Image-Info,dev-perl/ImageInfo
Image-Size,dev-perl/ImageSize
Inline-Files,dev-perl/inline-files
Locale-Maketext-Fuzzy,dev-perl/locale-maketext-fuzzy
Locale-Maketext-Lexicon,dev-perl/locale-maketext-lexicon
Log-Dispatch,dev-perl/log-dispatch
Math-Pari,dev-perl/math-pari
Module-Info,dev-perl/module-info
MogileFS-Server,dev-perl/mogilefs-server
NTLM,dev-perl/Authen-NTLM
Net-SFTP,dev-perl/net-sftp
Net-SSH-Perl,dev-perl/net-ssh-perl
Net-Server,dev-perl/net-server
OLE-Storage_Lite,dev-perl/OLE-StorageLite
Ogg-Vorbis-Header,dev-perl/ogg-vorbis-header
Padre,app-editors/padre
PathTools,virtual/perl-File-Spec
Perl-Tidy,dev-perl/perltidy
Regexp-Common,dev-perl/regexp-common
Set-Scalar,dev-perl/set-scalar
Snapback2,app-backup/snapback2
String-CRC32,dev-perl/string-crc32
Template-Plugin-Latex,dev-perl/Template-Latex
Text-Autoformat,dev-perl/text-autoformat
Text-Reform,dev-perl/text-reform
Text-Template,dev-perl/text-template
Text-Wrapper,dev-perl/text-wrapper
Tie-EncryptedHash,dev-perl/tie-encryptedhash
Time-Period,dev-perl/Period
Tk,dev-perl/perl-tk
Wx,dev-perl/wxperl
XML-XSH2,app-editors/XML-XSH2
YAML,dev-perl/yaml
ack,sys-apps/ack
gettext,dev-perl/Locale-gettext
txt2html,dev-perl/TextToHTML
