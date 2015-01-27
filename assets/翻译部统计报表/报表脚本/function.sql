CREATE OR REPLACE FUNCTION FORMAT_NUM(VAL VARCHAR)
       RETURN VARCHAR IS RESULT VARCHAR(50);
BEGIN
  SELECT decode(Instr(VAL,'.'),0,TO_CHAR(VAL,'FM999999990.90'),to_char(VAL,'FM999999990.90')) INTO RESULT FROM DUAL;
  RETURN RESULT;
END;
/
create or replace function Get_StrArrayStrOfIndex
(
  av_str varchar2,  --要分割的字符串
  av_split varchar2,  --分隔符号
  av_index number --取第几个元素
)
return varchar2
is
  lv_str varchar2(1024);
  lv_strOfIndex varchar2(1024);
  lv_length number;
begin
  lv_str:=ltrim(rtrim(av_str));
  lv_str:=concat(lv_str,av_split);
  lv_length:=av_index;
  if lv_length=0 then
      lv_strOfIndex:=substr(lv_str,1,instr(lv_str,av_split)-length(av_split));
  else
      lv_length:=av_index+1;
      lv_strOfIndex:=substr(lv_str,instr(lv_str,av_split,1,av_index)+length(av_split),instr(lv_str,av_split,1,lv_length)-instr(lv_str,av_split,1,av_index)-length(av_split));
  end if;
  return  lv_strOfIndex;
end Get_StrArrayStrOfIndex;
/
CREATE OR REPLACE FUNCTION get_branch_company(v_userid number)
RETURN VARCHAR2 IS 
v_depname VARCHAR(50);
v_depid number(18);
v_deppath varchar2(20);
v_deptype varchar2(5);
BEGIN
  select depid into v_depid from app_user where userid=v_userid;
  select path into v_deppath from department where depid=v_depid;
  select deptype into v_deptype from department where depid=v_depid;
  
  if v_deptype=1 then
    v_depid:=Get_StrArrayStrOfIndex(v_deppath,'.',2);
  else
    v_depid:=Get_StrArrayStrOfIndex(v_deppath,'.',1);
  end if;
  
  select depname into v_depname from department where depid=v_depid;
  RETURN v_depname;
END;
/
CREATE OR REPLACE FUNCTION GET_BRANCH_SUMMARY_FUNCTION(v_beginDate in varchar2,v_endDate in varchar2)
    return branch_summary_TYPE_TABLE pipelined
is

    PRAGMA AUTONOMOUS_TRANSACTION;
    out_rec branch_summary_TYPE := branch_summary_TYPE(null, null, null, null);
    CURSOR branchCur IS select typename,companyname,breaks,totalprofitmargin from report_branch_summary;
BEGIN

    get_branch_summary(to_date(v_beginDate || ' 00:00:00','yyyy-mm-dd hh24:mi:ss'),
                        to_date(v_endDate || ' 23:59:59','yyyy-mm-dd hh24:mi:ss'));
    
    open branchCur;
       loop
            fetch branchCur into out_rec.typename,
                                  out_rec.companyname,
                                  out_rec.breaks,
                                  out_rec.totalprofitmargin;
            exit when branchCur%notfound;
            
            PIPE ROW(out_rec);
            
       end loop;
     close branchCur;

    return;
END;
/
CREATE OR REPLACE FUNCTION GET_ITNERPROJECT_FL_FUNCTION(v_beginDate in varchar2,v_endDate in varchar2)
    return W_PROJECT_F_TYPE_TABLE pipelined
is
    
    PRAGMA AUTONOMOUS_TRANSACTION;
    out_rec W_PROJECT_LANGUAGE_TYPE := W_PROJECT_LANGUAGE_TYPE(null, null, null, null, null, null, null, null);
    CURSOR projectCur IS select language,totalincome,totalexpenditure,profit,profitMargin,projectNum,profitpercent,projectpercent from report_language_summary order by profitpercent desc;
BEGIN

    GET_INTERPROJECT_FL_SUMMARY(to_date(v_beginDate || ' 00:00:00','yyyy-mm-dd hh24:mi:ss'),
                        to_date(v_endDate || ' 23:59:59','yyyy-mm-dd hh24:mi:ss'));

    open projectCur;
       loop
            fetch projectCur into out_rec.language,
                                  out_rec.totalincome,
                                  out_rec.totalexpenditure,
                                  out_rec.profit,
                                  out_rec.profitMargin,
                                  out_rec.projectNum,
                                  out_rec.profitpercent,
                                  out_rec.projectpercent;
            exit when projectCur%notfound;
            
            PIPE ROW(out_rec);
            
       end loop;
     close projectCur;
     
    return;
END;
/
CREATE OR REPLACE FUNCTION GET_ITNERPROJECT_TL_FUNCTION(v_beginDate in varchar2,v_endDate in varchar2)
    return W_PROJECT_F_TYPE_TABLE pipelined
