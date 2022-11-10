import java.util.*;

public class Animalfarm{
	
	List<Animal> animals = new ArrayList<Animal>();

	Animalfarm(){
	}

	public void add(String name, Type type, Gender gender){
		this.animals.add(new Animal(name, type, gender));
	}

	public void list(){
		for(Animal animal : this.animals){
			System.out.println(animal.name+" je "+animal.getDescription()+" a dela "+animal.type.getSound());
		}
	}

}




