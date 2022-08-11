-- Correct version PhpMyAdmin by Nayab
SELECT DISTINCT p.autogenId AS 'Student',
				(CASE p.referral
					  WHEN 1 THEN 'Google / Bing / Search Engine'
					  WHEN 2 THEN 'Facebook / Twitter / Social Media'
					  WHEN 3 THEN 'Radio'
					  WHEN 4 THEN 'The Leader / Newspaper / Magazine'
					  WHEN 5 THEN 'Friend / Family'
					  WHEN 6 THEN 'CoursesDirectory'
					  WHEN 7 THEN 'Smart and Skilled'
					  WHEN 8 THEN 'Other'
				END) AS 'Referral'
FROM rto_person p 
INNER JOIN rto_persons_courses pc 
ON p.id = pc.personId
WHERE p.referral <> 0
	  AND pc.enquiredDate >= DATE_SUB(CURDATE(), 
                                      INTERVAL 3 MONTH)
ORDER BY Referral, 'Student'