is
    
    PRAGMA AUTONOMOUS_TRANSACTION;
    out_rec W_PROJECT_LANGUAGE_TYPE := W_PROJECT_LANGUAGE_TYPE(null, null, null, null, null, null, null, null);
    CURSOR projectCur IS select language,totalincome,totalexpenditure,profit,profitMargin,projectNum,profitpercent,projectpercent from report_language_summary order by profitpercent desc;
BEGIN

    GET_INTERPROJECT_TL_SUMMARY(to_date(v_beginDate || ' 00:00:00','yyyy-mm-dd hh24:mi:ss'),
                        to_date(v_endDate || ' 23:59:59','yyyy-mm-dd hh24:mi:ss'));

    open projectCur;
       loop
            fetch projectCur into out_rec.language,
                                  out_rec.totalincome,
                                  out_rec.totalexpenditure,
                                  out_rec.profit,
                                  out_rec.profitMargin,
                                  out_rec.projectNum,
                                  out_rec.profitpercent,
                                  out_rec.projectpercent;
            exit when projectCur%notfound;
            
            PIPE ROW(out_rec);
            
       end loop;
     close projectCur;
     
    return;
END;
/
CREATE OR REPLACE FUNCTION GET_PROJECT_FUNCTION(v_beginDate in varchar2,v_endDate in varchar2)
    return PROJECT_TYPE_TABLE pipelined
is
    PRAGMA AUTONOMOUS_TRANSACTION;

    out_rec PROJECT_TYPE := PROJECT_TYPE(null, null, null, null, null, null, null, null);
BEGIN
    
    get_project_summary(to_date(v_beginDate || ' 00:00:00','yyyy-mm-dd hh24:mi:ss'),
                        to_date(v_endDate || ' 23:59:59','yyyy-mm-dd hh24:mi:ss'));

    select format_num(writetotalincome),format_num(writetotalexpenditure),format_num(writeprofit),format_num(writeprofitMargin),
           format_num(interprettotalincome),format_num(interprettotalexpenditure),format_num(interpretprofit),format_num(interpretprofitMargin)
    into out_rec.writetotalincome,
         out_rec.writetotalexpenditure,
         out_rec.writeprofit,
         out_rec.writeprofitMargin,
         out_rec.interprettotalincome,
         out_rec.interprettotalexpenditure,
         out_rec.interpretprofit,
         out_rec.interpretprofitMargin
    from report_project_summary;

    PIPE ROW(out_rec);
    return;
END;
/
CREATE OR REPLACE FUNCTION GET_WRITEPROJECT_FL_FUNCTION(v_beginDate in varchar2,v_endDate in varchar2)
    return W_PROJECT_F_TYPE_TABLE pipelined
is
    
    PRAGMA AUTONOMOUS_TRANSACTION;
    out_rec W_PROJECT_LANGUAGE_TYPE := W_PROJECT_LANGUAGE_TYPE(null, null, null, null, null, null, null, null);
    CURSOR projectCur IS select language,totalincome,totalexpenditure,profit,profitMargin,projectNum,profitpercent,projectpercent from report_language_summary order by profitpercent desc;
BEGIN

    GET_WRITEPROJECT_FL_SUMMARY(to_date(v_beginDate || ' 00:00:00','yyyy-mm-dd hh24:mi:ss'),
                        to_date(v_endDate || ' 23:59:59','yyyy-mm-dd hh24:mi:ss'));

    open projectCur;
       loop
            fetch projectCur into out_rec.language,
                                  out_rec.totalincome,
                                  out_rec.totalexpenditure,
                                  out_rec.profit,
                                  out_rec.profitMargin,
                                  out_rec.projectNum,
                                  out_rec.profitpercent,
                                  out_rec.projectpercent;
            exit when projectCur%notfound;
            
            PIPE ROW(out_rec);
            
       end loop;
     close projectCur;
     
    return;
END;
/
CREATE OR REPLACE FUNCTION GET_WRITEPROJECT_TL_FUNCTION(v_beginDate in varchar2,v_endDate in varchar2)
    return W_PROJECT_F_TYPE_TABLE pipelined
is
    
    PRAGMA AUTONOMOUS_TRANSACTION;
    out_rec W_PROJECT_LANGUAGE_TYPE := W_PROJECT_LANGUAGE_TYPE(null, null, null, null, null, null, null, null);
    CURSOR projectCur IS select language,totalincome,totalexpenditure,profit,profitMargin,projectNum,profitpercent,projectpercent from report_language_summary order by profitpercent desc;
BEGIN

    GET_WRITEPROJECT_TL_SUMMARY(to_date(v_beginDate || ' 00:00:00','yyyy-mm-dd hh24:mi:ss'),
                        to_date(v_endDate || ' 23:59:59','yyyy-mm-dd hh24:mi:ss'));

    open projectCur;
       loop
            fetch projectCur into out_rec.language,
                                  out_rec.totalincome,
                                  out_rec.totalexpenditure,
                                  out_rec.profit,
                                  out_rec.profitMargin,
                                  out_rec.projectNum,
                                  out_rec.profitpercent,
                                  out_rec.projectpercent;
            exit when projectCur%notfound;
            
            PIPE ROW(out_rec);
            
       end loop;
     close projectCur;
     
    return;
END;
/
