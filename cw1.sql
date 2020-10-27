SELECT    *
FROM      person
ORDER BY  name;



-- Q1 returns (name,dod)

SELECT  personb.name,
        persona.dod
FROM    person AS persona
        JOIN person AS personb
        ON persona.name=personb.mother
        AND persona.dod IS NOT NULL;

-- Q2 returns (name)

SELECT    name
FROM      person
WHERE     gender='M'
EXCEPT
SELECT    father
FROM      person
ORDER BY  name;

-- Q3 returns (name)
SELECT    DISTINCT mother AS name
FROM      person AS familyMembers
WHERE     NOT EXISTS (  SELECT gender
                        FROM    person
                        EXCEPT
                        SELECT  gender
                        FROM    person
                        WHERE   person.mother = familyMembers.mother
                      )
ORDER BY  name;

-- Q4 returns (name,father,mother)
-- make it better!!!
SELECT      name,father,mother
FROM        person
WHERE       not dob>SOME( SELECT dob
                          FROM person AS sibling
                          WHERE person.father=sibling.father
                          AND person.mother=sibling.mother
                          AND person.name<>sibling.name
                        )
AND EXISTS  (SELECT dob
            FROM person AS sibling
            WHERE person.father=sibling.father
            AND person.mother=sibling.mother
            AND person.name<>sibling.name
            )
ORDER BY  name;

-- Q5 returns (name,popularity)
-- not sure if as name is needed!!!!!!!!!!1
SELECT    CASE
          WHEN POSITION(' ' IN name)-1>0
          THEN SUBSTRING(name FROM 1 FOR POSITION(' ' IN name)-1)
          ELSE name
          END AS name,
          COUNT(*) AS popularity
FROM      person
GROUP BY  CASE
          WHEN POSITION(' ' IN name)-1>0
          THEN SUBSTRING(name FROM 1 FOR POSITION(' ' IN name)-1)
          ELSE name
          END
HAVING    COUNT(*)>1
ORDER BY  popularity DESC, name;

-- Q6 returns (name,forties,fifties,sixties)

SELECT    father AS name,
          COUNT(CASE WHEN dob<='1949-12-31' AND dob>='1940-01-01' THEN name ELSE NULL END) AS forties,
          COUNT(CASE WHEN dob<='1959-12-31' AND dob>='1950-01-01' THEN name ELSE NULL END) AS fifties,
          COUNT(CASE WHEN dob<='1969-12-31' AND dob>='1960-01-01' THEN name ELSE NULL END) AS sexties
FROM      person
GROUP BY  father
HAVING    COUNT(name)>=2
UNION
SELECT    mother AS name,
          COUNT(CASE WHEN dob<='1949-12-31' AND dob>='1940-01-01' THEN name ELSE NULL END) AS forties,
          COUNT(CASE WHEN dob<='1959-12-31' AND dob>='1950-01-01' THEN name ELSE NULL END) AS fifties,
          COUNT(CASE WHEN dob<='1969-12-31' AND dob>='1960-01-01' THEN name ELSE NULL END) AS sexties
FROM      person
GROUP BY  mother
HAVING    COUNT(name)>=2
ORDER BY  name;


-- Q7 returns (father,mother,child,born)
SELECT    father,
          mother,
          name AS child,
          RANK() OVER(PARTITION BY father,mother ORDER BY dob) AS born
FROM      person
WHERE     father IS NOT NULL
AND       mother IS NOT NULL
--GROUP BY  father, mother
ORDER BY  father, mother, born;

-- Q8 returns (father,mother,male)
SELECT    father,
          mother,
          ROUND(100*COUNT(CASE WHEN gender='M' THEN name ELSE NULL END)/COUNT(name))AS male
FROM      person
WHERE     father IS NOT NULL
AND       mother IS NOT NULL
GROUP BY  father, mother
;
