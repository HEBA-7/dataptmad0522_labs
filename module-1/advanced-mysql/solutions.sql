—query_1 


SELECT 
s.title_id AS 'TITLE ID',
ta.au_id AS 'AUTHOR ID',
ti.advance * ta.royaltyper / 100 AS 'ADVANCE',
ti.price * s.qty * ti.royalty / 100 * ta.royaltyper / 100 AS 'ROYALTY'


FROM Sales s
LEFT JOIN titles ti ON ti.title_id = s.title_id
LEFT JOIN titleauthor ta ON ta.title_id = s.title_id
ORDER BY "TITLE ID", "AUTHOR ID"


—query_2 


SELECT  
  r.TITLE_ID, 
  r.AUTHOR_ID,
  SUM(r.ROYALTY) AS 'AGG_ROYALTY',
  SUM (r.ADVANCE) AS 'AGG_ADVANCE'
  FROM( SELECT 
    s.title_id AS 'TITLE_ID',
    ta.au_id AS 'AUTHOR_ID',
    ti.advance * ta.royaltyper / 100 AS 'ADVANCE',
    ti.price * s.qty * ti.royalty / 100 * ta.royaltyper / 100 AS 'ROYALTY'


    FROM Sales s
    LEFT JOIN titles ti ON ti.title_id = s.title_id
    LEFT JOIN titleauthor ta ON ta.title_id = s.title_id) r


GROUP BY r.AUTHOR_ID, r.TITLE_ID
ORDER BY r.TITLE_ID




—query_3 


SELECT
y.AUTHOR_ID,
y.AGG_ROYALTY + y.AGG_ADVANCE AS PROFIT
 
FROM (
  SELECT 
  r.TITLE_ID, 
  r.AUTHOR_ID,
  SUM(r.ROYALTY) AS 'AGG_ROYALTY',
  SUM (r.ADVANCE) AS 'AGG_ADVANCE'
  FROM( SELECT 
    s.title_id AS 'TITLE_ID',
    ta.au_id AS 'AUTHOR_ID',
    ti.advance * ta.royaltyper / 100 AS 'ADVANCE',
    ti.price * s.qty * ti.royalty / 100 * ta.royaltyper / 100 AS 'ROYALTY'


    FROM Sales s
    LEFT JOIN titles ti ON ti.title_id = s.title_id
    LEFT JOIN titleauthor ta ON ta.title_id = s.title_id) r
  GROUP BY r.AUTHOR_ID, r.TITLE_ID) y
—query_4 


SELECT
x.AUTHOR_ID AS 'AUTHOR_ID',
SUM(x.PROFIT) AS 'TOTAL_PROFIT'
FROM(
  SELECT
  y.AUTHOR_ID,
  y.AGG_ROYALTY + y.AGG_ADVANCE AS PROFIT
   


  FROM (
    SELECT 
    r.TITLE_ID, 
    r.AUTHOR_ID,
    SUM(r.ROYALTY) AS 'AGG_ROYALTY',
    SUM (r.ADVANCE) AS 'AGG_ADVANCE'
    FROM( SELECT 
      s.title_id AS 'TITLE_ID',
      ta.au_id AS 'AUTHOR_ID',
      ti.advance * ta.royaltyper / 100 AS 'ADVANCE',
      ti.price * s.qty * ti.royalty / 100 * ta.royaltyper / 100 AS 'ROYALTY'


      FROM Sales s
      LEFT JOIN titles ti ON ti.title_id = s.title_id
      LEFT JOIN titleauthor ta ON ta.title_id = s.title_id) r
    GROUP BY r.AUTHOR_ID, r.TITLE_ID) y
)x 
GROUP BY x.AUTHOR_ID
ORDER BY TOTAL_PROFIT DESC 


—query_5


SELECT
x.AUTHOR_ID AS 'AUTHOR_ID',
SUM(x.PROFIT) AS 'TOTAL_PROFIT'
FROM(
  SELECT
  y.AUTHOR_ID,
  y.AGG_ROYALTY + y.AGG_ADVANCE AS PROFIT
   


  FROM (
    SELECT 
    r.TITLE_ID, 
    r.AUTHOR_ID,
    SUM(r.ROYALTY) AS 'AGG_ROYALTY',
    SUM (r.ADVANCE) AS 'AGG_ADVANCE'
    FROM( SELECT 
      s.title_id AS 'TITLE_ID',
      ta.au_id AS 'AUTHOR_ID',
      ti.advance * ta.royaltyper / 100 AS 'ADVANCE',
      ti.price * s.qty * ti.royalty / 100 * ta.royaltyper / 100 AS 'ROYALTY'


      FROM Sales s
      LEFT JOIN titles ti ON ti.title_id = s.title_id
      LEFT JOIN titleauthor ta ON ta.title_id = s.title_id) r
    GROUP BY r.AUTHOR_ID, r.TITLE_ID) y
)x 
GROUP BY x.AUTHOR_ID
ORDER BY TOTAL_PROFIT DESC
LIMIT 3


—temporal_query_2


CREATE TEMPORARY TABLE TOP_AUTHORS AS


SELECT
x.AUTHOR_ID AS 'AUTHOR_ID',
SUM(x.PROFIT) AS 'TOTAL_PROFIT'
FROM(
  SELECT
  y.AUTHOR_ID,
  y.AGG_ROYALTY + y.AGG_ADVANCE AS PROFIT
   


  FROM (
    SELECT 
    r.TITLE_ID, 
    r.AUTHOR_ID,
    SUM(r.ROYALTY) AS 'AGG_ROYALTY',
    SUM (r.ADVANCE) AS 'AGG_ADVANCE'
    FROM( SELECT 
      s.title_id AS 'TITLE_ID',
      ta.au_id AS 'AUTHOR_ID',
      ti.advance * ta.royaltyper / 100 AS 'ADVANCE',
      ti.price * s.qty * ti.royalty / 100 * ta.royaltyper / 100 AS 'ROYALTY'


      FROM Sales s
      LEFT JOIN titles ti ON ti.title_id = s.title_id
      LEFT JOIN titleauthor ta ON ta.title_id = s.title_id) r
    GROUP BY r.AUTHOR_ID, r.TITLE_ID) y
)x 
GROUP BY x.AUTHOR_ID
ORDER BY TOTAL_PROFIT DESC
LIMIT 3




—final_query


WITH r AS
  (SELECT 
  s.title_id AS 'TITLE_ID',
  ta.au_id AS 'AUTHOR_ID',
  ti.advance * ta.royaltyper / 100 AS 'ADVANCE',
  ti.price * s.qty * ti.royalty / 100 * ta.royaltyper / 100 AS 'ROYALTY'


  FROM Sales s
  LEFT JOIN titles ti ON ti.title_id = s.title_id
  LEFT JOIN titleauthor ta ON ta.title_id = s.title_id),


y AS
  (SELECT 
  r.TITLE_ID, 
  r.AUTHOR_ID,
  SUM(r.ROYALTY) AS 'AGG_ROYALTY',
  SUM (r.ADVANCE) AS 'AGG_ADVANCE'
  FROM r
  GROUP BY r.AUTHOR_ID, r.TITLE_ID),


x AS
  (SELECT
  y.AUTHOR_ID,
  AGG_ROYALTY + AGG_ADVANCE AS 'PROFIT'
  FROM y)


SELECT
AUTHOR_ID,
SUM(PROFIT) AS 'TOTAL_PROFIT'
FROM x
GROUP BY AUTHOR_ID
ORDER BY TOTAL_PROFIT DESC
LIMIT 3