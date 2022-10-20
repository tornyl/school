
public class main{

	public static void main(String[] args){
		Point p1 = new Point(5, 3);
		Point p2 = new Point(15, -6);
		Point p3 = new Point(30, 30);

		System.out.println(p1.distance(p2));	

		Line l1 = new Line(p1, p2);

		System.out.println(l1.distance(p3));	

		Rectangle r1 = new Rectangle(p2, 5, 8);
		System.out.println(r1.distance(p3));	

		Square s1 = new Square(p3, 3);
		System.out.println(s1.distance(p1));	

		Circle c1 = new Circle(p3, 3);
		System.out.println(c1.distance(p1));	
		}


}
