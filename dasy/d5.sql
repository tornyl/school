DROP TABLE IF EXISTS skola;

CREATE TABLE  skola
(student INT PRIMARY KEY,
 trida char NOT NULL,
 rozvrh int NOT NULL,
 jazyk varchar(2) NOT NULL,
 vyucujici varchar(10) NOT NULL);

INSERT INTO skola
VALUES
  (1,'A', 1, 'AJ', 'Bily'),
  (2, 'B', 1, 'NJ', 'Modra'),
  (3, 'C', 2, 'AJ', 'Bily'),
  (4, 'A', 1, 'FJ', 'Zelena'),
  (5, 'C', 2, 'AJ', 'Bily');


TABLE skola;



