1.
��1��ͳ��20171001��20171007�ڼ��ۼƷ���pv����100�������û�����
select count(distinct a.msisdn)uv
from (select a.msisdn,sum(a.pv)pv 
 FROM PAGEVISIT A,
      USER_INFO B
WHERE A.MSISDN=B.MSISDN
   AND B.SEX='��'  
   and a.record_day between '20171001' and '20171007'
group by a.msisdn)a
where a.pv>100;

��2��ͳ��20171001��20171007�ڼ���������3���з��ʵ��û��嵥
     select A.Msisdn, count(A.rn_2)days, A.rn_2
  from (select A.Msisdn,A.Record_Day,ROW_NUMBER() OVER(PARTITION BY A.MSISDN ORDER BY A.RECORD_DAY) RN,
        A.Record_Day - ROW_NUMBER() OVER(PARTITION BY A.MSISDN ORDER BY A.RECORD_DAY) RN_2
          from (select DISTINCT A.Msisdn, A.Record_Day from cx_jinxj.pagevisit  A where a.record_day between '20171001' and '20171007') A) A
 group by A.Msisdn, A.rn_2
having count(A.rn_2) >= 3;

2.
��1��ͳ��ÿ��������н������top3���û��б�
select dept_name,name,salary
From (select b.dept_name,name,salary,dense_rank()over(partition by  b.dept_name order by a.salary DESC)rn 
 from cx_jinxj.EMPLOYEE a
 JOIN cx_jinxj.DEPARTMENT b
   ON a.DEPARTMENTID=b.DEPARTMENTID )A
WHERE a.RN<=3;

3.
 select a.request_at,
       round(count(case
                     when instr(a.status, 'cancelled') > 0 then
                      1
                   end) / count(1),
             2) rate
  from trips a,
       (select * from users a where upper(a.banned) = 'yes') b,
       (select * from users a where upper(a.banned) = 'yes') c
 where a.cliend_id = b.user_id(+)
   and a.driver_id = c.user_id(+)
   and b.user_id is null
   and c.user_id is null
   and a.request_at between '2013-10-01' and '2013-10-03'
group by a.request_at;
