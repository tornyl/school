public class main{

	public static void main(String[] args){	
		Country country = new Country("Czech rep", "420");
		Country country2 = new Country("Slovensko", "320");
		country.print();

		Person p = new Person(542, "Jaormir", "Sibiran", 65, "541 944 313", country); 
		Person p3 = new Person(321, "Franta", "zatopek", 65, "541 944 313", country); 
		Person p2 = new Person(532, "Blazen", "Sibiran", 3, "842 944 313", country); 
		System.out.println(p.getStatus());
		System.out.println(p.getPhone());
		System.out.println(p2.getPhone());
		p.print();

		Index index = new Index(new Person[] {p, p2, p3}, new Country[] {country, country2});
		System.out.println(index.count("Slovensko"));
		System.out.println(index.count("Blazen", "Sibiran"));
		index.search(532).print();
		Person[] parr = index.search("Czech rep");
		System.out.println("arr len "+parr.length);
		Person[] parr2 = index.search("Franta", "zatopek");
		System.out.println("arr len "+parr2.length);
		System.out.println(index.setPhoneCode(p2, "+320"));
		
		index.print();

	}
}

