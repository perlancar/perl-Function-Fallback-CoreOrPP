package SHARYANTO::MaybeXS;

use 5.010001;
use strict;
use warnings;

# VERSION

our $USE_XS = 1;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(
                       clone
                       uniq
               );

sub clone {
    my $data = shift;
    goto FALLBACK unless $USE_XS;
    eval { require Data::Clone };
    goto FALLBACK if $@;

  STANDARD:
    return Data::Clone::clone($data);

  FALLBACK:
    require Storable;
    local $Storable::Deparse = 1;
    local $Storable::Eval    = 1;
    return Storable::dclone($data);
}

sub uniq {
    goto FALLBACK unless $USE_XS;
    eval { require List::MoreUtils };
    goto FALLBACK if $@;

  STANDARD:
    return List::MoreUtils::uniq(@_);

  FALLBACK:
    my %h;
    my @res;
    for (@_) {
        push @res, $_ unless $h{$_}++;
    }
    return @res;
}

1;
#ABSTRACT: Do task using non-core XS module, but provide pure-Perl/core fallback

=for Pod::Coverage ^()$

=head1 SYNOPSIS

 use SHARYANTO::MaybeXS qw(clone uniq);

 my $clone = clone({blah=>1});


=head1 DESCRIPTION

This module helps when you want to bootstrap your Perl application with a
portable, dependency-free Perl script. In a vanilla Perl installation (having
only core modules), you can use L<App::FatPacker> to include pure-Perl
dependencies to your script. This module provides fallback for some tasks that
usually need to be done using a non-core XS module, by providing alternatives
using pure-Perl or core XS module.


=head1 FUNCTIONS

=head2 clone($data) => $cloned

Try to use L<Data::Clone>'s C<clone>, but fallback to L<Storable>'s C<clone> (+
Deparse and Eval option turned on). Note that currently Storable can't handle
Regexp object out of the box.

=head2 uniq(@ary) => @uniq_ary

Try to use L<List::MoreUtils>'s C<uniq>, but fallback to using pure-Perl
implementation.


=head1 SEE ALSO

=cut
