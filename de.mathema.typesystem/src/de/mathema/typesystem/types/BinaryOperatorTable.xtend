package de.mathema.typesystem.types

import java.util.HashMap
import java.util.Map

class BinaryOperatorTable {
	
	Map<Pair<Type, Type>, Type> map = new HashMap
	
	def put(Type left, Type right, Type result){
		val key = left -> right
		
		if( map.containsKey(key) )
			throw new IllegalStateException("key "+key+" has been already specified.")
		
		map.put(key, result)  
	}
	
	def putCommutative(Type left, Type right, Type result){
		put(left, right, result)
		put(right, left, result)
	}
	
	def get(Type left, Type right){
		val key = left -> right
		map.get(key)
	}
}