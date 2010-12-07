package Dist::Zilla::Plugin::Git::DescribeVersion;
BEGIN {
  $Dist::Zilla::Plugin::Git::DescribeVersion::VERSION = '1.000010';
}
# ABSTRACT: Provide version using git-describe

# I don't know much about Dist::Zilla or Moose.
# This code copied/modified from Dist::Zilla::Plugin::Git::NextVersion.
# Thanks rjbs and jquelin!

use strict;
use warnings;
use Dist::Zilla 4 ();
use Git::DescribeVersion ();
use Moose;
use namespace::autoclean 0.09;

with 'Dist::Zilla::Role::VersionProvider';

# -- attributes

	while( my ($name, $default) = each %Git::DescribeVersion::Defaults ){
has $name => ( is => 'ro', isa=>'Str', default => $default );
	}

# -- role implementation

sub provide_version {
	my ($self) = @_;

	# override (or maybe needed to initialize)
	return $ENV{V} if exists $ENV{V};

	# less overhead to use %Defaults than MOP meta API
	my $opts = { map { $_ => $self->$_() }
		keys %Git::DescribeVersion::Defaults };

	my $new_ver = eval {
		Git::DescribeVersion->new($opts)->version;
	};

	$self->log_fatal("Could not determine version from tags: $@")
		unless defined $new_ver;

	$self->log("Git described version as $new_ver");

	$self->zilla->version("$new_ver");
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;


__END__
=pod

=for :stopwords Randy Stauner RJBS JQUELIN CPAN AnnoCPAN RT CPANTS Kwalitee diff

=head1 NAME

Dist::Zilla::Plugin::Git::DescribeVersion - Provide version using git-describe

=head1 VERSION

version 1.000010

=head1 SYNOPSIS

In your F<dist.ini>:

	[Git::DescribeVersion]
	match_pattern  = v[0-9]*     ; this is the default

=head1 DESCRIPTION

This does the L<Dist::Zilla::Role::VersionProvider> role.
It uses L<Git::DescribeVersion> to count the number of commits
since the last tag (matching I<match_pattern>) or since the initial commit,
and uses the result as the I<version> parameter for your distribution.

The plugin accepts the same options as
L<< Git::DescribeVersion->new()|Git::DescribeVersion/new >>.
See L<Git::DescribeVersion/OPTIONS>.

You can also set the C<V> environment variable to override the new version.
This is useful if you need to bump to a specific version.  For example, if
the last tag is 0.005 and you want to jump to 1.000 you can set V = 1.000.

  $ V=1.000 dzil release

=for Pod::Coverage provide_version

=head1 SEE ALSO

=over 4

=item *

L<Git::DescribeVersion>

=item *

L<Dist::Zilla>

=item *

L<Dist::Zilla::Plugin::Git::NextVersion>

=back

This code copied/modified from L<Dist::Zilla::Plugin::Git::NextVersion>.

Thanks I<RJBS> and I<JQUELIN> (and many others)!

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

  perldoc Dist::Zilla::Plugin::Git::DescribeVersion

=head2 Websites

=over 4

=item *

Search CPAN

L<http://search.cpan.org/dist/Dist-Zilla-Plugin-Git-DescribeVersion>

=item *

RT: CPAN's Bug Tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dist-Zilla-Plugin-Git-DescribeVersion>

=item *

AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dist-Zilla-Plugin-Git-DescribeVersion>

=item *

CPAN Ratings

L<http://cpanratings.perl.org/d/Dist-Zilla-Plugin-Git-DescribeVersion>

=item *

CPAN Forum

L<http://cpanforum.com/dist/Dist-Zilla-Plugin-Git-DescribeVersion>

=item *

CPANTS Kwalitee

L<http://cpants.perl.org/dist/overview/Dist-Zilla-Plugin-Git-DescribeVersion>

=item *

CPAN Testers Results

L<http://cpantesters.org/distro/D/Dist-Zilla-Plugin-Git-DescribeVersion.html>

=item *

CPAN Testers Matrix

L<http://matrix.cpantesters.org/?dist=Dist-Zilla-Plugin-Git-DescribeVersion>

=back

=head2 Bugs

Please report any bugs or feature requests to C<bug-dist-zilla-plugin-git-describeversion at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dist-Zilla-Plugin-Git-DescribeVersion>.  I will be
notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head2 Source Code


L<http://github.com/magnificent-tears/git-describeversion/tree>

  git clone git://github.com/magnificent-tears/git-describeversion.git

=head1 AUTHOR

Randy Stauner <rwstauner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Randy Stauner.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

