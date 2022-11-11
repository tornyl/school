

SELECT * from skola as s1, skola as s2 where s1.vyucujici = s2.vyucujici and s1.jazyk != s2.jazyk;

table skola;


SELECT * from skola as s1, skola as s2 where s1.rozvrh = s2.rozvrh and s1.jazyk != s2.jazyk;

table skola;

SELECT distinct trida, rozvrh  from skola;

CREATE or replace VIEW skola2 as SELECT student, jazyk, vyucujici, trida from skola;

SELECT distinct vyucujici, jazyk from skola2;

SELECT student,trida, vyucujici from skola2;
