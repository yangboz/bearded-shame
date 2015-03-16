drop table branch_summary;
/
CREATE GLOBAL TEMPORARY TABLE report_branch_summary(
    typename varchar2(50),
    companyname varchar2(18),
    breaks number(18,3),
    totalprofitmargin number(18,3)
) ON COMMIT PRESERVE ROWS
/
drop type branch_summary_TYPE_TABLE;
/
CREATE OR REPLACE TYPE branch_summary_TYPE AS OBJECT(
    typename varchar2(50),
    companyname varchar2(18),
    breaks number(18,3),
    totalprofitmargin number(18,3)
)
/
CREATE OR REPLACE TYPE branch_summary_TYPE_TABLE AS TABLE OF branch_summary_TYPE;
/
drop table project_summary;
/
CREATE GLOBAL TEMPORARY TABLE report_project_summary(
    writetotalincome varchar2(18),
    writetotalexpenditure varchar2(18),
    writeprofit varchar2(18),
    writeprofitMargin varchar2(18),
    interprettotalincome varchar2(18),
    interprettotalexpenditure varchar2(18),
    interpretprofit varchar2(18),
    interpretprofitMargin varchar2(18)
) ON COMMIT PRESERVE ROWS
/
drop type PROJECT_TYPE_TABLE;
/
CREATE OR REPLACE TYPE PROJECT_TYPE AS OBJECT(
    writetotalincome varchar2(18),
    writetotalexpenditure varchar2(18),
    writeprofit varchar2(18),
    writeprofitMargin varchar2(18),
    interprettotalincome varchar2(18),
    interprettotalexpenditure varchar2(18),
    interpretprofit varchar2(18),
    interpretprofitMargin varchar2(18)
)
/
CREATE OR REPLACE TYPE PROJECT_TYPE_TABLE AS TABLE OF PROJECT_TYPE;
/
drop table w_project_language_summary;
/
CREATE GLOBAL TEMPORARY TABLE report_language_summary(
    language varchar2(20),
    totalincome varchar2(18),
    totalexpenditure varchar2(18),
    profit varchar2(18),
    profitMargin number(18,3),
    projectNum number(18,3),
    profitpercent number(18,3),
    projectpercent number(18,3)
) ON COMMIT PRESERVE ROWS
/
drop type W_PROJECT_F_TYPE_TABLE;
/
CREATE OR REPLACE TYPE W_PROJECT_LANGUAGE_TYPE AS OBJECT(
    language varchar2(20),
    totalincome varchar2(18),
    totalexpenditure varchar2(18),
    profit varchar2(18),
    profitMargin number(18,3),
    projectNum number(18,3),
    profitpercent number(18,3),
    projectpercent number(18,3)
)
/
CREATE OR REPLACE TYPE W_PROJECT_F_TYPE_TABLE AS TABLE OF W_PROJECT_LANGUAGE_TYPE;
/
