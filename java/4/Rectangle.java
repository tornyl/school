import java.lang.Math;


public class Rectangle implements Shape{
	private Point p;
	private double width;
	private double height;
	Rectangle(Point p1, Point p2){
		this.p = p1;
		this.width = p2.X() - p1.X();
		this.height = p2.Y() - p1.Y();
	}

	Rectangle(Point p, double width, double height){
		this.p = p;
		this.width = width;
		this.height = height;
	}

	public double getArea(){ return width * height;}

	public double distance(Point p){
		Point p2 = new Point(this.p.X() + this.width, this.p.Y());
		Point p3 = new Point(this.p.X(), this.p.Y() + this.height);
		Point p4 = new Point(this.p.X() + this.width, this.p.Y() + this.height);
		Line l1 = new Line(this.p, p2);
		Line l2 = new Line(this.p, p3);
		Line l3 = new Line(p3, p4);
		Line l4 = new Line(p2, p4);

		return Math.min(Math.min(Math.min(l4.distance(p), l3.distance(p)), l2.distance(p)), l1.distance(p));
	}


}
