/*
 * generated by Xtext
 */
package de.mathema.typesystem.validation

import de.mathema.typesystem.types.Type
import de.mathema.typesystem.types.TypeCalculator
import de.mathema.typesystem.types.TypeCompatibility
import de.mathema.typesystem.typesystem.CompareExpression
import de.mathema.typesystem.typesystem.EvalStatement
import de.mathema.typesystem.typesystem.Expression
import de.mathema.typesystem.typesystem.LogicalExpression
import de.mathema.typesystem.typesystem.PlusExpression
import de.mathema.typesystem.typesystem.SetStatement
import javax.inject.Inject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.validation.Check

import static de.mathema.typesystem.types.TypeConstants.*
import static de.mathema.typesystem.typesystem.TypesystemPackage.Literals.*
import de.mathema.typesystem.typesystem.MinusExpression
import de.mathema.typesystem.typesystem.MultiplyExpression
import de.mathema.typesystem.typesystem.DivideExpression

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class TypesystemValidator extends AbstractTypesystemValidator {
	public static val NO_TYPE = 'NO_TYPE' 
	public static val INCOMPATIBLE_OPERANDS = 'INCOMPATIBLE_OPERANDS'
	public static val INCOMPATIBLE_TYPES = 'INCOMPATIBLE_TYPES'

	@Inject extension TypeCalculator
	@Inject extension TypeCompatibility
	
	@Check
	def void checkCompareExpression(CompareExpression it){
		val leftType = left?.type
		val rightType = right?.type
		
		if( leftType == null || rightType == null ){
			return
		}
		
		if( !leftType.isAssignableTo(rightType) && !rightType.isAssignableTo(leftType) ){
			val msg = '''Incompatible types for operator '«op»': '«leftType.asString»' «op» '«rightType.asString»' '''
			error(msg, null, INCOMPATIBLE_OPERANDS)
		}
	}
	
	@Check
	def void checkType(Expression it){
		val actualType = type
		if( actualType == null ){ 	// If there is no result type then something is wrong!
			handleNoType
		}
		else {
			val expectedType = expectedType(eContainer, eContainingFeature)
			if( expectedType != null ){
				if( ! actualType.isAssignableTo(expectedType) ){
					val msg = '''Incompatible types: expected '«expectedType.asString»' but is actually '«actualType.asString»' '''
					error(msg, null, INCOMPATIBLE_TYPES)
				}
			}
		}
	}
	
	def private dispatch void handleNoType(Expression it){
		error('Cannot calculate type.', null, NO_TYPE)
	}
	
	def private dispatch void handleNoType(PlusExpression it){
		handleNoTypeOverloadedOperator(left, '+', right)
	}
	
	def private dispatch void handleNoType(MinusExpression it){
		handleNoTypeOverloadedOperator(left, '-', right)
	}
	
	def private dispatch void handleNoType(MultiplyExpression it){
		handleNoTypeOverloadedOperator(left, '*', right)
	}

	def private dispatch void handleNoType(DivideExpression it){
		handleNoTypeOverloadedOperator(left, '/', right)
	}
	
	def private handleNoTypeOverloadedOperator(Expression it, Expression left, String op, Expression right){		
		val leftType = left.type
		val rightType = right.type
		val msg = '''Incompatible types for operator '«op»': '«leftType.asString»' «op» '«rightType.asString»' '''
		error(msg, null, INCOMPATIBLE_OPERANDS)
	}

	// ---------- Expressions ----------
	
	def private dispatch Type expectedType(Expression container, EStructuralFeature feature){
		null
	}
	
	def private dispatch Type expectedType(LogicalExpression container, EStructuralFeature feature){
		BOOLEAN_TYPE
	}

	// ---------- Non-Expressions ----------
	
	def private dispatch Type expectedType(SetStatement container, EStructuralFeature feature){
		switch(feature){
			case SET_STATEMENT__EXPR: container.^var.type
		}
	}
	
	def private dispatch Type expectedType(EvalStatement container, EStructuralFeature feature){
		ANY_TYPE
	}
}
