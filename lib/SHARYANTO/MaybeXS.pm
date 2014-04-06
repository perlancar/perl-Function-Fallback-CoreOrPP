package SHARYANTO::MaybeXS;

use 5.010001;
use strict;
use warnings;

# VERSION

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(clone);

sub clone {
    my $data = shift;
    eval { require Data::Clone };
    if ($@) {
        require Storable;
        Storable::dclone($data);
    } else {
        Data::Clone::clone($data);
    }
}

1;
#ABSTRACT: Do task using a non-core XS module, but provide pure-Perl fallback

=for Pod::Coverage ^()$

=head1 SYNOPSIS

 use SHARYANTO::MaybeXS qw(clone);

 my $clone = clone({blah=>1});


=head1 DESCRIPTION

This module helps when you want to bootstrap your Perl application with a
portable, dependency-free Perl script. In a vanilla Perl installation (having
only core modules), you can use L<App::FatPacker> to include pure-Perl
dependencies to your script. This module provides fallback for some tasks that
usually need to be done using a non-core XS module.


=head1 FUNCTIONS

=head2 clone($data) => $cloned

Try to use L<Data::Clone>'s C<clone>, but fallback to L<Storable>'s C<clone>.
Note that currently Storable can't handle Regexp object out of the box.


=head1 SEE ALSO

=cut
