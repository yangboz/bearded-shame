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
package info.smartkit.jreport.jrxml.demo.pojo;

/**
 * Contents of POJO file.
 * 
 * @author yangboz
 */
public class DataBean
{
    private String name;

    private String country;

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getCountry()
    {
        return country;
    }

    public void setCountry(String country)
    {
        this.country = country;
    }

    private long id;

    public long getId()
    {
        return id;
    }

    public void setId(long id)
    {
        this.id = id;
    }

    private String expenses_owner;

    public String getExpenses_owner()
    {
        return expenses_owner;
    }

    public void setExpenses_owner(String expenses_owner)
    {
        this.expenses_owner = expenses_owner;
    }

    private String expenses_name;

    public String getExpenses_name()
    {
        return expenses_name;
    }

    public void setExpenses_name(String expenses_name)
    {
        this.expenses_name = expenses_name;
    }

    private String expenses_date;

    public String getExpenses_date()
    {
        return expenses_date;
    }

    public void setExpenses_date(String expenses_date)
    {
        this.expenses_date = expenses_date;
    }

}
