CREATE OR REPLACE PROCEDURE get_branch_summary(v_beginDate in Date, v_endDate in Date) as
begin
    DECLARE type curtyp is ref cursor;
    writeProjectCur  curtyp;
    interpretProjectCur  curtyp;
    companyIncomeCur curtyp;
    companyExpenditureCur curtyp;
    companyTotalIncomeCur curtyp;
    companyTotalExpenditureCur curtyp;
    
    
    v_userid number;
    v_companyName varchar2(50);
    v_income number(18,3);
    v_expenditure number(18,3);
    v_Profit number(18,3);
    v_count number;
    

    v_sqlcode Varchar(10);
    v_sqlerrm Varchar(1000);
begin
    EXECUTE IMMEDIATE 'TRUNCATE TABLE report_branch_summary';
    COMMIT;

    open writeProjectCur for select round(income,2),round(expenditure,2),sales from tp_write_project
         where status=581 and endDate>v_beginDate and endDate<v_endDate;
       loop
            fetch writeProjectCur into v_income,v_expenditure,v_userid;
            exit when writeProjectCur%notfound;

            select count(*) into v_count from report_branch_summary where typename like '%笔译收入(元)' and companyname = get_branch_company(v_userid);
            if v_count=0 then
              insert into report_branch_summary(typename,companyname,breaks)
                     values('1笔译收入(元)',get_branch_company(v_userid),v_income);
            else
              update report_branch_summary set breaks=(breaks+v_income) where typename like '%笔译收入(元)' and companyname = get_branch_company(v_userid);
            end if;

            select count(*) into v_count from report_branch_summary where typename like '%笔译支出(元)' and companyname = get_branch_company(v_userid);
            if v_count=0 then
              insert into report_branch_summary(typename,companyname,breaks)
                     values('2笔译支出(元)',get_branch_company(v_userid),v_expenditure);
            else
              update report_branch_summary set breaks=(breaks+v_expenditure) where typename like '%笔译支出(元)' and companyname = get_branch_company(v_userid);
            end if;

       end loop;
     close writeProjectCur;

     open interpretProjectCur for select round(deviceincome+income,2),
                                         round(deviceexpense+expenditure,2),sales from tp_interpret_project
                                  where status=1029 and endDate>v_beginDate and endDate<v_endDate;
       loop
            fetch interpretProjectCur into v_income,v_expenditure,v_userid;
            exit when interpretProjectCur%notfound;

            select count(*) into v_count from report_branch_summary where typename like '%口译收入(元)' and companyname = get_branch_company(v_userid);
            if v_count=0 then
              insert into report_branch_summary(typename,companyname,breaks)
                     values('3口译收入(元)',get_branch_company(v_userid),v_income);
            else
              update report_branch_summary set breaks=(breaks+v_income) where typename like '%口译收入(元)' and companyname = get_branch_company(v_userid);
            end if;

            select count(*) into v_count from report_branch_summary where typename like '%口译支出(元)' and companyname = get_branch_company(v_userid);
            if v_count=0 then
              insert into report_branch_summary(typename,companyname,breaks)
                     values('4口译支出(元)',get_branch_company(v_userid),v_expenditure);
            else
              update report_branch_summary set breaks=(breaks+v_expenditure) where typename like '%口译支出(元)' and companyname = get_branch_company(v_userid);
            end if;

       end loop;
     close interpretProjectCur;

     open companyIncomeCur for select companyname,sum(breaks) from report_branch_summary where typename like '%译收入(元)' group by companyname;
       loop
            fetch companyIncomeCur into v_companyName,v_income;
            exit when companyIncomeCur%notfound;

            insert into report_branch_summary(typename,companyname,breaks) values('5分公司总收入(元)',v_companyName,v_income);

       end loop;
     close companyIncomeCur;

     open companyExpenditureCur for select companyname,sum(breaks) from report_branch_summary where typename like '%译支出(元)' group by companyname;
       loop
            fetch companyExpenditureCur into v_companyName,v_expenditure;
            exit when companyExpenditureCur%notfound;

            insert into report_branch_summary(typename,companyname,breaks) values('6分公司总支出(元)',v_companyName,v_expenditure);

       end loop;
     close companyExpenditureCur;

     open companyTotalIncomeCur for select companyname,breaks from report_branch_summary where typename like '%分公司总收入(元)';
       loop
            fetch companyTotalIncomeCur into v_companyName,v_income;
            exit when companyTotalIncomeCur%notfound;
            
            select breaks into v_expenditure from report_branch_summary 
                   where typename like '%分公司总支出(元)' and companyname=v_companyName;

            insert into report_branch_summary(typename,companyname,breaks) values('7利润(元)',v_companyName,v_income-v_expenditure);
       end loop;
     close companyTotalIncomeCur;

     open companyTotalExpenditureCur for select companyname,breaks from report_branch_summary where typename like '%分公司总收入(元)';
       loop
            fetch companyTotalExpenditureCur into v_companyName,v_income;
            exit when companyTotalExpenditureCur%notfound;
            
            select breaks into v_Profit from report_branch_summary 
                   where typename like '%利润(元)' and companyname=v_companyName;
            
            if v_income<>0 then
              insert into report_branch_summary(typename,companyname,breaks) values('8利润率(%)',v_companyName,round(v_Profit/v_income*100,2));
            end if;
       end loop;
     close companyTotalExpenditureCur;

     select sum(breaks) into v_Profit from report_branch_summary where typename like '%利润(元)';
     select sum(breaks) into v_income from report_branch_summary where typename like '%分公司总收入(元)';
     if v_income<>0 then
        update report_branch_summary set totalprofitmargin=round(v_Profit/v_income*100,2);
     end if;

    commit;

    EXCEPTION
        WHEN OTHERS THEN
        rollback;
        v_sqlcode:=Sqlcode;
        v_sqlerrm:=Sqlerrm;
        Insert Into wErrorLog Values('get_branch_summary ERROR','写日志表错误',v_sqlcode,v_sqlerrm,Sysdate);
        commit;
        RETURN;
