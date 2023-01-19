use strict;
use warnings;

# localhost | FAILED! => {"changed": false,"msg": "You don't have sudo access, run the playbook with `--ask-become-pass` and type the sudo password"}
my $line = <stdin>;

$line =~ /(\w+) \| (SUCCESS|FAILED!|CHANGED) => (.*)$/;

print $line;
#system("echo $1 => $2: | echo $3 | jq")
#system("echo '$1'")
