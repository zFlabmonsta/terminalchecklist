#!/bin/perl -w
if (@ARGV == 0) {
	print "./checklist.pl [OPTION] '[REMINDER]'\n";
    print "[OPTION=swap] [num1] [num2]\n";
    print "[OPTION=insert] [num] '[REMINDER]'\n";
    exit 1;
}

sub lastFile {
	open my $F, "<", "checklist.txt" or die;
	my $final = 0;
	while (my $line = <$F>) {
		$final++;	
	}
	close $F;
	return $final + 1;
}

my $file = glob "~/project/checklist/checklist.txt";
my $arg = $ARGV[0];
if ($arg eq 'list') {
    open F, "<", $file or die;
    print "Reminders!!\n";
    while ($line = <F>) {
        print $line; 
    }
    close F;
}

if ($arg eq 'add') {
	open F, ">>", $file or die;
	my $num = lastFile();
	my $checklist = "-[$num]: $ARGV[1]\n";
	print F $checklist;
	close F;
}

if ($arg eq 'remove') {
    open F, "<", $file or die;
    my @push = ();
    while ($line = <F>) {
        if ($line =~ m/-\[$ARGV[1]\]/) {
            next;
        }
        push @push, $line;
    }
    close F;

    open F, ">", $file or die;
    my $count = 1;
    foreach $line (@push) {
        $line =~ s/-\[\d\]/-\[$count\]/g;
        print F $line; 
        $count++;
    }
    close F;
}

if ($arg eq 'swap') {
    if (@ARGV < 3) {
        print "[OPTION=swap] [num1] [num2]\n";
        exit 1;
    }

    open F, "<", $file or die;
    my @push = ();
    while ($line = <F>) {
        push @push, $line; 
    }
    close F;

    my $tmp = $push[$ARGV[1] - 1];
    $push[$ARGV[1] - 1] = $push[$ARGV[2] - 1];
    $push[$ARGV[2] - 1] = $tmp;

    open F, ">", $file or die;
    my $count = 1;
    foreach $line (@push) {
        $line =~ s/-\[\d\]/-\[$count\]/g;
        print F $line; 
        $count++;
    }
    close F;
}

if ($arg eq 'insert') {
    
    if (@ARGV < 3) {
        print "[OPTION=insert] [num1] '[REMINDER]'\n";
        exit 1;
    }

    open F, "<", $file or die;
    my @push = ();
    my $count = 1;
    while ($line = <F>) {
        if ($count == $ARGV[1]) {
            my $checklist = "-[$ARGV[1]]: $ARGV[2]\n";
            push @push, $checklist; 
        }
        push @push, $line; 
        $count++;
    }
    close F;

    open F, ">", $file or die;
    $count = 1;
    foreach $line (@push) {
        $line =~ s/-\[\d\]/-\[$count\]/g;
        print F $line; 
        $count++;
    }
    close F;
}
