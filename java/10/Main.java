import java.util.HashSet;
import java.util.Set;
import java.util.HashMap;
import java.util.Arrays;
import java.util.Map;
import java.util.function.Consumer;
import java.util.*;

public class Main{
	
	public static void main(String[] args){
		HashMap<String, Double> map = new HashMap<String, Double>();
		map.put("aa", 5.);
		map.put("coeff", 42.);
		Map<String, Consumer<Stack<Object>>> functions = makeFunctions();
		System.out.println(rpnCalc("1 2 3 + +", map, functions));
		System.out.println(rpnCalc("1 32 + 42 * 5 + 66 -", map, functions));
		System.out.println(rpnCalc("1 32 + coeff * aa + 66 -", map, functions));
		System.out.println(rpnCalc("#t #f #f = = 4 2 = #t >", map, functions));
		System.out.println(rpnCalc("#t #f >", map, functions));
		System.out.println(rpnCalc("#t 3 1 ?", map, functions));
		System.out.println(parseInt("333422"));
		System.out.println(parseDouble("33.3422"));
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

	static Map<String, Consumer<Stack<Object>>> makeFunctions(){
		HashMap<String, Consumer<Stack<Object>>> functions = new HashMap<String, Consumer<Stack<Object>>>();
		functions.put("+", (stack) -> Invoke(stack, 2, "Tyto hodnoty nelze scitat", (a) -> (double) a[0] + (double) a[1]));
		functions.put("-", (stack) -> Invoke(stack, 2, "Tyto hodnoty nelze odscitat", (a) -> (double)a[1] - (double)a[0]));
		functions.put("*", (stack) -> Invoke(stack, 2, "Tyto hodnoty nelze nasobit", (a) -> (double)a[0] * (double)a[1]));
		functions.put("/", (stack) -> Invoke(stack, 2, "Tyto hodnoty nelze delit", (a) -> (double)a[1] / (double)a[0]));
		functions.put("=", (stack) -> Invoke(stack, 2, "Tyto hodnoty nelze porovnat", (a) -> a[0] == a[1]));
		functions.put("?", (stack) -> Invoke(stack, 3, "Nelze aplikovat tneto typ hodnot na oprator ?", (a) -> (boolean)a[2] ? a[1] : a[0]));
		functions.put(">", (stack) -> Invoke(stack, 2, "Tyto hodnoty nelze porovnat", (a) -> {
			if(areBools(a[0], a[1])){ 
				a[0] =(boolean) a[0] ? 1 : 0;
				a[1] = (boolean) a[1] ? 1 : 0;
			}
			return (int) a[0] < (int) a[1];}));
		functions.put("<", (stack) -> Invoke(stack, 2, "Tyto hodnoty nelze porovnat", (a) -> {
			if(areBools(a[0], a[1])){ 
				a[0] =(boolean) a[0] ? 1. : 0.;
				a[1] = (boolean) a[1] ? 1. : 0.;
			}
			return (double) a[0] > (double) a[1];}));
		return functions;
	}

	static boolean areBools(Object a, Object b){
		try{
			boolean x = (boolean) a;
			boolean y = (boolean) b;
		}catch(Exception e){
			return false;
		}	
		return true;
	}

	static int rpnCalc2(String exprt,Map<String, Integer> variables){
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
				while(Character.isDigit(exprt.charAt(i+j)) == true){
					j++;
				}
				stack.push(Integer.parseInt(exprt.substring(i, i+j)));
				i +=j;
			}else if(Character.isAlphabetic(ch)){
				int j = 0;
				while(Character.isAlphabetic(exprt.charAt(i+j)) == true){
					j++;
				}
				stack.push(variables.get(exprt.substring(i, i+j)));	
				i +=j;
			}
		}
		return stack.pop();
	}

	static Object rpnCalc (String exprt, Map<String, Double> variables, Map<String, Consumer<Stack<Object>>> operators){
		Stack<Object> stack = new Stack<Object>();	
		String[] exps = exprt.split(" ");
		//Collections.reverse(Arrays.asList(exps));
		for(String exp : exps){
			if(isNumber(exp)) {parseNumber(stack, exp);}
			else if(isBoolean(exp)) {parseBoolean(stack, exp);}
			else if(contains(exp, variables)) {parseVariable(stack, exp, variables);}
			else if(contains(exp, operators)) {parseOperator(stack, exp, operators);}
			else return new Exception("Unsoported element");
		}
		return stack.pop();
	}

	static boolean isNumber(String expr){
		try{
			double val = Double.parseDouble(expr);
		}catch(Exception e){
			return false;
		}
		return true;
	}
	
	static boolean isBoolean2(String expr){
		try{
			double val = Double.parseDouble(expr);
		}catch(Exception e){
			return false;
		}
		return true;
	}

	static boolean isBoolean(String expr){
		return expr.equals("#f") || expr.equals( "#t");
	}
	static <T> boolean contains(String expr, Map<String, T> map){
		return map.containsKey(expr);	
	}
	static void parseNumber(Stack<Object> stack, String expr){
		stack.push(Double.parseDouble(expr));
	}
	static void parseBoolean(Stack<Object> stack, String expr){
		stack.push(expr.equals("#t"));
	}
	static void parseVariable(Stack<Object> stack, String expr, Map<String, Double> variables){
		stack.push(variables.get(expr));
	}
	static void parseOperator(Stack<Object> stack, String expr, Map<String, Consumer<Stack<Object>>> operators){
		operators.get(expr).accept(stack);	
	}

	public interface Foo{
		public Object run(Object[] args);
	}

	static void Invoke(Stack <Object> stack, int arg_count, String message, Foo foo){
		Object[] params = new Object[arg_count];
		for(int i = 0; i < arg_count; i++){	
			try{
				Object o = stack.pop();
				params[i]=o;
			}catch(Exception e){
				System.out.println("Spatne poskladani vyrazu");
				return;
			}
		}
		
		try{
			Object o = foo.run(params);
			stack.push(o);
		}catch(Exception e){
			System.out.println(message);
		}

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

	public static Optional<Integer> parseInt(String string){
		return Optional.ofNullable(string.chars().reduce(0, (a, b) -> 10 * a + b - '0'));
	}

	public static Optional<Double> parseDouble(String string){
		String[] s = string.split("\\.");
		System.out.println(s[0]);
		double x =s[0].chars().reduce(0, (a, b) -> 10 * a + b - '0');
		double y =s[1].chars().reduce(0, (a, b) -> 10 * a + b - '0');
		while(y > 1) { y = y / 10;};
		return Optional.ofNullable((double) x+y);
	}
}
