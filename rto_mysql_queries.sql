-- Unit End date not equal & bigger to SnS report Unit End Date
-- Query 1  Get Student ID
SELECT 
t1.emID, t4.personId AS StdID, t2.enrolmentId AS EnrolID, 
t1.commitmentId, t4.startDate AS enrol_startDate, t1.startDate AS SnS_startDate, t2.dateSent AS Unit_StartDate, 
t1.endDate AS SnS_EndDate, t4.extendedExpiryDate AS Enrol_Ext_Enddate, t4.expiryDate AS Enrol_Enddate,
t3.grade, t2.ordering,t3.dateSentToStudent AS UCompletion
FROM `rto_enrolments_sns` t1
INNER JOIN `rto_enrolments_modules` t2
ON t1.emID = t2.id
INNER JOIN `rto_enrolments_assessments` t3
ON t2.enrolmentid = t3.enrolmentid
INNER JOIN `rto_enrolment` t4
ON t2.enrolmentid = t4.enrolmentid
WHERE t3.grade IN (1,3,4,5,6,8,9)
 AND t1.endDate != t3.dateSentToStudent
-- AND t2.moduleId LIKE '%HLTAID003%'
-- AND t1.endDate < t4.extendedExpiryDate
AND t4.personId = '0241484' 
-- AND t1.commitmentId = 'S213399486'
-- AND t2.enrolmentId = 39055
-- AND t2.ordering IN (3)
-- AND t2.dateSent = '0000-00-00'
-- AND YEAR(t1.endDate) = 2022
-- AND t1.endDate < CURRENT_DATE()
ORDER BY `t2`.`ordering`  ASC
-- limit 30


-- Query 2  Get order and relevant emIDs
SELECT t1.emID, t1.commitmentId, t1.startDate, t1.endDate, t2.enrolmentId, t2.ordering, t2.dateSent, t3.grade, t3.dateSentToStudent
FROM `rto_enrolments_sns` t1
INNER JOIN `rto_enrolments_modules` t2 
ON t1.emID = t2.id
INNER JOIN `rto_enrolments_assessments` t3
ON t2.enrolmentid = t3.enrolmentid
WHERE 
t1.commitmentId = 'S213399486'
AND t3.grade IN (1,3,4,5,6,8,9)
AND t3.dateSentToStudent != t1.endDate  
ORDER BY `t2`.`ordering` ASC

-- Query 3  Update as per SMS front end completed unit dates
SELECT * FROM `rto_enrolments_sns`
WHERE commitmentId = 'S213399486'




---- Extra Queries.
SELECT t1.emID, t1.commitmentId, t1.startDate, t1.endDate, t2.enrolmentId, t2.ordering, t2.dateSent, t3.grade, t3.dateSentToStudent
FROM `rto_enrolments_sns` t1
INNER JOIN `rto_enrolments_modules` t2 
ON t1.emID = t2.id
INNER JOIN `rto_enrolments_assessments` t3
ON t2.enrolmentid = t3.enrolmentid
WHERE t2.dateSent = '0000-00-00'
-- AND t1.startDate != t2.dateSent
AND YEAR(t1.endDate) = 2022
AND t1.endDate < CURRENT_DATE()
-- AND t3.enrolmentid = 39055
-- AND t1.id > 30200
-- AND t1.id < 40208
AND t3.grade IN (1,3,4,5,6,8,9)
AND t3.dateSentToStudent != t1.endDate
ORDER BY t1.emID


SELECT * FROM `rto_enrolments_sns` t1
INNER JOIN `rto_enrolments_modules` t2 
ON t1.emID = t2.id
INNER JOIN `rto_enrolments_assessments` t3
ON t2.enrolmentid = t3.enrolmentid
WHERE t2.dateSent = '0000-00-00'
-- t1.startDate != t2.dateSent
-- AND 
AND YEAR(t1.endDate) = 2022
AND t1.endDate < CURRENT_DATE()
-- AND t3.enrolmentid = 39055
-- AND t1.id > 30200
-- AND t1.id < 40208
AND t3.grade IN (1,3,4,5,6,8,9)
AND t3.dateSentToStudent != t1.endDate
ORDER BY t1.emID


