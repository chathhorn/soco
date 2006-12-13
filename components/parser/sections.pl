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

my $sth1;
my $sth;

$sth1 = $DataHandle->prepare("SELECT cis_courses.id FROM cis_courses JOIN cis_subjects ON cis_subjects.id = cis_subject_id WHERE cis_subjects.code = ? AND cis_courses.number = ?") or die $sth1->errstr;
$sth = $DataHandle->prepare("INSERT INTO cis_sections (`cis_semester_id`, `crn`, `type`, `name`, `startTime`, `endTime`, `days`, `room`, `building`, `instructor`) VALUES (?,?,?,?,?,?,?,?,?,?)") or die $sth->errstr;


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

	$sth1->execute($subjectCode, $courseNumber);

	my $cis_semester_id = $sth1->fetchrow();

	print"-------------------------------------------------------------\n";
	print"fetching file from $url$subjectCode/$courseNumber.xml\n";
	
	if(head ("$url1/$subjectCode/$courseNumber.xml"))

	  { 
	    my $doc2 = $parser->parsefile("$url1/$subjectCode/$courseNumber.xml");	    
	    foreach my $section ($doc2->getElementsByTagName("section"))
	      {
		my $crn = $section->getElementsByTagName('referenceNumber')->item(0)->getFirstChild;
		if($crn)
		  {
		    $crn = $crn->getNodeValue;

		    print "crn value is $crn \n";
		  }
		else
		  {
		    $crn = "";
		  }


		 my $type = $section->getElementsByTagName('sectionType')->item(0)->getFirstChild;
		if($type)
		  {
		    $type = $type->getNodeValue;
		  }
		else
		  {
		    $type = "";
		  }

		my $name = $section->getElementsByTagName('instructor')->item(0)->getFirstChild;
		if($name)
		  {
		    $name = $name->getNodeValue;
		  }
		else
		  {
		    $name = ""
		  };
		
		my $startTime = $section->getElementsByTagName('startTime')->item(0)->getFirstChild;
		
		if($startTime)
		  {
		    $startTime = $startTime->getNodeValue;
		  }
		else
		  {
		    $startTime = "";
		  }

		my $endTime = $section->getElementsByTagName('endTime')->item(0)->getFirstChild;
		if($endTime)
		  {
		    $endTime = $endTime->getNodeValue;
		  }
		else
		  {
		    $endTime = "";
		  }

		
		my $days = $section->getElementsByTagName('days')->item(0)->getFirstChild;
		if($days)
		  {
		    $days = $days->getNodeValue;
			$days =~ s/(.)/$1,/g;
		  }
		else
		  {
		    $days = "";
		  }
		

		
		my $room = $section->getElementsByTagName('roomNumber')->item(0)->getFirstChild;
		if($room)
		  {
		    $room = $room->getNodeValue;
		  }
		else
		  {
		    $room = "";
		  }
		
		my $building = $section->getElementsByTagName('building')->item(0)->getFirstChild;

		if($building)
		  {
		    $building = $building->getNodeValue;
		  }
		else
		  {
		    $building ="";
		  }
	
		my $instructor = $section->getElementsByTagName('instructor')->item(0)->getFirstChild;
		if($instructor)
		  {
		    $instructor = $instructor->getNodeValue;
		  }
		else
		  {
		    $instructor ="";
		  }
		
		print "inserting section....\n";

		
		$sth->execute($cis_semester_id, $crn, $type, $name, $startTime, $endTime, $days, $room, $building, $instructor);

	      }
	  }
	else
	  {
	    print'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
	    print'FILE NOT FOUND';
	    print'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
	 }
      }
  }


$DataHandle->disconnect;











