#!/usr/bin/perl
# create an XML-compliant string

# include package
use XML::DOM;
use DBI;


my $dbname = "SoCo_development";
my $hostname = "70.225.190.73";
my $username = "soco";
my $password = "monkey";
my $DataHandle = DBI->connect("DBI:mysql:database=$dbname;host=$hostname",
			      "$username",
			      "$password",
			      {
			       RaiseError => 1,
			       AutoCommit => 0
			      })||die "Unable to connect to $hostname because $DBI::errstr";

# instantiate parser
my $parser = XML::DOM::Parser->new();

my $url = "http://courses.uiuc.edu/cis/catalog/urbana/2007/Spring/";
my $doc = $parser->parsefile("$url/index.xml");

####################################33######################################
 # to insert data from xml to the subjects table ... 
 foreach my $subject ($doc->getElementsByTagName("subject"))
   {
     my $subjectCode = $subject->getElementsByTagName('subjectCode')->item(0)->getFirstChild->getNodeValue;
     my $sql = "insert into cis_subjects(code) values ('$subjectCode') ";
     print "inserting subject $subject_code";
     $DataHandle->do($sql);
   }

################################################################################
