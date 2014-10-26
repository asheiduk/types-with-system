package de.mathema.typesystem

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(TypesystemInjectorProvider))
class EntityParsingTest {
	
	@Inject extension TypesystemParseHelper
	
	@Test
	def void testNothing(){
		parseAndResolveOrFail('''
			'''
		)
	}
	
	@Test
	def void testPerson(){
		parseOrFail('''
			entity Person {
				string firstName
				string lastName
				
				int numberOfAccounts
				boolean isCustomer
				float	trustFactor
				
				date birthday
				time preferedLunchTime
				timestamp firstContact
				
				Address	homeAddress
			}
			'''
		)
	}
	
	@Test
	def void testPersonAndAddress(){
		parseAndResolveOrFail('''
			entity Person {
				string firstName
				string lastName
				
				Address	homeAddress
			}
			
			entity Address {
				string street
				string city
				string postalCode
				string country
			}
			'''
		)
	}
	
	@Test
	def void testEvaluateLiterals(){
		parseAndResolveOrFail('''
			eval true
			eval false
			eval "foo"
			eval 42
			eval 42.42
			eval 12:00
			eval 24.12.2014
			eval 24.12.2014 12:00
		''')
	}
	
	@Test
	def void testDeclareAndSetPrimitives(){
		parseAndResolveOrFail('''
			declare string name
			declare boolean flag
			declare float factor
			declare int	count
			declare date birthday
			declare time lunchTime
			declare timestamp christmas
		''')
	}
	
	@Test 
	def void testDeclareEntity(){
		parseAndResolveOrFail('''
			entity Person {
				string name
			}
			
			declare Person p
		''')
	}
	
	@Test 
	def void testSetLiterals(){
		parseAndResolveOrFail('''
			declare string name
			declare boolean flag
			declare float factor
			declare int	count
			declare date birthday
			declare time lunchTime
			declare timestamp christmas
			
			set name = "foo"
			set flag = true
			set factor = 42.42
			set count = 42
			set birthday = 24.12.2014
			set lunchTime = 12:00
			set christmas = 24.12.2014 17:00
		''')
	}
	
	@Test
	def void testSetAttribute(){
		
		parseAndResolveOrFail('''
			entity Person {
				string firstName
				
				Address	homeAddress
			}
			
			entity Address {
				string street
			}
			
			declare Person p
			declare Address a
			
			set p = p
			set p.firstName = "foo"
			set p.homeAddress = a
			set p.homeAddress.street = "foo"
			'''
		)
	}
	
	@Test
	def void testExpression(){
		parseAndResolveOrFail('''
			eval true and 42 or "foo"
			eval true + false - true
			eval true * true / true
			eval 1 + (2 + 3) + (4)
		''')
	}
}