end;
end get_branch_summary;
/
CREATE OR REPLACE PROCEDURE GET_INTERPROJECT_FL_SUMMARY(v_beginDate in Date, v_endDate in Date) as
begin
    DECLARE type curtyp is ref cursor;
    projectCur  curtyp;
    v_language varchar2(20);
    v_totalincome varchar2(20);
    v_totalexpenditure varchar2(20);
    v_profit varchar2(20);
    v_profitMargin number(18,3);
    v_projectNum number(18,3);
    
    v_total_profit number(18,3);
    v_total_projectNum number(18,3);

    v_sqlcode Varchar(10);
    v_sqlerrm Varchar(1000);
begin
    EXECUTE IMMEDIATE 'TRUNCATE TABLE report_language_summary';
    COMMIT;
    
    select case when (sum(twp.deviceincome)+sum(twp.income))=0 then 0 else round((sum(twp.deviceincome)+sum(twp.income))-(sum(twp.deviceexpense)+sum(twp.expenditure)),2) end as profitMargin,
           count(twp.id)
    into v_total_profit,v_total_projectNum
    from tp_interpret_project twp
    where twp.status=1029 and endDate>v_beginDate and endDate<v_endDate;

    open projectCur for
        select dic.itemvalue as language,
            FORMAT_NUM(sum(tp.deviceincome)+sum(tp.income)) as income,
            FORMAT_NUM(sum(tp.deviceexpense)+sum(tp.expenditure)) as expenditure,
            FORMAT_NUM((sum(tp.deviceincome)+sum(tp.income))-(sum(tp.deviceexpense)+sum(tp.expenditure))) as profit,
            case when (sum(tp.deviceincome)+sum(tp.income))=0 then 0 else round(((sum(tp.deviceincome)+sum(tp.income))-(sum(tp.deviceexpense)+sum(tp.expenditure)))/(sum(tp.deviceincome)+sum(tp.income))*100,2) end as profitMargin,
            count(tp.id) as projectsum 
        from dictionary dic
        right join tp_interpret_project tp on tp.fromlanguage=dic.dicid
        where tp.status=1029 and endDate>v_beginDate and endDate<v_endDate
        group by dic.itemvalue;
        loop
            fetch projectCur into v_language,v_totalincome,v_totalexpenditure,v_profit,v_profitMargin,v_projectNum;
            exit when projectCur%notfound;
            
            insert into report_language_summary(language,totalincome,totalexpenditure,profit,profitMargin,projectNum,profitpercent,projectpercent)
            values(v_language,v_totalincome,v_totalexpenditure,v_profit,v_profitMargin,v_projectNum,round(v_profit/v_total_profit*100,2),round(v_projectNum/v_total_projectNum*100,2));

        end loop;
     close projectCur;

    commit;

    EXCEPTION
        WHEN OTHERS THEN
        rollback;
        v_sqlcode:=Sqlcode;
        v_sqlerrm:=Sqlerrm;
        Insert Into wErrorLog Values('GET_INTERPROJECT_FL_SUMMARY ERROR','写日志表错误',v_sqlcode,v_sqlerrm,Sysdate);
        commit;
        RETURN;
