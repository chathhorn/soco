#!/usr/bin/perl -w

use constant YEAR => "2007";
use constant SEMESTER => "Spring";
%SEMESTER_HASH = ('Spring' => 'SP', 'Fall' => 'FA', 'Summer' => 'SU');
$SEMESTER_LETTERS = $SEMESTER_HASH{+SEMESTER};
use constant SCHEDULE_BASE_URL => "http://courses.uiuc.edu/cis/schedule/urbana/" . YEAR . "/" . SEMESTER . "/";
use constant CATALOG_BASE_URL => "http://courses.uiuc.edu/cis/catalog/urbana/" . YEAR . "/" . SEMESTER . "/";

use constant SUBJECT_INSERT_QUERY => "INSERT INTO cis_subjects(`code`) VALUES (?)";
use constant SUBJECT_ID_SELECT_QUERY => "SELECT id from cis_subjects WHERE code = ?";

use constant COURSE_INSERT_QUERY => "INSERT INTO cis_courses (`cis_subject_id`, `number`, `title`, `description`) VALUES (?,?,?,?)";
use constant COURSE_ID_SELECT_QUERY => "SELECT id FROM cis_courses WHERE cis_subject_id = ? AND number = ?";

use constant SEMESTER_INSERT_QUERY => "INSERT INTO cis_semesters (`cis_course_id`, `year`, `semester`) VALUES (?,?,?)";
use constant SEMESTER_ID_SELECT_QUERY => "SELECT id FROM cis_semesters WHERE cis_course_id = ? AND year = ? AND semester = ?";

use constant SECTION_INSERT_QUERY => "INSERT INTO cis_sections (`cis_semester_id`, `crn`, `stype`, `name`, `startTime`, `endTime`, `days`, `room`, `building`, `instructor`) VALUES (?,?,?,?,STR_TO_DATE(?,'%h:%i %p'),STR_TO_DATE(?,'%h:%i %p'),?,?,?,?)";

use constant COURSE_DEPENDENCY_SELECT_BY_COURSE_ID_QUERY => "SELECT course_dependency_id FROM cis_courses WHERE id = ?";
use constant COURSE_DEPENDENCY_SELECT_BY_SUBJECT_AND_RUBRIC_QUERY => "SELECT cis_courses.course_dependency_id FROM cis_courses INNER JOIN cis_subjects ON cis_subjects.id = cis_courses.cis_subject_id WHERE cis_subjects.code = ? AND cis_courses.number = ?";
use constant COURSE_DEPENDENCY_INSERT_QUERY => "INSERT INTO course_dependencies (`node_type`) VALUES (?)";
use constant CIS_COURSE_FIELD_COURSE_DEPENDENCY_UPDATE_QUERY => "UPDATE cis_courses SET course_dependency_id = ? WHERE id = ?";
use constant COURSE_DEPENDENCY_EDGE_LINK_QUERY => "INSERT INTO course_dependency_edges (`parent_id`,`child_id`) VALUES (?,?)";

use constant SELECT_ALL_CIS_COURSES => "SELECT course_dependency_id, description FROM cis_courses";

use constant COURSE_DEPENDENCY_SELECT_CHILDREN => "SELECT course_dependencies.id, course_dependencies.node_type FROM course_dependencies INNER JOIN course_dependency_edges ON course_dependency_edges.child_id = course_dependencies.id WHERE course_dependency_edges.parent_id = ?";

use constant COURSE_DEPENDENCY_DELETE_LINK => "DELETE FROM course_dependency_edges WHERE parent_id = ? AND child_id = ?";
use constant COURSE_DEPENDENCY_DELETE => "DELETE FROM course_dependencies WHERE id = ?";

