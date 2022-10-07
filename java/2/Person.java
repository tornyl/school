class Person{
	int id; String firstname; String lastname; int age; String phone; Country country;
	Person(int id, String firstname, String lastname, int age, String phone, Country country){
		this.id = id;
		this.firstname = firstname;
		this.lastname = lastname;
		this.age = age;
		this.phone = phone;
		this.country = country;
	}


	String getStatus(){
		if(this.age < 18) return "junior";
		if(this.age >= 65) return "senior";
		else return "dospely";
	}

	String getPhone(){
		if(this.country == null) return this.phone;
		else return this.country.phoneCode +" "+ this.phone;
	}


	void print(){
		System.out.format("Osoba{id=%s. jmeno=%s, prijmeni=%s, vek=%s, telefon=%s, status=%s, stat=%s}\n", this.id, this.firstname, this.lastname, this.age, this.getPhone(), this.getStatus(), this.country.name);
	}


}
