SELECT 
DISTINCT per.autogenId, 
CONCAT_WS(' ', per.firstName, per.lastName) as FullName, 
per.email,
per.mainContactNo,
CONCAT(
		IFNULL(per.address,''),' ', 
    	IFNULL(CAST(per.propertyName AS CHAR CHARACTER SET utf8),''),' ',	
    	IFNULL(CAST(per.flatUnit AS CHAR CHARACTER SET utf8),''),' ',	
		IFNULL(CAST(per.streetNumber AS CHAR CHARACTER SET utf8),''),' ',	
    	IFNULL(CAST(per.streetName AS CHAR CHARACTER SET utf8),''),' ',
		IFNULL(per.suburbTown,''),' ',
		IFNULL(per.stateCity,''),' ',
		IFNULL(per.postcode,''),' ',
		IFNULL(per.country,''),' '
		) AS 'Address',
per.specialNote,
cn.Reason,
pc.enquiredDate, 
-- pc.enquiredDate as enquiredDateFrom, pc.enquiredDate as enquiredDateTo,
pc.courseId, co.code as courseCode, pc.actioned, pc.sent, 
(CASE per.referral
					  WHEN 1 THEN 'Google / Bing / Search Engine'
					  WHEN 2 THEN 'Facebook / Twitter / Social Media'
					  WHEN 3 THEN 'Radio'
					  WHEN 4 THEN 'The Leader / Newspaper / Magazine'
					  WHEN 5 THEN 'Friend / Family'
					  WHEN 6 THEN 'CoursesDirectory'
					  WHEN 7 THEN 'Smart and Skilled'
					  WHEN 8 THEN 'Other'
				END) AS 'Referral',
(SELECT CASE COUNT(enr.enrolmentId) 
					  WHEN 0 THEN 'No' 
					  ELSE 'Yes' 
				END FROM rto_enrolment enr
WHERE enr.personId = per.id) AS enrolled
FROM db1.rto_person per 
LEFT JOIN db1.rto_persons_courses pc 
ON per.id = pc.personId 
LEFT JOIN db1.rto_course co 
ON pc.courseId = co.id 
LEFT JOIN db2.Course_Enquiry_Form_20211027 cn
ON per.email = cn.email
WHERE 
per.pending = 0 
AND pc.enquiredDate <> "" 
AND pc.courseId = co.id 
AND per.published = 1 
AND pc.enquiredDate >= '2022-01-01'
AND pc.enquiredDate <= '2022-08-12'
ORDER BY pc.enquiredDate ASC, co.code ASC
limit 8300