use constant STATEMENTS => qw( SUBJECT_INSERT_QUERY SUBJECT_ID_SELECT_QUERY COURSE_INSERT_QUERY COURSE_ID_SELECT_QUERY SEMESTER_INSERT_QUERY SEMESTER_ID_SELECT_QUERY SECTION_INSERT_QUERY COURSE_DEPENDENCY_SELECT_BY_COURSE_ID_QUERY COURSE_DEPENDENCY_SELECT_BY_SUBJECT_AND_RUBRIC_QUERY COURSE_DEPENDENCY_INSERT_QUERY CIS_COURSE_FIELD_COURSE_DEPENDENCY_UPDATE_QUERY COURSE_DEPENDENCY_EDGE_LINK_QUERY SELECT_ALL_CIS_COURSES COURSE_DEPENDENCY_SELECT_CHILDREN COURSE_DEPENDENCY_DELETE_LINK COURSE_DEPENDENCY_DELETE);

use XML::DOM;
use DBI;

require 'database.pl';

sub main()
{
	$DataHandle = ConnectToDatabase();

	#globals
	$parser = XML::DOM::Parser->new();

	PrepareStatementHandles();

        my $doc = $parser->parsefile(CATALOG_BASE_URL . "/index.xml");

	foreach my $subject ($doc->getElementsByTagName("subject"))
	{
		ParseSubject($subject);
	}

	$doc->dispose;

	ParseAllPrerequisites();

	CleanupStatementHandles();

	$DataHandle->disconnect;
}


sub PrepareStatementHandles()
{
	foreach my $statement (STATEMENTS) {
		PrepareStatementHandle($statement);
	}
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

	#if argument is passed in, start from this subject
	if ($#ARGV == 0) {
		if ($ARGV[0] gt $subjectCode) {
			return;
		}
	}

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
	print "Parsing Subject: $subjectCode\n";
	print"****************************************************\n";

	my $doc = $parser->parsefile(CATALOG_BASE_URL."/$subjectCode/index.xml");

	foreach my $course ($doc->getElementsByTagName('course'))
	{
		ParseCourse($course, $subjectCode, $cis_subject_id);
	}

	$doc->dispose;
}