--- Student Completion date 
SELECT 
t1.personId AS 'Student ID', 
CONCAT(t3.firstName, ' ', t3.lastName) AS 'Student Name',  
t2.courseReleaseCode AS 'Course Code', 
t2.courseReleaseName AS 'Course Name',
t1.enrolmentSpecialNote AS "Enrollment Note", 
t1.startDate AS 'Start Date', 
t1.completionDate AS 'Completion Date'
FROM `rto_enrolment` t1
INNER JOIN `rto_courserelease` t2
ON t1.courseId = t2.id
INNER JOIN `rto_person` t3
ON t1.personId = t3.autogenId
WHERE t1.completionDate >= '2021-08-01'
AND t1.completionDate <= '2022-08-01'
order BY t1.completionDate
LIMIT  554


------------ Student start, end date & course details. period  ------------------
SELECT e.startDate, e.expiryDate, courseReleaseCode, courseReleaseName, p.autogenId, p.studentStatus, p.firstName, p.lastName, p.email, p.mainContactNo, p.stateCity, p.country,
p.birthCountry, p.dob, p.gender, p.otherLanguage, p.engLevel, p.aborginality, p.disability, p.highestSchoolLevel, 
p.schoolCompletionYear, p.stillAttendingSchool, p.highestQualification, p.employmentStatus, p.studyReason, p.idType, p.idNo
FROM `rto_person` p
LEFT JOIN `rto_enrolment`e
ON p.autogenId = e.personid
LEFT JOIN `rto_courserelease` m
ON e.courseId = m.id
WHERE autogenId = '0205040'

------------ Update Student start, end date & course details. period  ------------------
SELECT e.startDate AS 'Start Date', 
e.expiryDate AS 'End Date', 
CONCAT(m.courseReleaseCode, ' - ', m.courseReleaseName) AS 'Course Name', 
p.autogenId AS 'Student Id', 
(CASE p.studentStatus
		     WHEN 0 THEN 'Active'
			 WHEN 1 THEN 'Financial Hold'
			 WHEN 2 THEN 'Completed'
			 WHEN 3 THEN 'Completion Pending'
			 WHEN 4 THEN 'Enrolment Extended'
			 WHEN 5 THEN 'Parked'
			 WHEN 6 THEN 'Survey Pending'
			 WHEN 7 THEN 'Partial Completion Pending'
			 WHEN 8 THEN 'Partially Completed'
			 WHEN 9 THEN 'Transferred'			 
			 WHEN 10 THEN 'Enrolment Expired'
			 WHEN 11 THEN 'Cancelled'
			 WHEN 12 THEN 'Withdrawn'
			 WHEN 13 THEN 'Withdrawn - Bad Debt'
			 WHEN 14 THEN 'Training Not Completed'
			 WHEN 15 THEN 'Training Deferred'
			 WHEN 16 THEN 'Debt Recovery'
	   END) AS 'Student Status',
CONCAT(p.firstName, ' ', p.lastName) AS 'Student Name', 
p.email AS 'Email', 
p.mainContactNo AS 'Phone No.',
p.stateCity AS 'State', 
(CASE p.country
		     WHEN 'AU' THEN 'Australia'
			 WHEN 'PK' THEN 'Pakistan'
			 WHEN 'NZ' THEN 'New Zealand'
			 WHEN 'UK' THEN 'United Kingdom'
			 WHEN 'CH' THEN 'China'
			 WHEN 'IN' THEN 'India'
		ELSE p.country
	   END)
	   AS 'Country',
(CASE p.birthCountry
		     WHEN 'AU' THEN 'Australia'
			 WHEN 'PK' THEN 'Pakistan'
			 WHEN 'NZ' THEN 'New Zealand'
			 WHEN 'UK' THEN 'United Kingdom'
			 WHEN 'CH' THEN 'China'
			 WHEN 'IN' THEN 'India'
	   ELSE p.birthCountry
	   END) AS 'Country of Birth',
p.dob AS 'Date of Birth', 
(CASE p.gender
		     WHEN 0 THEN ''
			 WHEN 1 THEN 'Male'
			 WHEN 2 THEN 'Female'
	   END) AS 'Gender',
p.otherLanguage AS 'Other Language', 
(CASE p.engLevel
		     WHEN 0 THEN ''
			 WHEN 1 THEN 'Very well'
			 WHEN 2 THEN 'Well'
			 WHEN 3 THEN 'Not Well'
			 WHEN 4 THEN 'Not at all'
	   END) AS 'English Level',
(CASE p.aborginality
		     WHEN 0 THEN ''
			 WHEN 1 THEN 'Aboriginal'
			 WHEN 2 THEN 'Torres Strait Islander'
			 WHEN 3 THEN 'No'
			 WHEN 4 THEN 'Both Aboriginal and Torres Strait Islander'
	   END) AS 'Aboriginiality',
