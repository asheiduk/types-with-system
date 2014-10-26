package de.mathema.typesystem.types

import de.mathema.typesystem.typesystem.BooleanLiteral
import de.mathema.typesystem.typesystem.CompareExpression
import de.mathema.typesystem.typesystem.DateLiteral
import de.mathema.typesystem.typesystem.DivideExpression
import de.mathema.typesystem.typesystem.Expression
import de.mathema.typesystem.typesystem.FloatLiteral
import de.mathema.typesystem.typesystem.IntLiteral
import de.mathema.typesystem.typesystem.LValueRefChain
import de.mathema.typesystem.typesystem.LogicalExpression
import de.mathema.typesystem.typesystem.MinusExpression
import de.mathema.typesystem.typesystem.MultiplyExpression
import de.mathema.typesystem.typesystem.PlusExpression
import de.mathema.typesystem.typesystem.StringLiteral
import de.mathema.typesystem.typesystem.TimeLiteral
import de.mathema.typesystem.typesystem.TimestampLiteral
import de.mathema.typesystem.typesystem.VariableDefinitionRef
import javax.inject.Inject
import javax.inject.Singleton

import static de.mathema.typesystem.types.TypeConstants.*

@Singleton
class TypeCalculator {
	
	@Inject extension TypeExtensions
	
	BinaryOperatorTable plusTable = new BinaryOperatorTable => [
		// every primitive can be appended to a string - commutative as in Java
		put(STRING_TYPE, STRING_TYPE, STRING_TYPE)
		putCommutative(STRING_TYPE, INT_TYPE, STRING_TYPE)
		putCommutative(STRING_TYPE, FLOAT_TYPE, STRING_TYPE)
		putCommutative(STRING_TYPE, BOOLEAN_TYPE, STRING_TYPE)
		putCommutative(STRING_TYPE, DATE_TYPE, STRING_TYPE)
		putCommutative(STRING_TYPE, TIME_TYPE, STRING_TYPE)
		putCommutative(STRING_TYPE, TIMESTAMP_TYPE, STRING_TYPE)
		
		// numbers
		put(INT_TYPE, INT_TYPE, INT_TYPE)
		put(FLOAT_TYPE, FLOAT_TYPE, FLOAT_TYPE)
		putCommutative(FLOAT_TYPE, INT_TYPE, FLOAT_TYPE)
		
		// chrono-stuff
		putCommutative(DATE_TYPE, TIME_TYPE, TIMESTAMP_TYPE)
	]
	
	BinaryOperatorTable minusMultDivTable = new BinaryOperatorTable => [
		// numbers
		put(INT_TYPE, INT_TYPE, INT_TYPE)
		put(FLOAT_TYPE, FLOAT_TYPE, FLOAT_TYPE)
		putCommutative(FLOAT_TYPE, INT_TYPE, FLOAT_TYPE)
	]
	
	// ---------- Binary Expressions ----------
	
	def dispatch getType(LogicalExpression it){
		BOOLEAN_TYPE
	}
	
	def dispatch getType(CompareExpression it){
		BOOLEAN_TYPE
	}
	
	def dispatch getType(PlusExpression it){
		handleOverloadedOperator(plusTable, left, right)
	}
	
	def dispatch getType(MinusExpression it){
		handleOverloadedOperator(minusMultDivTable, left, right)
	}
	
	def dispatch getType(MultiplyExpression it){
		handleOverloadedOperator(minusMultDivTable, left, right)
	}
	
	def dispatch getType(DivideExpression it){
		handleOverloadedOperator(minusMultDivTable, left, right)
	}
	
	def private Type handleOverloadedOperator(BinaryOperatorTable operatorTable, Expression left, Expression right){
		val leftType = left.type
		val rightType = right.type
		operatorTable.get(leftType, rightType)
	}
	
	// ---------- Literals ---------- 
	
	def dispatch getType(StringLiteral it){
		return STRING_TYPE
	}
	
	def dispatch getType(IntLiteral it){
		return INT_TYPE
	}
	
	def dispatch getType(FloatLiteral it){
		return FLOAT_TYPE
	}
	
	def dispatch getType(BooleanLiteral it){
		return BOOLEAN_TYPE
	}
	
	def dispatch getType(DateLiteral it){
		return DATE_TYPE
	}
	
	def dispatch getType(TimeLiteral it){
		return TIME_TYPE
	}
	
	def dispatch getType(TimestampLiteral it){
		return TIMESTAMP_TYPE
	}
	
	// ---------- Variable & Attributes, link to non-expressions ----------
	
	def dispatch getType(LValueRefChain it){
		right?.type?.toType
	}
	
	def dispatch getType(VariableDefinitionRef it){
		ref?.type?.toType
	}
}
