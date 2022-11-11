DROP TABLE IF EXISTS novakovi;

CREATE TABLE novakovi (
       predmet varchar(10) not null,
       vaha int not null,
       barva varchar(10) not null,
       cena int not null,
       UNIQUE (predmet, vaha, barva, cena));

INSERT INTO novakovi VALUES
       ('vaza', 1, 'modra', 1000),
       ('stul', 10, 'bila', 5000),
       ('vidlicka', 0, 'stribrna', 20),
       ('televize', 5, 'cerna', 10000),
       ('zidle', 3, 'bila', 2000),
       ('vysavac', 5, 'cerna', 3000);
       

DROP TABLE IF EXISTS kroupovi;

CREATE TABLE kroupovi (
       predmet varchar(10) not null,
       vaha int not null,
       barva varchar(10) not null,
       cena int not null,
       UNIQUE (predmet, vaha, barva, cena));
       
INSERT INTO kroupovi VALUES
       ('stul', 10, 'bila', 5000),
       ('vidlicka', 0, 'stribrna', 20),
       ('zehlicka', 1, 'ruzova', 2000),
       ('televize', 5, 'cerna', 10000),
       ('zidle', 3, 'bila', 2000),
       ('kartac', 0, 'cerna', 25),	
       ('postel', 30, 'oranzova', 50000);
       
       

DROP TABLE IF EXISTS kralikovi;

CREATE TABLE kralikovi (
       predmet varchar(10) not null,
       vaha int not null,
       barva varchar(10) not null,
       cena int not null,
       UNIQUE (predmet, vaha, barva, cena));

INSERT INTO kralikovi VALUES
       ('stul', 10, 'bila', 5000),
       ('vidlicka', 0, 'stribrna', 20),
       ('vana', 50, 'bila', 10000),
       ('kartac', 0, 'cerna', 25),
       ('obraz', 3, 'mix', 100000000),
       ('televize', 5, 'cerna', 10000),
       ('zidle', 3, 'bila', 2000);
       
