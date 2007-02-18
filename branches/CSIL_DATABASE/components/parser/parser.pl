#!/usr/bin/perl
# create an XML-compliant string

# include package
use XML::DOM;
use DBI;
use LWP::Simple;


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


##################################################################################################
# Read the mysql_serverinfo and mysql_stat database handle attributes
##################################################################################################
my $ServerInfo  =  $DataHandle->{'mysql_serverinfo'};
my $ServerStat  =  $DataHandle->{'mysql_stat'};

print "Server Info: $ServerInfo\n";
print "Server Stat: $ServerStat\n";




# #selecting data for testing
# my $sth = qq/
# select id from cis_subjects where code = 'CS'
# /
# ;
# print $sth;
# #my $exe = $Datahandle->prepare( $sth );
# #$exe->execute();
# #$result =$exe->fetchrow();
# #print "The result of the select statement is $result";
# $DataHandle->disconnect();

# instantiate parser
my $parser = XML::DOM::Parser->new();

my $url = "http://courses.uiuc.edu/cis/catalog/urbana/2007/Spring/";

###############################################################################
#first we need to parse all the subjects

my $doc = $parser->parsefile("$url/index.xml");
#print $doc->toString();


#####################################33######################################
# # to insert data from xml to the subjects table ... 
# foreach my $subject ($doc->getElementsByTagName("subject"))
#   {
#     my $subjectCode = $subject->getElementsByTagName('subjectCode')->item(0)->getFirstChild->getNodeValue;
#     my $sql = "insert into cis_subjects(code) values ('$subjectCode') ";
#     print "inserting subject $subject_code";
#     $DataHandle->do($sql);
#   }

#################################################################################

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
# ###############################################################################
# #parse the xml file and store the section + course information into the data

#  #print the subject code , course number, subject description, title for each course
#     foreach my $course ($doc1->getElementsByTagName('course'))
#       {
# 	$
# 	$sql = qq/INSERT into cis_courses (cis_subject_id, number, title) values 
    
    

# ################################################################################






# # parse and create tree
# $doc = $parser->parsefile("index.xml");

# #inserting data into the server
# my $sql = "Insert into cis_subjects(code) values('CS')";
# $DataHandle->do($sql);


# #print the subject code , course number, subject description, title for each course
# foreach my $course ($doc->getElementsByTagName('course'))
#   {

#     print $course->getElementsByTagName('subjectCode')->item(0)->getFirstChild->getNodeValue;
#     print " ";
#     print $course->getElementsByTagName('courseNumber')->item(0)->getFirstChild->getNodeValue;
#     print " ";
#     print $course->getElementsByTagName('title')->item(0)->getFirstChild->getNodeValue;
#     print " ";
#     print $course->getElementsByTagName('hours')->item(0)->getFirstChild->getNodeValue;
#     print"\n";

#     #   foreach my $section ($doc->getElementsByTagName('section'))
# #          {	
# #    	print $section->getElementsByTagName('sectionID')->item(0)->getFirstChild->getNodeValue;
# #    	print"\n";
# #    	print $section->getElementsByTagName('startTime')->item(0)->getFirstChild->getNodeValue;
# #    	print"\n";
# #    	print $section->getElementsByTagName('endTime')->item(0)->getFirstChild->getNodeValue;
# #    	print"\n";
# #    	print $section->getElementsByTagName('days')->item(0)->getFirstChild->getNodeValue;
# #    	print"\n";
# #          }
#   }
# # end
