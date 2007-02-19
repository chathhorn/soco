#!/usr/bin/perl -w
# create an XML-compliant string

use constant BASE_URL => "http://courses.uiuc.edu/cis/schedule/urbana/2007/Spring/";
#use constant SUBJECT_INSERT_QUERY => "INSERT INTO cis_subjects(`code`) VALUES (?)";
#use constant SUBJECT_ID_SELECT_QUERY => "SELECT id from cis_subjects WHERE code = ?";
#use constant COURSE_INSERT_QUERY => "INSERT INTO cis_courses (`cis_subject_id`, `number`, `title`) VALUES (?,?,?)";
use constant COURSE_ID_SELECT_QUERY => "SELECT cis_courses.id FROM cis_courses JOIN cis_subjects ON cis_subjects.id = cis_subject_id WHERE cis_subjects.code = ? AND cis_courses.number = ?";
#use constant SEMESTER_ID_SELECT_QUERY => "";
use constant SECTION_INSERT_QUERY => "INSERT INTO cis_sections (`cis_semester_id`, `crn`, `stype`, `name`, `startTime`, `endTime`, `days`, `room`, `building`, `instructor`) VALUES (?,?,?,?,STR_TO_DATE(?,'%h:%i %p'),STR_TO_DATE(?,'%h:%i %p'),?,?,?,?)";

use XML::DOM;
use DBI;
use LWP::Simple;

require 'database.pl';

&main();

sub main()
{
	my $DataHandle = ConnectToDatabase();

	#globals
	$parser = XML::DOM::Parser->new();

	$sth_course_id_select = $DataHandle->prepare(COURSE_ID_SELECT_QUERY) or die $sth_course_id_select->errstr;
	$sth_section_insert = $DataHandle->prepare(SECTION_INSERT_QUERY) or die $sth_section_insert->errstr;

	my $doc = $parser->parsefile(BASE_URL . "/index.xml");

	foreach my $subject ($doc->getElementsByTagName("subject"))
	{
		&ParseSubject($subject);
	}

	$doc->dispose;

	$sth_course_id_select->finish;
	$sth_section_insert->finish;
	$DataHandle->disconnect;
}


sub GetDomNodeText($$)
{
	my ($parentElement, $childIdentifier) = @_;

	my $ret = "";

	my $childNode = $parentElement->getElementsByTagName($childIdentifier)->item(0)->getFirstChild;
	if($childNode)
	{
		$ret = $childNode->getNodeValue;
	}

	return $ret;
}

sub ParseSubject($)
{
	my $subject = shift;

	#the lookup the xml file for each course
	my $subjectCode = GetDomNodeText($subject, 'subjectCode');

	print"****************************************************\n";
	print "fetching file from ".BASE_URL."$subjectCode/index.xml \n";

	my $doc = $parser->parsefile(BASE_URL."/$subjectCode/index.xml");

	foreach my $course ($doc->getElementsByTagName('course'))
	{
		my $courseNumber = GetDomNodeText($course, 'courseNumber');
		&ParseCourse($subjectCode, $courseNumber);
	}

	$doc->dispose;
}


sub ParseCourse($$)
{
	my ($subjectCode, $courseNumber) = @_;

	$sth_course_id_select->execute($subjectCode, $courseNumber);

	my $cis_semester_id = $sth_course_id_select->fetchrow();

	if (!defined $cis_semester_id) {
		warn "cis_semester_id was not found - skipping course!\n";
		return;
	}

	print"-----------------------------------------------------\n";
	print"fetching file from ".BASE_URL."$subjectCode/$courseNumber.xml\n";

	if(head(BASE_URL."/$subjectCode/$courseNumber.xml"))
	{
		my $doc = $parser->parsefile(BASE_URL."/$subjectCode/$courseNumber.xml");

		foreach my $section ($doc->getElementsByTagName("section"))
		{
			&ParseSection($cis_semester_id, $section);
		}

		$doc->dispose;
	}
	else
	{
		print'~~~~~~~~~~~~~~~~';
		print'FILE NOT FOUND';
		print'~~~~~~~~~~~~~~~~';
	}
}


sub ParseSection($$)
{
	my ($cis_semester_id, $section) = @_;

	my $crn = GetDomNodeText($section, 'referenceNumber');

	my $type = GetDomNodeText($section, 'sectionType');

	my $name = GetDomNodeText($section, 'sectionId');

	my $startTime = GetDomNodeText($section, 'startTime');

	my $endTime = GetDomNodeText($section, 'endTime');

	my $days = GetDomNodeText($section, 'days');

	my $room = GetDomNodeText($section, 'roomNumber');

	my $building = GetDomNodeText($section, 'building');

	my $instructor = GetDomNodeText($section, 'instructor');

	$sth_section_insert->execute($cis_semester_id, $crn, $type, $name, $startTime, $endTime, $days, $room, $building, $instructor);
}
