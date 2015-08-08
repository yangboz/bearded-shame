/*
 * Copyright 2015 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * All rights reserved.
 */
package info.smartkit.jreport;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.PropertySources;

/**
 * @see: https://spring.io/guides/gs/actuator-service/
 * @author yangboz
 */
@PropertySources({ @PropertySource(value = "classpath:application-${spring.profiles.active}.properties") })
@SpringBootApplication
public class Application
{
    public static void main(String[] args)
    {
        SpringApplication.run(Application.class, args);
        //
        // System.setProperty("javax.xml.parsers.SAXParserFactory", "org.apache.crimson.parser.XMLReaderImpl");
        // System.setProperty("javax.xml.parsers.SAXParserFactory",
        // "com.sun.org.apache.xerces.internal.jaxp.SAXParserFactoryImpl");
        //
        // System.setProperty("javax.xml.parsers.SAXParserFactory", "org.apache.xerces.jaxp.SAXParserFactoryImpl");
        System.setProperty("org.xml.sax.driver", "org.apache.xerces.parsers.SAXParser");
    }
}
