package de.mathema.typesystem.types

class TypeCompatibility {
	
	def boolean isAssignableTo(Type fromType, Type toType){
		fromType.isSubtypeOf(toType) || fromType.isCoercibleTo(toType)
	}
	
	def private dispatch boolean isSubtypeOf(Type subType, Type superType){
		subType == superType 
	}
	
	def private dispatch boolean isSubtypeOf(AnyType subType, Type superType){
		true
	}
	
	def private dispatch boolean isCoercibleTo(Type fromType, Type toType){
		false
	}
	
	def private dispatch boolean isCoercibleTo(IntType fromType, FloatType toType){
		true
	}
}