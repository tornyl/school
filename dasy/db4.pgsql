DROP TABLE IF EXISTS animal;
CREATE TABLE animal
 (animal_name VARCHAR(20) NOT NULL,
  animal_type VARCHAR(20) NOT NULL);

INSERT INTO animal
VALUES
	('Pepik', 'Veprik'),
	('Hafik', 'Kockodan'),
	('Smudla', 'Hyena');

DROP TABLE IF EXISTS pet_owner;
CREATE TABLE pet_owner
 (human_name VARCHAR(20) NOT NULL,
   animal_name VARCHAR(20) NOT NULL,
   animal_type VARCHAR(20) NOT NULL);



INSERT INTO pet_owner
VALUES
	('Alfons', 'Pepik', 'Veprik'),
	('Alfons', 'Hafik', 'Kockodan'),
	('Karla', 'Smudla', 'Hyena'),
	('Ignac', 'Pepik', 'Veprik'),
	('Karla','Hafik', 'Kockodan'),
	('Alfons','Smudla', 'Hyena'),
	('Karla','Pepik', 'Veprik'),
	('Ignac', 'Hafik', 'Kockodan'),
	('Moric','Smudla', 'Hyena'),
	('Moric', 'Pepik', 'Veprik'),
	('Jonatan','Hafik', 'Kockodan'),
	('Jonatan','Smudla', 'Hyena');

