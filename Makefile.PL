#!/usr/bin/perl

use strict;
use warnings;
use 5.006;

use ExtUtils::MakeMaker;

die "OS unsupported" if( $^O eq 'MSWin32' );

WriteMakefile(
    AUTHOR              => 'Barbie <barbie@cpan.org>',
    NAME                => 'cpan-testers-server-build',
    VERSION             => '1.01',
    ABSTRACT            => 'How to build the CPAN Testers server',
    NO_META             => 1,
    PREREQ_PM => {

        # prereqs
        'CPAN::Testers'         => 0.07,

    },
);
