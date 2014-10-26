package de.mathema.typesystem.types

import de.mathema.typesystem.typesystem.Entity

@Data class Type {
	val String asString
}

/** special catch-all type */
@Data class AnyType extends Type {}

@Data class PrimitiveType extends Type {}

@Data class StringType extends PrimitiveType {} 
@Data class IntType extends PrimitiveType {}
@Data class FloatType extends PrimitiveType {}
@Data class BooleanType extends PrimitiveType {}
@Data class DateType extends PrimitiveType {}
@Data class TimeType extends PrimitiveType {}
@Data class TimestampType extends PrimitiveType {}

@Data class EntityType extends Type {
	val Entity entity
	new(Entity entity){
		super("entity<"+entity.name+">")
		this._entity = entity
	}
}
