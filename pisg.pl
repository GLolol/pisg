#!/usr/bin/perl -w

use strict;
use Getopt::Long;

# pisg - Perl IRC Statistics Generator
#
# Copyright (C) 2001  <Morten Brix Pedersen> - morten@wtf.dk
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

sub main
{
    my $script_dir = $0;

    # If the script was executed as ./pisg.pl - then we just remove
    # everything after the last slash, if it was executed as 'perl pisg.pl'
    # we assume that we are executing in the current dir.
    if ($script_dir =~ m/\/[^\/]*$/) {
        $script_dir =~ s/\/[^\/]*$//;
    } else {
        $script_dir = ".";
    }

    my $cfg = get_cmdline_options($script_dir);
    push(@INC, $cfg->{modules_dir});

    my $pisg;
    eval <<END;

use Pisg;

\$pisg = new Pisg(
    use_configfile => '1',
    override_cfg => \$cfg,
    search_path => \$script_dir,
);
\$pisg->run();
END
    if ($@) {
        print $@;
    }
    if ($@) {
        print STDERR "Could not load pisg! Reason:\n$@\n";
        return undef;
    }
}

sub get_cmdline_options
{
    my $script_dir = shift;

    my $cfg = {
        modules_dir => "$script_dir/modules/",     # Module search path
    };

    # Commandline options
    my ($tmp, $help, $silent, $option);

my $usage = <<END_USAGE;
Usage: pisg.pl [-ch channel] [-l logfile] [-o outputfile] [-ma maintainer]
[-f format] [-n network] [-d logdir] [-mo moduledir] [-s] [-h]

-ch --channel=xxx      : Set channel name
-l  --logfile=xxx      : Log file to parse
-o  --outfile=xxx      : Name of HTML file to create
-ma --maintainer=xxx   : Channel/statistics maintainer
-f  --format=xxx       : Logfile format [see FORMATS file]
-n  --network=xxx      : IRC Network for the channel.
-d  --dir=xxx          : Analyze all files in this dir. Ignores logfile.
-p  --prefix=xxx       : Analyse only files prefixed by xxx in dir.
                         Only works with --dir
-mo --moduledir=xxx    : Directory containing pisg modules.
-co --configfile=xxx   : Configuration file
-s  --silent           : Suppress output (except error messages)
-h  --help             : Output this message and exit (-? also works).

Example:

 \$ pisg.pl -n IRCnet -f xchat -o suid.html -ch \\#channel -l logfile.log

All options may also be defined by editing the configuration file and
calling pisg without arguments.

END_USAGE

    if (GetOptions('channel=s'    => \$cfg->{channel},
                   'logfile=s'    => \$cfg->{logfile},
                   'format=s'     => \$cfg->{format},
                   'network=s'    => \$cfg->{network},
                   'maintainer=s' => \$cfg->{maintainer},
                   'outfile=s'    => \$cfg->{outputfile},
                   'dir=s'        => \$cfg->{logdir},
                   'prefix=s'     => \$cfg->{prefix},
                   'moduledir=s'  => \$cfg->{moduledir},
                   'configfile=s' => \$cfg->{configfile},
                   'ignorefile=s' => \$tmp,
                   'aliasfile=s'  => \$tmp,
                   'silent'       => \$silent,
                   'help|?'       => \$help
               ) == 0 or $help) {
                   die($usage);
               }

    if ($tmp) {
        die("The aliasfile and ignorefile has been obsoleted by the new
        pisg.cfg, please use that instead [look in pisg.cfg]\n");
    }

    if ($silent) { $cfg->{silent} = 1; }

    return $cfg;

}

main();        # Run the script