sub ParseCourse($$$)
{
	my ($course, $subjectCode, $cis_subject_id) = @_;

        my $courseNumber = GetDomNodeText($course, 'courseNumber');
        my $courseTitle = GetDomNodeText($course, 'title');
        my $description = GetDomNodeText($course, 'description');

	print"$subjectCode $courseNumber\n";

	#insert course into database, or fetch if it's already there
	my $cis_course_id;
	do {
		$sth{'COURSE_ID_SELECT_QUERY'}->execute($cis_subject_id, $courseNumber);

		$cis_course_id = $sth{'COURSE_ID_SELECT_QUERY'}->fetchrow();

		if (!defined $cis_course_id) {
			#need to insert
			$sth{'COURSE_INSERT_QUERY'}->execute($cis_subject_id, $courseNumber, $courseTitle, $description);
		}
	} until (defined $cis_course_id);

	#create course dependency node if neccesary
	GetCourseDependencyNode($cis_course_id, $description);

	#my $doc = $parser->parsefile(CATALOG_BASE_URL."/$subjectCode/$courseNumber.xml");

	@sections = $course->getElementsByTagName("section");

        if ($#sections >= 0)
        {
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
            
            foreach my $section (@sections)
            {
                    ParseSection($cis_semester_id, $section);
            }
        }

	#$doc->dispose;
}


sub ParseSection($$)
{
	my ($cis_semester_id, $section) = @_;

	my $crn = GetDomNodeText($section, 'referenceNumber');
	if ($crn !~ /^\d+$/)
	{
		undef $crn;
	}

	my $type = GetDomNodeText($section, 'sectionType');

	my $name = GetDomNodeText($section, 'sectionId');

	my $startTime = GetDomNodeText($section, 'startTime');
	if ($startTime eq 'ARRANGED')
	{
		undef $startTime;
	}

	my $endTime = GetDomNodeText($section, 'endTime');

	my $days = GetDomNodeText($section, 'days');

	my $room = GetDomNodeText($section, 'roomNumber');

	my $building = GetDomNodeText($section, 'building');

	my $instructor = GetDomNodeText($section, 'instructor');

	$sth{'SECTION_INSERT_QUERY'}->execute($cis_semester_id, $crn, $type, $name, $startTime, $endTime, $days, $room, $building, $instructor);
}


sub GetCourseDependencyNode($$)
{
	my ($cis_course_id, $description) = @_;

	#lookup node in database
	my $course_dependency_id;
	$sth{'COURSE_DEPENDENCY_SELECT_BY_COURSE_ID_QUERY'}->execute($cis_course_id);

	$course_dependency_id = $sth{'COURSE_DEPENDENCY_SELECT_BY_COURSE_ID_QUERY'}->fetchrow();

	#if NULL then find and link by looking at "Same as" courses
	if (!defined $course_dependency_id) {
		if ($description =~ /\bSame as (.*?)\./)
		{
			foreach $course (split /,| and /, $1) {
				my ($subject, $rubric) = split / /, $course;
				#lookup course in database
				$sth{'COURSE_DEPENDENCY_SELECT_BY_SUBJECT_AND_RUBRIC_QUERY'}->execute($subject, $rubric);
				$course_dependency_id = $sth{'COURSE_DEPENDENCY_SELECT_BY_SUBJECT_AND_RUBRIC_QUERY'}->fetchrow();

				if (defined $course_dependency_id) {
					last;
				}
			}
		}

		#if no course_dependency node alreay exists, then create one
		if (!defined $course_dependency_id) {
			$sth{'COURSE_DEPENDENCY_INSERT_QUERY'}->execute("COURSE");
			$course_dependency_id = $DataHandle->last_insert_id(undef, undef, "course_dependencies", "id");
		}

		#update course dependency link
		$sth{'CIS_COURSE_FIELD_COURSE_DEPENDENCY_UPDATE_QUERY'}->execute($course_dependency_id, $cis_course_id);
	}

	return $course_dependency_id;
}


sub RemovePrerequisitesWithType($$)
{
	my ($course_dependency_id, $type) = @_;

	if ($type eq 'COURSE') {
		return;
	}

	$sth{'COURSE_DEPENDENCY_SELECT_CHILDREN'}->execute($course_dependency_id);

	while (my ($child_id, $type) = $sth{'COURSE_DEPENDENCY_SELECT_CHILDREN'}->fetchrow())
	{
		#remove link
		$sth{'COURSE_DEPENDENCY_DELETE_LINK'}->execute($course_dependency_id, $child_id);

		#recursively remove
		&RemovePrerequisitesWithType($child_id, $type);
	}

	#actually remove node
	$sth{'COURSE_DEPENDENCY_DELETE'}->execute($course_dependency_id);
}


sub RemovePrerequisites($)
{
	my $course_dependency_id = shift;

	$sth{'COURSE_DEPENDENCY_SELECT_CHILDREN'}->execute($course_dependency_id);

	foreach my $row (@{$sth{'COURSE_DEPENDENCY_SELECT_CHILDREN'}->fetchall_arrayref()})
	{
		my ($child_id, $type) = @{$row};
			
		#remove link
		$sth{'COURSE_DEPENDENCY_DELETE_LINK'}->execute($course_dependency_id, $child_id);

		#recursively remove
		RemovePrerequisitesWithType($child_id, $type);
	}
}


sub ParseAllPrerequisites()
{
	$sth{'SELECT_ALL_CIS_COURSES'}->execute();

	while (my ($course_dependency_id, $description) = $sth{'SELECT_ALL_CIS_COURSES'}->fetchrow()) {
		ParseCoursePrerequisites($course_dependency_id, $description);
	}
}


sub ParseCoursePrerequisites($$)
{
	my ($course_dependency_id, $description) = @_;

	#if there is a "See ..." in description, then just return (doesn't contain all data)
	if ($description =~ /\bSee /) {
		return;
	}

	#delete all preexisting prerequisites
	RemovePrerequisites($course_dependency_id);

	#chop description down to "Prerequisite: (...)"
	if ($description =~ s/^.*Prerequisite: (.*)\..*$/$1/)
	{
		#remove " (formerly ...)" from description
		$description =~ s/ \(formerly [^\)]*\)//g;

		#remove words we don't want
		$description =~ s/\bcredit\b//gi;
		$description =~ s/\bequivalent\b//gi;
		$description =~ s/\bconsent of (the )?instructor\b//gi;
		$description =~ s/\bconsent of (the )?department\b//gi;
		$description =~ s/\b[a-z]+\s+(standing|status)\b//gi;

		ParsePrerequisite($course_dependency_id, $description);
	}
}


