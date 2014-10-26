package de.mathema.typesystem

import com.google.inject.Inject
import de.mathema.typesystem.typesystem.Model
import java.util.List
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.parser.ParseException
import org.eclipse.xtext.validation.CheckMode
import org.eclipse.xtext.validation.IResourceValidator
import org.eclipse.xtext.validation.Issue

class TypesystemParseHelper {
	@Inject	protected ParseHelper<Model> parseHelper
	
	@Inject private IResourceValidator validator
	
	def Model parseOrFail(CharSequence text){
		val model = parseHelper.parse(text);
		checkErrors(model)
		
		model
	}
	
	def Model parseAndResolveOrFail(CharSequence text){
		val model = parseOrFail(text)
		
		EcoreUtil.resolveAll(model)
		checkErrors(model)
		
		model
	}
	
	def Model parseResolveAndValidateOrFail(CharSequence text){
		val model = parseAndResolveOrFail(text)
		
		val issues = validate(model)
		checkErrors(issues)
		
		model
	}
	
	def List<Issue> validate(Model model){
		validator.validate(model.eResource, CheckMode.ALL, null)
	}
	
	def checkErrors(Model it){
		if( !eResource.errors.isNullOrEmpty ){
			val message = eResource.errors.map[toString].join('\n')
			throw new ParseException(message)
		}
	}
	
	def checkErrors(Iterable<Issue> issues){
		if( issues.exists[severity == Severity.ERROR] ) {
			val errors = issues.filter[severity == Severity.ERROR]
			val message = errors.map[message].join('\n')
			throw new ParseException(message)
		}
	}
}