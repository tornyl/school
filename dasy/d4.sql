--select human_name from pet_owner except (select human_name from pet_owner,animal except (select animal_name from pet_owner)); 

--select * from pet_owner except (select human_name,animal.animal_name, animal.animal_type  from pet_owner, animal except (select * from pet_owner)); 

--select human_name from pet_owner except (select human_name from (select human_name,animal.animal_name, animal.animal_type  from pet_owner, animal except (table pet_owner)) as foo); 



