#!/usr/bin/perl -w
# create an XML-compliant string

# include package
use XML::DOM;
use DBI;
use LWP::Simple;
my $dbname = "soco_development";
my $hostname = "www.cowelldesign.com";
my $username = "soco";
my $password = "monkey";

print "before connection..\n";
my $DataHandle = DBI->connect("DBI:mysql:database=$dbname;host=$hostname",
			      "$username",
			      "$password",
			      {
			       RaiseError => 1,
			       AutoCommit => 0
			      })||die "Unable to connect to $hostname because $DBI::errstr";
print "connected successfully...\n";

# instantiate parser
my $parser = XML::DOM::Parser->new();
my $url = "http://courses.uiuc.edu/cis/catalog/urbana/2007/Spring/";
my $url1 = "http://courses.uiuc.edu/cis/schedule/urbana/2007/Spring/";
my $doc = $parser->parsefile("$url/index.xml");


foreach my $subject ($doc->getElementsByTagName("subject"))
  {
    # #the lookup the xml file for each course
    my $subjectCode = $subject->getElementsByTagName('subjectCode')->item(0)->getFirstChild->getNodeValue;
    print"******************************************************************\n";
    print "fetching file from $url$subjectCode/index.xml \n";
    my $doc1 = $parser->parsefile("$url/$subjectCode/index.xml");
    foreach my $course ($doc1->getElementsByTagName('course'))
      {		
	my $courseNumber = $course->getElementsByTagName('courseNumber')->item(0)->getFirstChild->getNodeValue;
	print "querying subjectid for  $subjectCode $courseNumber in cis_subjects...\n.";
	my $sql = "select id from cis_subjects where code = '$subjectCode'";
	print "$sql\n";
	my $sth = $DataHandle->prepare($sql);
	$sth->execute();
	my $subjectid =  $sth->fetchrow;
       	print"subjectid is $subjectid\n";
	print"querying semester id \n";
	my $sql1 = qq/select id from cis_courses where cis_subject_id = $subjectid AND number = $courseNumber/;
	print "$sql1 \n";
	my $sth1 = $DataHandle->prepare($sql1);
	$sth1->execute();
	my $cis_course_id = $sth1->fetchrow();
       	print "The course id  is $cis_course_id \n";
	print"-------------------------------------------------------------\n";
	print"fetching file from $url1$subjectCode/$courseNumber.xml\n";

	if(head ("$url1/$subjectCode/$courseNumber.xml"))
	  {
	    print"fetched successfully...\n";
	    $semester = "SP";
	  }
	else
	  {
	    print"did not fetch successfully ...\n";
	    $semester = "";
	  }
	
	my $sql2 = "update cis_semesters SET semester = '$semester' where id = $cis_course_id";
	print "$sql2\n";
	
	my $sth2 = $DataHandle->prepare($sql2);
	$sth2->execute();
	print"updated...\n";
      }
  }

	


# for ($j = 1; $j<= 7654; $j++)
#   {

    
#     my $sql = "insert into cis_semesters(cis_course_id, year, semester) values('$j','2007','SP')";
#     print "$sql\n";
#     $DataHandle->do($sql);
#     print"inserted ...\n";

#   }

$DataHandle->disconnect;