end;
end GET_INTERPROJECT_FL_SUMMARY;
/
CREATE OR REPLACE PROCEDURE GET_INTERPROJECT_TL_SUMMARY(v_beginDate in Date, v_endDate in Date) as
begin
    DECLARE type curtyp is ref cursor;
    projectCur  curtyp;
    v_language varchar2(20);
    v_totalincome varchar2(20);
    v_totalexpenditure varchar2(20);
    v_profit varchar2(20);
    v_profitMargin number(18,3);
    v_projectNum number(18,3);
    
    v_total_profit number(18,3);
    v_total_projectNum number(18,3);

    v_sqlcode Varchar(10);
    v_sqlerrm Varchar(1000);
begin
    EXECUTE IMMEDIATE 'TRUNCATE TABLE report_language_summary';
    COMMIT;
    
    select case when (sum(twp.deviceincome)+sum(twp.income))=0 then 0 
           else round((sum(twp.deviceincome)+sum(twp.income))-(sum(twp.deviceexpense)+sum(twp.expenditure)),2) end as profitMargin,
           count(twp.id)
    into v_total_profit,v_total_projectNum
    from tp_interpret_project twp
    where twp.status=1029 and endDate>v_beginDate and endDate<v_endDate;

    open projectCur for
        select dic.itemvalue as language,
            FORMAT_NUM(sum(tp.deviceincome)+sum(tp.income)) as income,
            FORMAT_NUM(sum(tp.deviceexpense)+sum(tp.expenditure)) as expenditure,
            FORMAT_NUM((sum(tp.deviceincome)+sum(tp.income))-(sum(tp.deviceexpense)+sum(tp.expenditure))) as profit,
            case when (sum(tp.deviceincome)+sum(tp.income))=0 then 0 else round(((sum(tp.deviceincome)+sum(tp.income))-(sum(tp.deviceexpense)+sum(tp.expenditure)))/(sum(tp.deviceincome)+sum(tp.income))*100,2) end as profitMargin,
            count(tp.id) as projectsum 
        from dictionary dic
        right join tp_interpret_project tp on tp.tolanguage=dic.dicid
        where tp.status=1029 and endDate>v_beginDate and endDate<v_endDate
        group by dic.itemvalue;
        loop
            fetch projectCur into v_language,v_totalincome,v_totalexpenditure,v_profit,v_profitMargin,v_projectNum;
            exit when projectCur%notfound;
            
            insert into report_language_summary(language,totalincome,totalexpenditure,profit,profitMargin,projectNum,profitpercent,projectpercent)
            values(v_language,v_totalincome,v_totalexpenditure,v_profit,v_profitMargin,v_projectNum,round(v_profit/v_total_profit*100,2),round(v_projectNum/v_total_projectNum*100,2));

        end loop;
     close projectCur;

    commit;

    EXCEPTION
        WHEN OTHERS THEN
        rollback;
        v_sqlcode:=Sqlcode;
        v_sqlerrm:=Sqlerrm;
        Insert Into wErrorLog Values('GET_INTERPROJECT_TL_SUMMARY ERROR','写日志表错误',v_sqlcode,v_sqlerrm,Sysdate);
        commit;
        RETURN;
