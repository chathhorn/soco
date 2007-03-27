#!c:/perl/bin/perl.exe -w

$ENV{PATH} = $ENV{PATH} . ';c:\Program Files\mySQL\MySQL Server 5.0\bin';

print "[*  ] Creating Database and User\n";
system("mysql -f -u root < CREATE.SQL") and die "Can't create database and user\n";

chdir("../..");

print "[** ] Running migrations to create tables\n";
system("rake db:migrate") and die "Migration failed\n";

print "[***] Importing CIS course data\n";
system("mysql -u root < \"db/data/development/CIS Data 20070326 0528.sql\"") and die "Data import failed\n";

print "Finished!\n";

