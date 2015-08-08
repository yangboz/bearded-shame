package info.smartkit.jreport.configs;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.mangofactory.swagger.configuration.SpringSwaggerConfig;
import com.mangofactory.swagger.plugin.EnableSwagger;
import com.mangofactory.swagger.plugin.SwaggerSpringMvcPlugin;
import com.wordnik.swagger.model.ApiInfo;

/**
 * The Class SwaggerConfig.
 */
@Configuration
@EnableSwagger
public class SwaggerConfig {
	
	private SpringSwaggerConfig springSwaggerConfig;
	
	   @Autowired
	   public void setSpringSwaggerConfig(SpringSwaggerConfig springSwaggerConfig) {
	      this.springSwaggerConfig = springSwaggerConfig;
	   }

	   @Bean //Don't forget the @Bean annotation
	   public SwaggerSpringMvcPlugin customImplementation(){
//		  AbsoluteSwaggerPathProvider pathProvider = new AbsoluteSwaggerPathProvider();
	      return new SwaggerSpringMvcPlugin(this.springSwaggerConfig)
	            .apiInfo(apiInfo())
//	            .pathProvider(pathProvider)
	            .includePatterns("/info/smartkit/jreport/.*");
	   }

	    private ApiInfo apiInfo() {
	      ApiInfo apiInfo = new ApiInfo(
	              "SMARTKIT.INFO JReport Restful API",
	              "API for SMARTKIT.INFO JReport",
	              "SMARTKIT.INFO JReport API terms of service",
	              "contact@smartkit.info",
	              "SMARTKIT.INFO JReport API Licence Type",
	              "SMARTKIT.INFO JReport API License URL"
	        );
	      return apiInfo;
	    }
	    
}
