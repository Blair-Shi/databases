/* Question 1 */
SELECT person_b.name,
       person_a.dod
FROM   person AS person_a
	      JOIN person AS person_b
       ON   person_a.name = person_b.mother
       AND	person_a.dod IS NOT NULL;

/* Question 2 */
SELECT person_b.name
FROM   person AS person_b
WHERE  person_b.gender = 'M'
EXCEPT
SELECT person_b.name
FROM   person AS person_a
	      JOIN person AS person_b
       ON person_b.name = person_a.father
ORDER BY name;

/* Question 3 */
SELECT DISTINCT person_a.mother AS name
FROM   person AS person_a
       JOIN person AS person_b
       ON person_a.mother = person_b.mother
WHERE  person_a.gender <> person_b.gender
ORDER BY person_a.mother;

/* Question 4 */
SELECT person_a.name,
       person_a.father,
	     person_a.mother
FROM   person AS person_a
WHERE  person_a.name IN (SELECT person.name
                         FROM   person
                         WHERE  person.father IS NOT NULL
                         AND    person.mother IS NOT NULL)
AND    person_a.dob <= ALL (SELECT person_b.dob
                            FROM   person AS person_b
                            WHERE  person_b.mother = person_a.mother
                            AND    person_b.father = person_b.father)
ORDER BY name;

/* Question 5 */
SELECT split_part(person_a.name, ' ' , 1 ) AS name,
       COUNT(person_a.dob) AS popularity
FROM   person AS person_a
GROUP BY split_part(person_a.name, ' ', 1)
HAVING COUNT(person_a.dob) > 1
ORDER BY popularity DESC, name ASC;


/* Question 6 */
SELECT person_a.mother AS name,
       COUNT (CASE
              WHEN person_a.dob >= '1940-1-1'
              AND person_a.dob <= '1949-12-31'
              THEN 1
              ELSE NULL
              END) AS forties,
       COUNT (CASE
              WHEN person_a.dob >= '1950-1-1'
              AND person_a.dob <= '1959-12-31'
              THEN 1
              ELSE NULL
              END) AS fifties,
       COUNT (CASE
              WHEN person_a.dob >= '1960-1-1'
              AND person_a.dob <= '1969-12-31'
              THEN 1
              ELSE NULL
              END) AS sixties
FROM   person AS person_a
WHERE  person_a.mother IN
       (SELECT person_b.name
        FROM person AS person_b
        WHERE person_b.name = person_a.mother)
GROUP BY person_a.mother
HAVING COUNT(person_a.dob) >= 2
UNION
SELECT person_a.father AS name,
       COUNT (CASE
              WHEN person_a.dob >= '1940-1-1'
              AND person_a.dob <= '1949-12-31'
              THEN 1
              ELSE NULL
              END) AS forties,
       COUNT (CASE
              WHEN person_a.dob >= '1950-1-1'
              AND person_a.dob <= '1959-12-31'
              THEN 1
              ELSE NULL
              END) AS fifties,
       COUNT (CASE
              WHEN person_a.dob >= '1960-1-1'
              AND person_a.dob <= '1969-12-31'
              THEN 1
              ELSE NULL
              END) AS sixties
FROM   person AS person_a
WHERE  person_a.father IN
       (SELECT person_b.name
        FROM person AS person_b
        WHERE person_b.name = person_a.father)
GROUP BY person_a.father
HAVING COUNT(person_a.dob) >= 2
ORDER BY name;


/* Question 7 */
SELECT father,
       mother,
       name AS child,
       RANK() OVER
         (PARTITION BY father, mother
          ORDER BY dob) AS born
FROM   person
WHERE  father IS NOT NULL
AND    mother IS NOT NULL
ORDER BY father, mother, born;

/* Question 8 */
SELECT father,
       mother,
       ROUND(100.0*(COUNT (CASE
                  WHEN gender = 'M'
                  THEN 1
                  ELSE NULL
                  END))/COUNT(dob),0) AS male
FROM   person
WHERE  father IS NOT NULL
AND    mother IS NOT NULL
GROUP BY father, mother;
