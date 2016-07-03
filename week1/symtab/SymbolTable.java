package vb.week1.symtab;

import java.util.HashMap;

public class SymbolTable<Entry extends IdEntry> {

	private int level;
	private HashMap<Integer, HashMap<String, IdEntry>> symboltable;
	
	/**
	 * Constructor.
	 * 
	 * @ensures this.currentLevel() == -1
	 */
	public SymbolTable() {
		level = -1;
		symboltable = new HashMap<Integer, HashMap<String, IdEntry>>();
	}

	/**
	 * Opens a new scope.
	 * 
	 * @ensures this.currentLevel() == old.currentLevel()+1;
	 */
	public void openScope() {
		level++;
		symboltable.put(level, new HashMap<String, IdEntry>());
	}

	/**
	 * Closes the current scope. All identifiers in the current scope will be
	 * removed from the SymbolTable.
	 * 
	 * @requires old.currentLevel() > -1;
	 * @ensures this.currentLevel() == old.currentLevel()-1;
	 */
	public void closeScope() {
		if(level > -1){
			symboltable.remove(level);
			level--;
		}
	}

	/** Returns the current scope level. */
	public int currentLevel() {
		return level;
	}

	/**
	 * Enters an id together with an entry into this SymbolTable using the
	 * current scope level. The entry’s level is set to currentLevel().
	 * 
	 * @requires id != null && id.length() > 0 && entry != null;
	 * @ensures this.retrieve(id).getLevel() == currentLevel();
	 * @throws SymbolTableException
	 *             when there is no valid current scope level, or when the id is
	 *             already declared on the current level.
	 */
	public void enter(String id, Entry entry) throws SymbolTableException {
		HashMap<String, IdEntry> mapOfIdentifiers = symboltable.get(level);
		if (level < 0){
			throw new SymbolTableException("Level Too Deep!");
		} else if (level > -1 && mapOfIdentifiers.containsKey(id)){
			throw new SymbolTableException("Identifier " + id + " was already declared on this level!");
		} else {
			entry.setLevel(level);
			mapOfIdentifiers.put(id, entry);
		}
	}

	/**
	 * Get the Entry corresponding with id whose level is the highest; in other
	 * words, that is defined last.
	 * 
	 * @return Entry of this id on the highest level null if this SymbolTable
	 *         does not contain id
	 */
	@SuppressWarnings("unchecked")
	public Entry retrieve(String id) {
		Entry res = null;
		for(int i = level; i >= 0; i--){
			HashMap<String, IdEntry> mapOfIdentifiers = symboltable.get(i);
			if(mapOfIdentifiers.containsKey(id)){
				res = (Entry) mapOfIdentifiers.get(id);
				break;
			}
		}
		return res;
	}
}
    
/** Exception class to signal problems with the SymbolTable */
class SymbolTableException extends Exception {
    /** {@link serialVersionUID} is required for Serializable */
    public static final long serialVersionUID = 24362462L;
    public SymbolTableException(String msg) { super(msg); }
}