(CASE p.disability
		     WHEN 0 THEN ''
			 WHEN 1 THEN 'Hearing/deaf'
			 WHEN 2 THEN 'Physical'
			 WHEN 3 THEN 'Intellectual'
			 WHEN 4 THEN 'Learning'
			 WHEN 5 THEN 'Mental illness'
			 WHEN 6 THEN 'Acquired brain impairment'
			 WHEN 7 THEN 'Vision'
			 WHEN 8 THEN 'Medical condition'
			 WHEN 9 THEN 'Other'
	   END) AS 'Disability',
(CASE p.highestSchoolLevel
		     WHEN 0 THEN ''
			 WHEN 1 THEN 'Never attended school'
			 WHEN 2 THEN 'Year 8 or below'
			 WHEN 3 THEN 'Year 9 or equivalent'
			 WHEN 4 THEN 'Year 10 or equivalent'
			 WHEN 5 THEN 'Year 11 or equivalent'
			 WHEN 6 THEN 'Year 12 or equivalent'
	   END) AS 'Highest School Level',
p.schoolCompletionYear AS 'School Completion Year', 
(CASE p.stillAttendingSchool
		     WHEN 0 THEN ''
			 WHEN 1 THEN 'No'
			 WHEN 2 THEN 'Yes'
		END) AS 'Still Attending School',
(CASE p.highestQualification
		     WHEN 0 THEN ''
			 WHEN 1 THEN 'Certificate I'
			 WHEN 2 THEN 'Certificate II'
			 WHEN 3 THEN 'Certificate III (or trade certificate)'
			 WHEN 4 THEN 'Certificate IV (or advance certificate/technician)'
			 WHEN 5 THEN 'Diploma (or associate diploma)'
			 WHEN 6 THEN 'Advanced diploma or associate degree'
			 WHEN 7 THEN 'Bachelor degree or higher degree'
			 WHEN 8 THEN 'Certificate other than the above'
			 WHEN 9 THEN 'None'
	   END) AS 'Highest School Level',
(CASE p.employmentStatus
		     WHEN 0 THEN ''
			 WHEN 1 THEN 'Full-time employee'
			 WHEN 2 THEN 'Part-time employee'
			 WHEN 3 THEN 'Self employed - not employing others'
			 WHEN 4 THEN 'Employer'
			 WHEN 5 THEN 'Employed - unpaid worker in a family business'
			 WHEN 6 THEN 'Unemployed - seeking full-time work'
			 WHEN 7 THEN 'Unemployed - seeking part-time work'
			 WHEN 8 THEN 'Not employed - not seeking employment'
	   END) AS 'Employment Status',
(CASE p.studyReason
		     WHEN 0 THEN ''
			 WHEN 1 THEN 'To get a job'
			 WHEN 2 THEN 'To develop my existing business'
			 WHEN 3 THEN 'To start my own business'
			 WHEN 4 THEN 'To try for different career'
			 WHEN 5 THEN 'To get better job or promotion'
			 WHEN 6 THEN 'It was requirement of my job'
			 WHEN 7 THEN 'I wanted extra skills for my job'
			 WHEN 8 THEN 'To get into another course of study'
			 WHEN 9 THEN 'For personal interest or self-development'
			 WHEN 10 THEN 'Other reasons'
	   END) AS 'Study Reason',
(CASE p.idType
		     WHEN 0 THEN ''
			 WHEN 1 THEN 'Birth Certificate'
			 WHEN 2 THEN 'Drivers Licence'
			 WHEN 3 THEN 'Passport'
			 WHEN 4 THEN 'Proof of Age Card'
			 WHEN 5 THEN 'Photo ID Card'
			 WHEN 6 THEN 'Medicare'
			 WHEN 7 THEN 'ImmiCard'
			 WHEN 8 THEN 'Convention Travel Document (Titre de Voyage)'
			 WHEN 9 THEN 'Document for Travel to Australia (DFTTA)'
			 WHEN 10 THEN 'PLO56 Evidence Card'
			 WHEN 11 THEN 'PLO56 Evidence Card'
	   END) AS 'Form of ID',
p.idNo AS 'ID No'
FROM `rto_person` p
LEFT JOIN `rto_enrolment`e
ON p.autogenId = e.personid
LEFT JOIN `rto_courserelease` m
ON e.courseId = m.id
WHERE 
e.startDate >= '2022-01-01'
AND e.startDate <= '2022-08-12'
-- AND autogenId = '0205040'
LIMIT 700
