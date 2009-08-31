# Author: Veerabahu Subramanian C <veechand@gmail.com>
#
# This software is distributed AS-IS.  The author offers no warranty or
# guarantee.  Best effort email support may be provided solely by the author
# listed above.</pre>
#Multi-line comment: use Acme::Comment type=>'java', own_line=>1;
#ClassFileName - ARGV[0]
#Directory to search, this is optional i will use currect directory - ARGV[1]
#Both of this can be a regex

use strict;
use warnings;
use Cwd;

use File::Find;
use File::Basename;

my ( $class_name, $dir_name );

#only class name is given so by default taking the current directory
if ( scalar(@ARGV) == 1 ) {
    ( $class_name, $dir_name ) = ( $ARGV[0], cwd );
}

#both classname and directory to search is given
elsif ( scalar(@ARGV) == 2 ) {
    ( $class_name, $dir_name ) = ( $ARGV[0], $ARGV[1] );
}
else {
    print "USAGE: perl finjar.pl <filename to find inside jarfile> [<location>] \n" .
        "*) Current directory will be the default location \n" .
        "*) Both the parameters can be regular expression \n" .
        "*) Both the parameters are taken in case in-sensitive manner \n" .
        "*) Quote spaces in parameter \n" ;
    exit;
}
if (index ($^O,"Win") != -1){
    $dir_name =~ s,/,\\,g;
}
find( \&processfiles, $dir_name );

sub processfiles {
    my $file = $File::Find::name;    #this will give the complete path
        my @pacakge_structure;
    my $current_class_name;
    if (index ($^O,"Win") != -1){
        $file =~ s,/,\\,g;
    }
    return unless -f $file;            #process only files
        return unless $_ =~ m/\.jar/io;    #process only jar file
        $file = "\"" . $file . "\"";
    my @jarcontents = `unzip -l $file`;
    my $jarcontains = 0;                 #false
        for my $content (@jarcontents) {

#I am trying to take only the class name and compare
#the value of _contents will be something like a/b/c/XYZ.class
#I am trying to take XYZ out and compare that with file pattern
            @pacakge_structure = split( /\//, $content );
            $current_class_name = $pacakge_structure[$#pacakge_structure];
            if ( $current_class_name  =~ m/$class_name/io ) {
                print $content . "\n";
                $jarcontains = 1;                               #setting to true
            }
        }
    if ( $jarcontains == 1 ) {
        print $file . "\n";
    }

}

