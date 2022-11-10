import java.lang.Math;

public class Line{
	private Point p1;
	private Point p2;

	Line(Point p1, Point p2){
		this.p1 = p1;
		this.p2 = p2;

	}

	public double getA(){ return (p2.Y() - p1.Y()) / (p2.X() - p1.X());}
	public double getB(){ return p1.Y() - p1.X() * this.A();}
	
	public double getLength(){ return this.p1.distance(this.p2);}

	public double distance(Point p){
		if(p.X() > this.p1.X() && p.X() < this.p2.X()){
			return this.perpendicularDist(p);
		}else{
			return Math.min(p.distance(this.p1), p.distance(this.p2));
		}
	}

	
	private double perpendicularDist(Point p){	
		double a =  this.A() * -1;
		double b = 1;
		double c = this.B();
		
		return Math.abs(a * p.X() + b * p.Y() + c) / Math.sqrt(Math.pow(a, 2) + Math.pow(b, 2)); 	

	}
}
