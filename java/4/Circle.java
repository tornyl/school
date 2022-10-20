import java.lang.Math;

public class Circle implements Shape{
	private Point center;
	private double radius;

	Circle(Point center, double radius){
		this.center = center;
		this.radius = radius;
	}
	public double getArea(){ return Math.PI * Math.pow(this.radius, 2);}
	
	public double distance(Point point){
		return this.center.distance(point) - this.radius;
	}

}