end;
end GET_INTERPROJECT_TL_SUMMARY;
/
CREATE OR REPLACE PROCEDURE get_project_summary(v_beginDate in Date, v_endDate in Date) as
begin
    declare
    write_total_income NUMBER(18,3);
    write_total_expenditure NUMBER(18,3);
    write_profit NUMBER(18,3);
    write_profitMargin NUMBER(18,3);
    interpret_total_income NUMBER(18,3);
    interpret_total_expenditure NUMBER(18,3);
    interpret_profit NUMBER(18,3);
    interpret_profitMargin NUMBER(18,3);
begin
    EXECUTE IMMEDIATE 'TRUNCATE TABLE report_project_summary';
    COMMIT;
    
    select round(sum(income),2),
           round(sum(expenditure),2), 
           round((sum(income)-sum(expenditure)),2),
           case when sum(income)=0 then 0 else round((sum(income)-sum(expenditure))/sum(income)*100, 2) end
    into write_total_income,write_total_expenditure,write_profit,write_profitMargin
    from tp_write_project 
    where status=581 and endDate>v_beginDate and endDate<v_endDate;
    
    select round(sum(deviceincome)+sum(income),2),
           round(sum(deviceexpense)+sum(expenditure),2), 
           round(((sum(deviceincome)+sum(income))-(sum(deviceexpense)+sum(expenditure))),2),
           case when sum(deviceincome)+sum(income)=0 then 0 
             else round(((sum(deviceincome)+sum(income))-(sum(deviceexpense)+sum(expenditure)))/(sum(deviceincome)+sum(income))*100, 2) end
    into interpret_total_income,interpret_total_expenditure,interpret_profit,interpret_profitMargin
    from tp_interpret_project 
    where status=1029 and endDate>v_beginDate and endDate<v_endDate;
    
    insert into report_project_summary(writetotalincome, writetotalexpenditure,writeprofit,
                                writeprofitMargin,interprettotalincome,interprettotalexpenditure,
                                interpretprofit,interpretprofitMargin)
    values(write_total_income,write_total_expenditure,write_profit,write_profitMargin,
           interpret_total_income,interpret_total_expenditure,interpret_profit,interpret_profitMargin);
    
    commit;
end;
end get_project_summary;
/
CREATE OR REPLACE PROCEDURE GET_WRITEPROJECT_FL_SUMMARY(v_beginDate in Date, v_endDate in Date) as
begin
    DECLARE type curtyp is ref cursor;
    projectCur  curtyp;
    v_language varchar2(20);
    v_totalincome varchar2(20);
    v_totalexpenditure varchar2(20);
    v_profit varchar2(20);
    v_profitMargin number(18,3);
    v_projectNum number(18,3);
    
    v_total_profit number(18,3);
    v_total_projectNum number(18,3);

    v_sqlcode Varchar(10);
    v_sqlerrm Varchar(1000);
