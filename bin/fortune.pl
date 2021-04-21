#!/usr/bin/perl
my $snarf = "";
my @fortunes;
while (<>) {
    my $line = "$_";
    chomp $line;
    if ($line eq "%") {
        if($snarf ne "") {
            push @fortunes, $snarf
        }
        $snarf = "";
    } else {
        $snarf = "$snarf$line\n";
    }
}
print $fortunes[rand($#fortunes)];
