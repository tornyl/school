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
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("aa", 5);
		map.put("coeff", 42);
		System.out.println(rpnCalc("1 2 3 + +", map));
		System.out.println(rpnCalc("1 32 + 42 *  5 + 66 -", map));
		System.out.println(rpnCalc("1 32 + coeff *  aa + 66 -", map));
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

	static int rpnCalc(String exprt,Map<String, Integer> variables){
		Stack<Integer> stack = new Stack<Integer>();	
		for(int i = 0; i < exprt.length(); i++){
			char ch = exprt.charAt(i);
			if(ch == '+'){
				stack.push(stack.pop() + stack.pop());
			}else if(ch == '-'){	
				stack.push(stack.pop() - stack.pop());
			}else if(ch == '*'){
				stack.push(stack.pop() * stack.pop());
			}else if(ch == '/'){	
				stack.push(stack.pop() / stack.pop());
			}else if(Character.isDigit(ch)){
				int j = 0;
				while(Character.isDigit(exprt.charAt(i+j))){
					j++;
				}
				stack.push(Integer.parseInt(exprt.substring(i, i+j)));
				i +=j;
			}else if(Character.isAlphabetic(ch)){
				int j = 0;
				while(Character.isAlphabetic(exprt.charAt(i+j))){
					j++;
				}
				stack.push(variables.get(exprt.substring(i, i+j)));	
				i +=j;
			}
		}
		return stack.pop();
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
