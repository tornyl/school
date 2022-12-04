import java.lang.Math;
//import java.util.Collection;
//import java.util.Objects;

public class Point{
	private double x;
	private double y;

	Point(double x, double y){
		this.x = x;
		this.y = y;
	}

	public double X(){ return this.x;}
	public double Y(){ return this.y;}
	
	public double distance(Point p){
		return Math.sqrt( Math.pow(this.x - p.X(),2) + Math.pow(this.y - p.Y(), 2));
	}

	@Override
	public boolean equals(Object b){
		if(!(this instanceof Point) || !(b instanceof Point)) return false;

		Point p1 = (Point) this; 
		Point p2 = (Point) b; 
		
		return p1.X() == p2.X() && p1.Y() == p2.Y();
	}

	@Override
	public int hashCode(){
		Point p =  (Point) this;
		return (int) (p.X() + p.Y());
	}

}