begin
    EXECUTE IMMEDIATE 'TRUNCATE TABLE report_language_summary';
    COMMIT;
    
    select case when sum(twp.income)=0 then 0 else round(sum(twp.income)-sum(twp.expenditure),2) end as profitMargin,
           count(twp.id)
    into v_total_profit,v_total_projectNum
    from tp_write_project twp
    where twp.status=581 and endDate>v_beginDate and endDate<v_endDate;

    open projectCur for
        select dic.itemvalue as language,
            FORMAT_NUM(sum(tp.income)) as income,
            FORMAT_NUM(sum(tp.expenditure)) as expenditure,
            FORMAT_NUM(sum(tp.income)-sum(tp.expenditure)) as profit,
            case when sum(tp.income)=0 then 0 else round((sum(tp.income)-sum(tp.expenditure))/sum(tp.income)*100,2) end as profitMargin,
            count(tp.id) as projectsum 
        from dictionary dic
        right join tp_write_project tp on tp.fromlanguage=dic.dicid
        where tp.status=581 and endDate>v_beginDate and endDate<v_endDate
        group by dic.itemvalue;
        loop
            fetch projectCur into v_language,v_totalincome,v_totalexpenditure,v_profit,v_profitMargin,v_projectNum;
            exit when projectCur%notfound;
            
            insert into report_language_summary(language,totalincome,totalexpenditure,profit,profitMargin,projectNum,profitpercent,projectpercent)
            values(v_language,v_totalincome,v_totalexpenditure,v_profit,v_profitMargin,v_projectNum,round(v_profit/v_total_profit*100,2),round(v_projectNum/v_total_projectNum*100,2));

        end loop;
     close projectCur;

    commit;

    EXCEPTION
        WHEN OTHERS THEN
        rollback;
        v_sqlcode:=Sqlcode;
        v_sqlerrm:=Sqlerrm;
        Insert Into wErrorLog Values('GET_WRITEPROJECT_FL_SUMMARY ERROR','写日志表错误',v_sqlcode,v_sqlerrm,Sysdate);
        commit;
        RETURN;
end;
end GET_WRITEPROJECT_FL_SUMMARY;
/
CREATE OR REPLACE PROCEDURE GET_WRITEPROJECT_TL_SUMMARY(v_beginDate in Date, v_endDate in Date) as
begin
    DECLARE type curtyp is ref cursor;
    projectCur  curtyp;
    v_language varchar2(20);
    v_totalincome varchar2(20);
    v_totalexpenditure varchar2(20);
    v_profit varchar2(20);
    v_profitMargin number(18,3);
    v_projectNum number(18,3);
    
    v_total_profit number(18,3);
    v_total_projectNum number(18,3);

    v_sqlcode Varchar(10);
    v_sqlerrm Varchar(1000);
begin
    EXECUTE IMMEDIATE 'TRUNCATE TABLE report_language_summary';
    COMMIT;
    
    select case when sum(twp.income)=0 then 0 else round(sum(twp.income)-sum(twp.expenditure),2) end as profitMargin,
           count(twp.id)
    into v_total_profit,v_total_projectNum
    from tp_write_project twp
    where twp.status=581 and endDate>v_beginDate and endDate<v_endDate;

    open projectCur for
        select dic.itemvalue as language,
            FORMAT_NUM(sum(tp.income)) as income,
            FORMAT_NUM(sum(tp.expenditure)) as expenditure,
            FORMAT_NUM(sum(tp.income)-sum(tp.expenditure)) as profit,
            case when sum(tp.income)=0 then 0 else round((sum(tp.income)-sum(tp.expenditure))/sum(tp.income)*100,2) end as profitMargin,
            count(tp.id) as projectsum 
        from dictionary dic
        right join tp_write_project tp on tp.tolanguage=dic.dicid
        where tp.status=581 and endDate>v_beginDate and endDate<v_endDate
        group by dic.itemvalue;
        loop
            fetch projectCur into v_language,v_totalincome,v_totalexpenditure,v_profit,v_profitMargin,v_projectNum;
            exit when projectCur%notfound;
            
            insert into report_language_summary(language,totalincome,totalexpenditure,profit,profitMargin,projectNum,profitpercent,projectpercent)
            values(v_language,v_totalincome,v_totalexpenditure,v_profit,v_profitMargin,v_projectNum,round(v_profit/v_total_profit*100,2),round(v_projectNum/v_total_projectNum*100,2));

        end loop;
     close projectCur;

    commit;

    EXCEPTION
        WHEN OTHERS THEN
        rollback;
        v_sqlcode:=Sqlcode;
        v_sqlerrm:=Sqlerrm;
        Insert Into wErrorLog Values('GET_WRITEPROJECT_TL_SUMMARY ERROR','写日志表错误',v_sqlcode,v_sqlerrm,Sysdate);
        commit;
        RETURN;
end;
end GET_WRITEPROJECT_TL_SUMMARY;
/
