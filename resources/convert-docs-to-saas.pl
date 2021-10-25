#!/usr/bin/perl

use File::Find;
use File::Copy;

# This script converts the documentation site as it is expected to be 
# for the hybrid IT / self-hosted StackState edition and converts it to 
# docs for the SaaS edition as follows:
# 
# * Replace SUMMARY.md with SAAS-SUMMARY.md
# * Remove any links with "StackState Self-Hosted only" in the link from the See Also section
# * De-link geek boxes with "StackState Self-Hosted" in it

$NON_SAAS_EDITION_NAME="StackState Self-Hosted";

sub process_file_or_folder {
  if(-d $_) {
    if (/^\..+$/) {
      print "... Skipping and pruning $File::Find::name\n";
      $File::Find::prune = 1;
    }
  } elsif(-f $_) {
    process_file($_);
  }
}

sub read_file {
  open(INPUT, "< $_") || die "Can't open $_";
  my @lines = <INPUT>;
  close(INPUT);
  return @lines;
}

sub remove_self-hosted_links {
  #print "... Checking for StackState Self-Hosted links\n";
  my @lines = @_;
  my @output;
  for $line (@lines) {
    if($line =~ /\[.*\]\(.* "$NON_SAAS_EDITION_NAME only"\)/) {
      print "... Removing StackState Self-Hosted link: $line";
    } else {
      push @output, $line;
    }
  }
  return @output;
}

sub de_link_geek_boxes {
  my @lines = @_;
  my @output;
  my $geek_box, $self-hosted_box;

  for $line (@lines) {
    if($line =~ /{% hint style=".*" %}/) {
      print "ERROR: missed geek box end! $line" unless ($geek_box == 0);
      # print "... Found geek box start: $line";
      $geek_box = 1;
    } elsif($line =~ /{% endhint %}/) {
      print "ERROR: missed geek box start! $line" unless ($geek_box == 1);
      # print "... Found geek box end: $line";
      $geek_box = $self-hosted_box = 0;
    } elsif($geek_box == 1 && $line =~ /\*\*$NON_SAAS_EDITION_NAME\*\*/) {
      # print "... Found non-SaaS box: $line";
      $self-hosted_box = 1;
    } elsif($self-hosted_box == 1 && $line =~ /\[.*\]\(.*\)/) {
      print "... De-linking geek box link: $line";
      $line =~ s/\[([^\]]*)\]\([^\)]*\)/$1/g;
      print "... De-linked line: $line";
    }
    push @output, $line;
  }
  return @output;
}

sub write_file {
  my $file = shift;
  my @lines = @_;

  open(OUTPUT, "> $file") || die "Can't open output file: $!";
  print OUTPUT @lines;
  close(OUTPUT);
}

sub process_file {
  if(/.*\.md/) {
    print "Processing MD file $File::Find::name\n";
    my @lines = read_file($_);
    @lines = remove_self-hosted_links(@lines);
    @lines = de_link_geek_boxes(@lines);
    write_file($_, @lines);
  }
}

sub get_saas_pages {
  open(SUMMARY, "< SAAS-SUMMARY.md") || die "Can't open SAAS-SUMMARY.md file";
  my @summary = <SUMMARY>;
  close(SUMMARY);

  my @files;
  for $line (@summary) {
    if($line =~ /\[.*\]\((.*)\)/) {
      push @files, $1;
    }
  }
  return @files;
}

### MAIN

copy('SAAS-SUMMARY.md', 'SUMMARY.md') || die "Can't move SAAS-SUMMARY: $?";
copy('SAAS-README.md', 'README.md') || die "Can't move SAAS-README: $?";

find(\&process_file_or_folder, get_saas_pages());

