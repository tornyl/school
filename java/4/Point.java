import java.lang.Math;

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

}
