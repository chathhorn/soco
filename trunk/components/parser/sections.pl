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
	my $cis_semester_id = $sth1->fetchrow();

       	print "The subjectid is $subjectid \n";
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
		    $endTome = "";
		  }

		
		my $days = $section->getElementsByTagName('days')->item(0)->getFirstChild;
		if($days)
		  {
		    $days = $days->getNodeValue;
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
		$sql ="INSERT into cis_sections (cis_semester_id, crn, type, name, startTime, endTime, days, room, building, instructor) values ('$cis_semester_id','$crn','$type',\"$name\",'$startTime','$endTime','$days',\"$room\",\"$building\",\"$instructor\")";
		print "$sql\n";
		$DataHandle->do($sql);
		print "inserted successfully\n";

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











