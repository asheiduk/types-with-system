package de.mathema.typesystem

import com.google.inject.Inject
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(TypesystemInjectorProvider))
class TypecheckTest {
	
	@Inject extension TypesystemParseHelper
	
	def void checkOk(String s){
		parseResolveAndValidateOrFail(s)
	}
	
	def void checkFail(String s){
		val model = parseAndResolveOrFail(s)
		val issues = model.validate
		
		Assert.assertTrue(issues.exists[severity == Severity.ERROR])
	}
	
	@Test def void testEntityAssignment(){
		val preabmle = '''
			entity Person {}
			entity Address {}
			declare Person p
			declare Address a
		'''
		checkOk('''«preabmle» set p = p''')
		checkOk('''«preabmle» set a = a''')
		checkFail('''«preabmle» set p = a''')
	}
	
	@Test def void testPrimitiveAssignment(){
		val preamble = '''
			declare string str
			declare float  flt
			declare int    i
		'''
		
		checkOk('''«preamble» set str = str''')
		checkOk('''«preamble» set str = "foo"''')
		
		// no coercion to string
		checkFail('''«preamble» set str = 42''')
		checkFail('''«preamble» set str = 42.42''')
		checkFail('''«preamble» set str = true''')
		checkFail('''«preamble» set str = 24.12.2014''')
		checkFail('''«preamble» set str = 20:00''')
		checkFail('''«preamble» set str = 24.12.2014 20:00''')
		
		checkOk('''«preamble» set flt = flt''')
		checkOk('''«preamble» set flt = 42.42''')
		checkOk('''«preamble» set flt = 42''')	// coercion int to float
		checkFail('''«preamble» set flt = "42"''') 
		
		checkOk('''«preamble» set i = i''')
		checkOk('''«preamble» set i = 42''')
		checkFail('''«preamble» set i = 42.42''')	// no coercion float to int
	}
	
	@Test def void testBooleanResult(){
		val preamble = '''
			declare boolean flag
			set flag = 
		'''
		checkOk('''«preamble» true''')
		checkOk('''«preamble» true and true''')
		checkOk('''«preamble» true or true''')
		
		checkOk('''«preamble» "foo" == "foo"''')	// same type
		checkOk('''«preamble» "foo" < "foo"''')
		checkOk('''«preamble» "foo" > "foo"''')
		
		checkOk('''«preamble» "foo" > "foo"''')
		
		checkOk('''«preamble» 42 == 42.42''')
		checkOk('''«preamble» 42.42 == 42''')
		
		checkFail('''«preamble» 42 == "42"''')
	}
	
	@Test def void testMulti(){
		val preamble = '''
			declare int i
			declare float f
			set 
		'''
		checkOk('''«preamble» i = i * i''')
		checkFail('''«preamble» i = i * f''')	// i*f->float which is not assignable to int
		checkFail('''«preamble» i = f * i''')	// i*f->float which is not assignable to int
		checkFail('''«preamble» i = f * f''')	// i*f->float which is not assignable to int
		
		checkOk('''«preamble» f = i * i''')
		checkOk('''«preamble» f = i * f''')
		checkOk('''«preamble» f = f * i''')
		checkOk('''«preamble» f = f * f''')
		
	}
	
}
