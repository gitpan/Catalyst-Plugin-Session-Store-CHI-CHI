package Catalyst::Plugin::Session::Store::CHI::CHI;

use 5.008;
use strict;
use warnings;

use MRO::Compat;

use base qw( Class::Data::Inheritable Catalyst::Plugin::Session::Store );

use CHI;
use Path::Class     ();
use File::Spec      ();
use Catalyst::Utils ();
use Data::Dumper;
use Carp::Assert;

__PACKAGE__->mk_classdata(qw/_session_chi_chi_storage/);

=head1 NAME

Catalyst::Plugin::Session::Store::CHI::CHI - The great new Catalyst::Plugin::Session::Store::CHI::CHI!

=head1 VERSION

Version 0.001_002

=cut

our $VERSION = '0.001_002';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Catalyst::Plugin::Session::Store::CHI::CHI;

    my $foo = Catalyst::Plugin::Session::Store::CHI::CHI->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 METHODS

=over 4

=item get_session_data

=item store_session_data

=item delete_session_data

=item delete_expired_sessions

These are implementations of the required methods for a store. See
L<Catalyst::Plugin::Session::Store>.

=cut

sub get_session_data {
  my ( $c, $sid ) = @_;
  $c->_check_session_chi_chi_storage;    #see?
  return $c->_session_chi_chi_storage->get($sid);
}

sub store_session_data {
  my ( $c, $sid, $data ) = @_;
  $c->_check_session_chi_chi_storage;    #see?
  return $c->_session_chi_chi_storage->set( $sid, $data );
}

sub delete_session_data {
  my ( $c, $sid ) = @_;
  $c->_check_session_chi_chi_storage;    #see?
  return $c->_session_chi_chi_storage->remove($sid);
}

sub delete_expired_sessions { return; }    # unsupported

# Dummy method.
## no critic (ProhibitUnusedPrivateSubroutines)
sub _session_store_delegate {
  my ($self) = @_;
  return 1;
}
## use critic

=item setup_session

Sets up the session cache file.

=back

=cut

sub setup_session {
  my $c = shift;

  return $c->maybe::next::method(@_);
}

sub _check_session_chi_chi_storage {
  my $c = shift;
  return if $c->_session_chi_chi_storage;

  $c->_session_plugin_config->{namespace} ||= 'SessionStoreChiChi';
  my $cfg = $c->_session_plugin_config->{chi_chi} || {};
  $cfg->{expires_in} ||= $c->_session_plugin_config->{expires};

  if ( $cfg->{dbic_class} ) {
    $cfg->{resultset} = $c->model( $cfg->{dbic_class} );
  }

  for my $k (qw/driver /) {
    assert( $cfg->{$k}, "Need session config key $k" );
  }

  return $c->_session_chi_chi_storage( CHI->new(%$cfg) );
}

=head1 AUTHOR

Motortrak Ltd, C<< <duncan.garland at motortrak.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-catalyst-plugin-session-store-chi-chi at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-Plugin-Session-Store-CHI-CHI>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Catalyst::Plugin::Session::Store::CHI::CHI


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Catalyst-Plugin-Session-Store-CHI-CHI>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Catalyst-Plugin-Session-Store-CHI-CHI>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Catalyst-Plugin-Session-Store-CHI-CHI>

=item * Search CPAN

L<http://search.cpan.org/dist/Catalyst-Plugin-Session-Store-CHI-CHI/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 Motortrak Ltd.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1;    # End of Catalyst::Plugin::Session::Store::CHI::CHI
