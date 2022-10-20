import java.lang.Math;


public class Square extends Rectangle implements Shape{
	private Point point;
	private double width;
	private double height;

	Square(Point point, double length){
		super(point,length, length);
	}
}
