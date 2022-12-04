import java.util.HashSet;
import java.util.Set;
import java.util.HashMap;
import java.util.Arrays;
import java.util.Map;
import java.util.*;

public class Main{
	
	public static void main(String[] args){
		HashSet<Point> set = new HashSet<Point>();

		set.add(new Point(4, 2));
		set.add(new Point(3, 1));
		set.add(new Point(4, 1));
		set.add(new Point(3, 1));

		System.out.println(set);
	}

	Map<String, Integer> freq(String s){
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		String[] ss = s.split("\\W+");	
		String[] ds = (String[]) Arrays.stream(ss).distinct().toArray();
		int[] ints = new int[ds.length]; 
		for(String si : ds){
			int count = 0;
			for(String sii : ss){
				if(si == sii){
					count++;
				}
			}
			map.put(si, count);
		}
		//Set<String> set = new HashSet<String>(ss);
		//ss = ss.stream().distinct().collect(Collectors.toList());
		return map;	
		//return Arrays.stream(s.split("\\W+")).map();
	}

	
	Map<String, Integer> freqIgnoreCase(String s){
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		String[] ss = s.split("\\W+");	
		String[] ds = (String[]) Arrays.stream(ss).distinct().toArray();
		int[] ints = new int[ds.length]; 
		for(String si : ds){
			int count = 0;
			for(String sii : ss){
				if(si.toLowerCase() == sii.toLowerCase()){
					count++;
				}
			}
			map.put(si, count);
		}
		//Set<String> set = new HashSet<String>(ss);
		//ss = ss.stream().distinct().collect(Collectors.toList());
		return map;	
		//return Arrays.stream(s.split("\\W+")).map();
	}

}
