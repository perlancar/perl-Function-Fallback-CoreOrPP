package Function::Fallback::CoreOrPP;

use 5.010001;
use strict;
use warnings;

# VERSION

our $USE_NONCORE_XS_FIRST = 1;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(
                       clone
                       uniq
               );

sub clone {
    my $data = shift;
    goto FALLBACK unless $USE_NONCORE_XS_FIRST;
    goto FALLBACK unless eval { require Data::Clone; 1 };

  STANDARD:
    return Data::Clone::clone($data);

  FALLBACK:
    require Clone::PP;
    return Clone::PP::clone($data);
}

sub uniq {
    goto FALLBACK unless $USE_NONCORE_XS_FIRST;
    goto FALLBACK unless eval { require List::MoreUtils; 1 };

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
#ABSTRACT: Functions that use non-core XS module but provide pure-Perl/core fallback

=for Pod::Coverage ^()$

=head1 SYNOPSIS

 use Function::Fallback::CoreOrPP qw(clone uniq);

 my $clone = clone({blah=>1});
 my @uniq  = uniq(1, 3, 2, 1, 4);  # -> (1, 3, 2, 4)


=head1 DESCRIPTION

This module provides functions that use non-core XS modules (for best speed,
reliability, feature, etc) but falls back to those that use core XS or pure-Perl
modules when the non-core XS module is not available.

This module helps when you want to bootstrap your Perl application with a
portable, dependency-free Perl script. In a vanilla Perl installation (having
only core modules), you can use L<App::FatPacker> to include non-core pure-Perl
dependencies to your script.


=head1 FUNCTIONS

=head2 clone($data) => $cloned

Try to use L<Data::Clone>'s C<clone> (because it's the fastest) but, when not
available, fall back to L<Clone::PP>'s C<clone>.

=head2 uniq(@ary) => @uniq_ary

Try to use L<List::MoreUtils>'s C<uniq>, but fall back to using slower,
pure-Perl implementation.


=head1 SEE ALSO

L<Clone::Any> can also uses multiple backends, but I avoid it because I don't
think L<Storable>'s C<dclone> should be used (no Regexp support out of the box +
must use deparse to handle coderefs).

=cut