sub ParsePrerequisite($$)
{
	my ($parent_id, $text) = @_;
        
	#remove "or" and spaces at beginning or end
	$text =~ s/^\s*(\bor\b)?\s*//gi;
	$text =~ s/\s*(\bor\b)?\s*$//gi;
	
	if ($text eq "")
	{
		return;
	}

	my $split_string = "";

	#split prerequisites on semicolons and AND
	if ($text =~ s/;\s*and\b/;/gi)
	{
		foreach my $and_courses (split /\s*;\s*/, $text) {
			&ParsePrerequisite($parent_id, $and_courses);
		}
		return;
	}
	
	#split prerequisites on semicolons and OR
	elsif ($text =~ s/;\s*or\b/;/gi)
	{
		$split_string = qr/\s*;\s*/;
	}

	#split prerequisites on semicolons (AND)
	elsif ($text =~ /;/)
	{
		foreach my $and_courses (split /\s*;\s*/, $text) {
			&ParsePrerequisite($parent_id, $and_courses);
		}
		return;
	}

	#check for commas now with identifiers
	elsif ($text =~ s/,\s*and\b/,/gi)
	{
		foreach my $and_courses (split /\s*,\s*/, $text) {
			&ParsePrerequisite($parent_id, $and_courses);
		}
		return;
	}
    
	#check for commas now with identifiers
	elsif ($text =~ s/,\s*or\b/,/gi)
	{
		$split_string = qr/\s*,\s*/;
	}

	#look for "and" by itself
	elsif ($text =~ /\band\b/i)
	{
		foreach my $and_courses (split /\s*\band\b\s*/, $text) {
			&ParsePrerequisite($parent_id, $and_courses);
		}
		return;
	}

	#look for for "one of ..."
	elsif ($text =~ s/^one of\b\s*//) {
		$split_string = qr/\s*,\s*/;
	}

	#try "or" by itself
	elsif ($text =~ s/\bor\b//) {
		$split_string = qr/\s*\bor\b\s*/;
	}

	#this will happen if an or clause was found
	if ($split_string ne "") {
		my @or_array = split(m/$split_string/, $text);

		my $or_node_id = CreateChildPrerequisiteNode("OR", $parent_id);

		foreach $course (@or_array) {
			&ParsePrerequisite($or_node_id, $course);
		}

	}else{
		#we have a single node

		#look for "concurrent registration in" and link
		if ($text =~ s/concurrent registration in (.*)/$1/) {
			$parent_id = CreateChildPrerequisiteNode("CONCURRENT", $parent_id);
		}

		#parse subject and rubric number
		if ($text =~ /([A-Z]+)\s*([0-9]+)/)
		{
			my ($subject, $rubric) = ($1, $2);
	
			#find course dependency in database
			$sth{'COURSE_DEPENDENCY_SELECT_BY_SUBJECT_AND_RUBRIC_QUERY'}->execute($subject, $rubric);
	
			my $child_dependency_id = $sth{'COURSE_DEPENDENCY_SELECT_BY_SUBJECT_AND_RUBRIC_QUERY'}->fetchrow();
			
			if (defined $child_dependency_id)
			{
				#link
				$sth{'COURSE_DEPENDENCY_EDGE_LINK_QUERY'}->execute($parent_id, $child_dependency_id);
			}else{
				warn "WARNING: Cannot find dependency node for Subject = $subject and Rubric = $rubric in database\n";
			}
		}else{
			warn "WARNING: Cannot Parse '$text'\n";
		}
	}

}


sub CreateChildPrerequisiteNode($$)
{
	my ($type, $parent_id) = @_;

	#insert new node
	$sth{'COURSE_DEPENDENCY_INSERT_QUERY'}->execute($type);
	my $child_id = $DataHandle->last_insert_id(undef, undef, "course_dependencies", "id");

	#link
	$sth{'COURSE_DEPENDENCY_EDGE_LINK_QUERY'}->execute($parent_id, $child_id);

	return $child_id;
}


main();


