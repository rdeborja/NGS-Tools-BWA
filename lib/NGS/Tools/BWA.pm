package NGS::Tools::BWA;
use Moose::Role;
use MooseX::Params::Validate;

with 'NGS::Tools::BWA::Roles::PreProcessing';
with 'NGS::Tools::BWA::Roles::Align';
with 'NGS::Tools::BWA::Roles::Mem';
with 'NGS::Tools::BWA::Roles::SplitFastq';

use namespace::autoclean;
use autodie;
use Carp;
use File::Basename;

=head1 NAME

NGS::Tools::BWA - Perl wrapper for the BWA alignment tool.

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';

=head1 SYNOPSIS

A Moose Role containing methods that perform BWA alignment.  This can be used
by any Moose class to simplify its construction.

    package <package::name>
    use Moose;
    with 'NGS::Tools::BWA';

=head1 VARIABLES

=head1 SUBROUTINES/METHODS

=head1 AUTHOR

Richard de Borja, C<< <richard.deborja at oicr.on.ca> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ngs-tools-bwa at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=NGS-Tools-BWA>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NGS::Tools::BWA


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=NGS-Tools-BWA>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/NGS-Tools-BWA>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/NGS-Tools-BWA>

=item * Search CPAN

L<http://search.cpan.org/dist/NGS-Tools-BWA/>

=back


=head1 ACKNOWLEDGEMENTS

Dr. Adam Shlien, PI -- The Hospital for Sick Children

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Richard de Borja.

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

1; # End of NGS::Tools::BWA

no Moose::Role;
