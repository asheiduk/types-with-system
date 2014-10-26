package de.mathema.typesystem.types

import de.mathema.typesystem.typesystem.Entity
import de.mathema.typesystem.typesystem.EntityTypeRef
import de.mathema.typesystem.typesystem.PrimitiveTypeRef
import de.mathema.typesystem.typesystem.TypeRef
import de.mathema.typesystem.typesystem.PrimitiveType

import static de.mathema.typesystem.types.TypeConstants.*

class TypeExtensions {

	/** Resolve a TypeRef to an Entity or null. */
	def Entity toEntity(TypeRef it){
		if( it instanceof EntityTypeRef )
			return entityType
		else 
			return null
	}
	
	/** Resolve a Type to an Entity or null. */
	def Entity toEntity(Type it){
		switch(it){
			EntityType: entity
			default : null 
		}
	}
		
	/** Resolve TypeRef to a Type */ 
	def Type toType(TypeRef it){
		switch(it){
			EntityTypeRef: new EntityType(entityType)
			PrimitiveTypeRef case primitiveType == PrimitiveType.STRING : STRING_TYPE
			PrimitiveTypeRef case primitiveType == PrimitiveType.INT : INT_TYPE
			PrimitiveTypeRef case primitiveType == PrimitiveType.FLOAT : FLOAT_TYPE
			PrimitiveTypeRef case primitiveType == PrimitiveType.BOOLEAN : BOOLEAN_TYPE
			PrimitiveTypeRef case primitiveType == PrimitiveType.DATE : DATE_TYPE
			PrimitiveTypeRef case primitiveType == PrimitiveType.TIME : TIME_TYPE
			PrimitiveTypeRef case primitiveType == PrimitiveType.TIMESTAMP : TIMESTAMP_TYPE
		}
	}
}