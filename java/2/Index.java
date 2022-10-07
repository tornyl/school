import java.util.Arrays;

class Index{
	
	Person[] persons;
	Country[] countries;
	Index(Person[] persons, Country[] countries){
		this.persons = persons;
		this.countries = countries;
	}

	int count(String countryName){
		int i  = 0;
		for( Person person : this.persons){
			if(person.country != null && person.country.name == countryName) i++;
		}
		return i;
	}

	int count(String firstname, String lastname){

		int i = 0;
		for(Person person :this.persons){
			if(person.firstname == firstname && person.lastname == lastname) i++;
		}
		return i;
	}

	Person search(int id){
		for(Person person : this.persons){
			if(person.id == id) return person;
		}
		return null;
	}

	Person[] search(String countryName){
		Person[] selection = new Person[this.persons.length];	
		int i = 0;
		for(Person person : this.persons){
			if(person.country.name == countryName){
				selection[i] = person;
				i++;
			}
		}
		System.out.println("i: "+i);
		selection = Arrays.copyOf(selection, i);
		return selection;
	}


	Person[] search(String firstname, String lastname){
		Person[] selection = new Person[this.persons.length];	
		int i = 0;
		for(Person person : this.persons){
			if(person.firstname == firstname && person.lastname == lastname){
				selection[i] = person;
				i++;
			}
		}
		System.out.println("i: "+i);
		selection = Arrays.copyOf(selection, i);
		return selection;
	}

	boolean setPhoneCode(Person person, String phoneCode){
		for(Country country : this.countries){
			if(country.phoneCode.equals(phoneCode)){
				person.country = country;
				return true;
			}
		}

		return false;
	}

	void print(){
		System.out.println("Rejstrik{");
		for(Person person : persons){
			System.out.format("Osoba{id=%d, jmeno=%s, prijmeni=%s, telefon=%s}\n", person.id, person.firstname, person.lastname, person.phone);
		}
		System.out.println("}");
	}
}
