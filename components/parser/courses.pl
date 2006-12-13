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

# ###############################################################################


foreach my $subject ($doc->getElementsByTagName("subject"))
  {
    # #the lookup the xml file for each course
    my $subjectCode = $subject->getElementsByTagName('subjectCode')->item(0)->getFirstChild->getNodeValue;
    print "fetching file from $url$subjectCode/index.xml \n";
    my $doc1 = $parser->parsefile("$url/$subjectCode/index.xml");
    foreach my $course ($doc1->getElementsByTagName('course'))
      {		
	my $courseNumber = $course->getElementsByTagName('courseNumber')->item(0)->getFirstChild->getNodeValue;
	my $title = $course->getElementsByTagName('title')->item(0)->getFirstChild->getNodeValue;
	print "inserting $subjectCode $courseNumber $title into the table ..\n.";
	my $sql = qq/select id from cis_subjects where code = '$subjectCode'/;
	my $sth = $DataHandle->prepare($sql);
	$sth->execute();
	my $result = $sth->fetchrow();
	print "the subject id for $subjectCode is $result\n";
	$sql ="INSERT into cis_courses (cis_subject_id, number, title) values (\"$result\",\"$courseNumber\",\"$title\")";
	print "$sql/n";
	$DataHandle->do($sql);
	print "inserted successfully/n";
      }
  }
