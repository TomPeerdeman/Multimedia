public class LSystem{
	private String[] ruleTable;
	private String axiom;
	
	public LSystem(){
		ruleTable = new String[52];		// A-Z a-z (26 * 2)
	}
	
	public void setAxiom(String s){
		axiom = s;
	}
	
	private int hashRule(char c){
		if(c >= 65 && c <= 90){
			// Hash range A-Z to 0-25
			return c - 65;
		}else if(c >= 97 && c <= 122){
			// Hash range a-z to 26-51
			return c - 97;
		}
		return -1;
	}
	
	public void addRule(char cmd, String rule){
		int idx = hashRule(cmd);
		if(idx > 0){
			ruleTable[idx] = rule;
		}
	}
	
	public String applyRules(int n){
		StringBuffer str = new StringBuffer(axiom);
		for(int i = 0; i < n; i++){
			for(int j = 0; j < str.length(); j++){
				System.out.println("Try " + str.charAt(j) + " at " + j);
				int idx = hashRule(str.charAt(j));
				if(idx > 0 && ruleTable[idx] != null){
					str.replace(j, (j+1), ruleTable[idx]);
					j += ruleTable[idx].length() - 1;
				}
			}
		}
		return str.toString();
	}
}