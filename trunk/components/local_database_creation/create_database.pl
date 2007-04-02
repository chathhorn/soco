#!env perl -w

$ENV{PATH} = $ENV{PATH} . ';c:\Program Files\mySQL\MySQL Server 5.0\bin';

if ($#ARGV >= 0 && $ARGV[0] eq '--create') {
	print "Enter MySQL password for user 'root': ";
	$password = <STDIN>;

	print "[*    ] Creating Database and User\n";
	system("mysql -f -u root -p$password < CREATE.SQL") and die "Can't create database and user\n";
}

chdir("../..");

print "[**   ] Running migrations to create tables\n";
system("rake db:migrate") and die "Migration failed\n";

print "[***  ] Clearing existing CIS course data\n";
system("mysql -u soco -pmonkey < \"db/data/development/TRUNCATE CIS Data.sql\"") and die "Truncate failed\n";

print "[**** ] Importing CIS course data\n";
system("mysql -u root -pmonkey < \"db/data/development/CIS Data.sql\"") and die "Data import failed\n";

print "[*****] Creating testing tables\n";
system("rake db:test:clone_structure") and die "Testing table creation failed\n";

print "Finished!\n";

