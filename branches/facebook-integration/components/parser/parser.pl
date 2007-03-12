#!/usr/bin/perl -w
# create an XML-compliant string

use constant YEAR => "2007";
use constant SEMESTER => "Spring";
%SEMESTER_HASH = ('Spring' => 'SP', 'Fall' => 'FA', 'Summer' => 'SU');
$SEMESTER_LETTERS = $SEMESTER_HASH{+SEMESTER};
use constant SCHEDULE_BASE_URL => "http://courses.uiuc.edu/cis/schedule/urbana/" . YEAR . "/" . SEMESTER . "/";
use constant CATALOG_BASE_URL => "http://courses.uiuc.edu/cis/catalog/urbana/" . YEAR . "/" . SEMESTER . "/";

use constant SUBJECT_INSERT_QUERY => "INSERT INTO cis_subjects(`code`) VALUES (?)";
use constant SUBJECT_ID_SELECT_QUERY => "SELECT id from cis_subjects WHERE code = ?";

use constant COURSE_INSERT_QUERY => "INSERT INTO cis_courses (`cis_subject_id`, `number`, `title`) VALUES (?,?,?)";
use constant COURSE_ID_SELECT_QUERY => "SELECT id FROM cis_courses WHERE cis_subject_id = ? AND number = ?";

use constant SEMESTER_INSERT_QUERY => "INSERT INTO cis_semesters (`cis_course_id`, `year`, `semester`) VALUES (?,?,?)";
use constant SEMESTER_ID_SELECT_QUERY => "SELECT id FROM cis_semesters WHERE cis_course_id = ? AND year = ? AND semester = ?";

use constant SECTION_INSERT_QUERY => "INSERT INTO cis_sections (`cis_semester_id`, `crn`, `stype`, `name`, `startTime`, `endTime`, `days`, `room`, `building`, `instructor`) VALUES (?,?,?,?,STR_TO_DATE(?,'%h:%i %p'),STR_TO_DATE(?,'%h:%i %p'),?,?,?,?)";

use constant STATEMENTS => qw( SUBJECT_INSERT_QUERY SUBJECT_ID_SELECT_QUERY COURSE_INSERT_QUERY COURSE_ID_SELECT_QUERY SEMESTER_INSERT_QUERY SEMESTER_ID_SELECT_QUERY SECTION_INSERT_QUERY );

use XML::DOM;
use DBI;
use LWP::Simple;

require 'database.pl';

sub main()
{
	$DataHandle = ConnectToDatabase();

	#globals
	$parser = XML::DOM::Parser->new();

	PrepareStatementHandles();

	my $doc = $parser->parsefile(SCHEDULE_BASE_URL . "/index.xml");

	foreach my $subject ($doc->getElementsByTagName("subject"))
	{
		ParseSubject($subject);
	}

	$doc->dispose;

	CleanupStatementHandles();

	$DataHandle->disconnect;
}


sub PrepareStatementHandles()
{
	foreach my $statement (STATEMENTS) {
		PrepareStatementHandle($statement);
	}

#	PrepareStatementHandle('SUBJECT_INSERT_QUERY', SUBJECT_INSERT_QUERY);
#	PrepareStatementHandle('SUBJECT_ID_SELECT_QUERY', SUBJECT_ID_SELECT_QUERY);
#	PrepareStatementHandle('COURSE_INSERT_QUERY', COURSE_INSERT_QUERY);
#	PrepareStatementHandle('COURSE_ID_SELECT_QUERY', COURSE_ID_SELECT_QUERY);
#	PrepareStatementHandle('SEMESTER_INSERT_QUERY', SEMESTER_INSERT_QUERY);
#	PrepareStatementHandle('SEMESTER_ID_SELECT_QUERY', SEMESTER_ID_SELECT_QUERY);
#	PrepareStatementHandle('SECTION_INSERT_QUERY', SECTION_INSERT_QUERY);
}


sub PrepareStatementHandle($)
{
	#my ($key, $statement) = @_;
	my $statement = shift;

	#$sth{$key} = $DataHandle->prepare($statement) or die $sth{$key}->errstr;
	$sth{$statement} = $DataHandle->prepare(eval $statement) or die $sth{$statement}->errstr;
}


sub CleanupStatementHandles()
{
	foreach my $statement (keys %sth) {
		$sth{$statement}->finish;
	}
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

	#insert subject into database or get id if it's already there
	my $cis_subject_id;
	do {
		$sth{'SUBJECT_ID_SELECT_QUERY'}->execute($subjectCode);

		$cis_subject_id = $sth{'SUBJECT_ID_SELECT_QUERY'}->fetchrow();

		if (!defined $cis_subject_id) {
			#need to insert
			$sth{'SUBJECT_INSERT_QUERY'}->execute($subjectCode);
		}
	} until (defined $cis_subject_id);

	#get XML file for subject
	print"****************************************************\n";
	print "fetching file from ".SCHEDULE_BASE_URL."$subjectCode/index.xml \n";

	my $doc = $parser->parsefile(SCHEDULE_BASE_URL."/$subjectCode/index.xml");

	foreach my $course ($doc->getElementsByTagName('course'))
	{
		my $courseNumber = GetDomNodeText($course, 'courseNumber');
		my $courseTitle = GetDomNodeText($course, 'title');
		ParseCourse($subjectCode, $cis_subject_id, $courseNumber, $courseTitle);
	}

	$doc->dispose;
}


sub ParseCourse($$)
{
	my ($subjectCode, $cis_subject_id, $courseNumber, $courseTitle) = @_;

	#insert course into database, or fetch if it's already there
	my $cis_course_id;
	do {
		$sth{'COURSE_ID_SELECT_QUERY'}->execute($cis_subject_id, $courseNumber);

		$cis_course_id = $sth{'COURSE_ID_SELECT_QUERY'}->fetchrow();

		if (!defined $cis_course_id) {
			#need to insert
			$sth{'COURSE_INSERT_QUERY'}->execute($cis_subject_id, $courseNumber, $courseTitle);
		}
	} until (defined $cis_course_id);

	#insert semester into database for course, or fetch if it's already there
	#extract to method possibly
	my $cis_semester_id;
	do {
		$sth{'SEMESTER_ID_SELECT_QUERY'}->execute($cis_course_id, YEAR, $SEMESTER_LETTERS);

		$cis_semester_id = $sth{'SEMESTER_ID_SELECT_QUERY'}->fetchrow();

		if (!defined $cis_semester_id) {
			#need to insert
			$sth{'SEMESTER_INSERT_QUERY'}->execute($cis_course_id, YEAR, $SEMESTER_LETTERS);
		}
	} until (defined $cis_semester_id);
		
	print"-----------------------------------------------------\n";
	print"fetching file from ".SCHEDULE_BASE_URL."$subjectCode/$courseNumber.xml\n";

	if(head(SCHEDULE_BASE_URL."/$subjectCode/$courseNumber.xml"))
	{
		my $doc = $parser->parsefile(SCHEDULE_BASE_URL."/$subjectCode/$courseNumber.xml");

		foreach my $section ($doc->getElementsByTagName("section"))
		{
			ParseSection($cis_semester_id, $section);
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

	$sth{'SECTION_INSERT_QUERY'}->execute($cis_semester_id, $crn, $type, $name, $startTime, $endTime, $days, $room, $building, $instructor);
}

main();

