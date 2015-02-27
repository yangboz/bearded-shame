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

import java.util.ArrayList;

/**
 * Contents of POJO list.
 * 
 * @author yangboz
 */
public class DataBeanList
{
    public ArrayList<DataBean> getDataBeanList()
    {
        ArrayList<DataBean> dataBeanList = new ArrayList<DataBean>();

        dataBeanList.add(produce("Manisha", "中国", 112233, "AA", "2012-05-07", "吃吃喝喝"));
        dataBeanList.add(produce("Dennis Ritchie", "한국", 456, "BB", "2012-05-07", "吃吃喝喝"));
        dataBeanList.add(produce("V.Anand", "India", 789, "CC", "2012-05-07", "吃吃喝喝"));
        dataBeanList.add(produce("Shrinath", "California", 123456, "DD", "2012-05-07", "吃吃喝喝"));

        return dataBeanList;
    }

    /**
     * This method returns a DataBean object, with name and country set in it.
     */
    private DataBean produce(String name, String country, long id, String expenses_owner, String expenses_date,
        String expenses_name)
    {
        DataBean dataBean = new DataBean();
        dataBean.setName(name);
        dataBean.setCountry(country);
        dataBean.setId(id);
        //
        dataBean.setExpenses_owner(expenses_owner);
        dataBean.setExpenses_name(expenses_name);
        dataBean.setExpenses_date(expenses_date);
        return dataBean;
    }
}
