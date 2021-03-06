--Used for Amir uniting classification on Death_Cause_Desc
select distinct src.ICD10_Code, src.Death_Cause_Desc
from dbo.Amir_Ptirot_Hactzana src 
group by src.ICD10_Code, src.Death_Cause_Desc
order by 1,2
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--Test if the IPV system is correct regarding sum (not count) of suspected columns combinations
--Sql for sum
--src.Death_Cause_Desc, src.Age_Group_Desc
--src.ICD10_Code, src.Age_Group_Desc
select distinct src.ICD10_Code, src.Age_Group_Desc, sum(src.Death_Count) as sum
from dbo.Amir_Ptirot_Hactzana src
group by src.ICD10_Code, src.Age_Group_Desc
having  sum(src.Death_Count)<4
order by sum desc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Change the Hebrew to English
select distinct  
CASE
WHEN s.ICD10_Code = 'A40,A41' THEN 'A40-A41'
WHEN s.ICD10_Code = 'G30' THEN 'G30,G31'
WHEN s.ICD10_Code = 'I10, I12, I15' THEN 'I10-I15'
WHEN s.ICD10_Code = 'II20; I24-I25' THEN 'I20-I25'
WHEN s.ICD10_Code = 'N00-N07, N17-N19, N25-N27' THEN 'N00-N29'
WHEN s.ICD10_Code = 'K70, K73-K74' THEN 'K70-K76'
WHEN s.ICD10_Code = 'R96-R99' THEN 'R96-R98'
WHEN s.ICD10_Code = 'V01-X59' THEN 'V01-X59, Y85-Y86'
Else  s.ICD10_Code
End ICD10_Code_Changed,

CASE
WHEN s.Death_Cause_Desc = 'אלח דם' THEN 'Septicaemia'
WHEN s.Death_Cause_Desc = 'מחלת אלצהיימר' THEN 'Alzheimers disease & other degenerative diseases of nervous system'
WHEN s.Death_Cause_Desc = 'יתר לחץ דם  ' THEN 'Hypertensive diseases'
WHEN s.Death_Cause_Desc = 'Other ischaemic heart diseases' THEN 'Ischaemic heart diseases'
WHEN s.Death_Cause_Desc = 'מחלות כליה' THEN 'Diseases of the kidney and ureter'
WHEN s.Death_Cause_Desc = 'מחלות כבד כרוניות ' THEN 'Diseases of the liver'
WHEN s.Death_Cause_Desc = 'ללא סיבה ידועה' THEN 'Sudden & unattended death, cause unknown'
WHEN s.Death_Cause_Desc = 'תאונות  ' THEN 'Accidents'
Else s.Death_Cause_Desc
End Death_Cause_Desc_Changed
--s.Death_Cause_Desc
from dbo.Amir_Ptirot_Hactzana s
order by ICD10_Code_Changed

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Run the following for identifying the problematic records or the binning options:
--Death_Cause_Desc + Age_Group_Desc:
select 
CASE
WHEN s.Death_Cause_Desc = 'אלח דם' THEN 'Septicaemia'
WHEN s.Death_Cause_Desc = 'מחלת אלצהיימר' THEN 'Alzheimers disease & other degenerative diseases of nervous system'
WHEN s.Death_Cause_Desc = 'יתר לחץ דם  ' THEN 'Hypertensive diseases'
WHEN s.Death_Cause_Desc = 'Other ischaemic heart diseases' THEN 'Ischaemic heart diseases'
WHEN s.Death_Cause_Desc = 'מחלות כליה' THEN 'Diseases of the kidney and ureter'
WHEN s.Death_Cause_Desc = 'מחלות כבד כרוניות ' THEN 'Diseases of the liver'
WHEN s.Death_Cause_Desc = 'ללא סיבה ידועה' THEN 'Sudden & unattended death, cause unknown'
WHEN s.Death_Cause_Desc = 'תאונות  ' THEN 'Accidents'
Else s.Death_Cause_Desc
End Death_Cause_Desc_Changed,

CASE --from source
WHEN s.Age_Group_Desc is  null THEN 'לא נמסר'
     Else  s.Age_Group_Desc
End Age_Group_Desc_Changed, 

 
  sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
CASE
WHEN s.Death_Cause_Desc = 'אלח דם' THEN 'Septicaemia'
WHEN s.Death_Cause_Desc = 'מחלת אלצהיימר' THEN 'Alzheimers disease & other degenerative diseases of nervous system'
WHEN s.Death_Cause_Desc = 'יתר לחץ דם  ' THEN 'Hypertensive diseases'
WHEN s.Death_Cause_Desc = 'Other ischaemic heart diseases' THEN 'Ischaemic heart diseases'
WHEN s.Death_Cause_Desc = 'מחלות כליה' THEN 'Diseases of the kidney and ureter'
WHEN s.Death_Cause_Desc = 'מחלות כבד כרוניות ' THEN 'Diseases of the liver'
WHEN s.Death_Cause_Desc = 'ללא סיבה ידועה' THEN 'Sudden & unattended death, cause unknown'
WHEN s.Death_Cause_Desc = 'תאונות  ' THEN 'Accidents'
Else s.Death_Cause_Desc
End ,
CASE --From source
WHEN s.Age_Group_Desc is  null THEN 'לא נמסר'
     Else  s.Age_Group_Desc
End 
having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--ICD10 + Age_Group_Desc:
select 
CASE
WHEN s.ICD10_Code = 'A40,A41' THEN 'A40-A41'
WHEN s.ICD10_Code = 'G30' THEN 'G30,G31'
WHEN s.ICD10_Code = 'I10, I12, I15' THEN 'I10-I15'
WHEN s.ICD10_Code = 'II20; I24-I25' THEN 'I20-I25'
WHEN s.ICD10_Code = 'N00-N07, N17-N19, N25-N27' THEN 'N00-N29'
WHEN s.ICD10_Code = 'K70, K73-K74' THEN 'K70-K76'
WHEN s.ICD10_Code = 'R96-R99' THEN 'R96-R98'
WHEN s.ICD10_Code = 'V01-X59' THEN 'V01-X59, Y85-Y86'
Else  s.ICD10_Code
End ICD10_Code_Changed,

CASE --from source
WHEN s.Age_Group_Desc is  null THEN 'לא נמסר'
     Else  '^' + s.Age_Group_Desc
End Age_Group_Desc_Changed, 

 
  sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
group by 
CASE
WHEN s.ICD10_Code = 'A40,A41' THEN 'A40-A41'
WHEN s.ICD10_Code = 'G30' THEN 'G30,G31'
WHEN s.ICD10_Code = 'I10, I12, I15' THEN 'I10-I15'
WHEN s.ICD10_Code = 'II20; I24-I25' THEN 'I20-I25'
WHEN s.ICD10_Code = 'N00-N07, N17-N19, N25-N27' THEN 'N00-N29'
WHEN s.ICD10_Code = 'K70, K73-K74' THEN 'K70-K76'
WHEN s.ICD10_Code = 'R96-R99' THEN 'R96-R98'
WHEN s.ICD10_Code = 'V01-X59' THEN 'V01-X59, Y85-Y86'
Else  s.ICD10_Code
End ,
CASE --From source
WHEN s.Age_Group_Desc is  null THEN 'לא נמסר'
     Else  '^' + s.Age_Group_Desc
End 
having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Death_Cause_Desc + Region_Desc:
select 
CASE
WHEN s.Death_Cause_Desc = 'אלח דם' THEN 'Septicaemia'
WHEN s.Death_Cause_Desc = 'מחלת אלצהיימר' THEN 'Alzheimers disease & other degenerative diseases of nervous system'
WHEN s.Death_Cause_Desc = 'יתר לחץ דם  ' THEN 'Hypertensive diseases'
WHEN s.Death_Cause_Desc = 'Other ischaemic heart diseases' THEN 'Ischaemic heart diseases'
WHEN s.Death_Cause_Desc = 'מחלות כליה' THEN 'Diseases of the kidney and ureter'
WHEN s.Death_Cause_Desc = 'מחלות כבד כרוניות ' THEN 'Diseases of the liver'
WHEN s.Death_Cause_Desc = 'ללא סיבה ידועה' THEN 'Sudden & unattended death, cause unknown'
WHEN s.Death_Cause_Desc = 'תאונות  ' THEN 'Accidents'
Else s.Death_Cause_Desc
End Death_Cause_Desc_Changed,

case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
     Else s.Region_Desc
End Region_Desc_Changed,


 
  sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where s.Death_Cause_Desc = 'Accidental poisoning' 
group by 
CASE
WHEN s.Death_Cause_Desc = 'אלח דם' THEN 'Septicaemia'
WHEN s.Death_Cause_Desc = 'מחלת אלצהיימר' THEN 'Alzheimers disease & other degenerative diseases of nervous system'
WHEN s.Death_Cause_Desc = 'יתר לחץ דם  ' THEN 'Hypertensive diseases'
WHEN s.Death_Cause_Desc = 'Other ischaemic heart diseases' THEN 'Ischaemic heart diseases'
WHEN s.Death_Cause_Desc = 'מחלות כליה' THEN 'Diseases of the kidney and ureter'
WHEN s.Death_Cause_Desc = 'מחלות כבד כרוניות ' THEN 'Diseases of the liver'
WHEN s.Death_Cause_Desc = 'ללא סיבה ידועה' THEN 'Sudden & unattended death, cause unknown'
WHEN s.Death_Cause_Desc = 'תאונות  ' THEN 'Accidents'
Else s.Death_Cause_Desc
End ,

case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
Else s.Region_Desc
End 

having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Death_Cause_Desc + year:
select 
CASE
WHEN s.Death_Cause_Desc = 'אלח דם' THEN 'Septicaemia'
WHEN s.Death_Cause_Desc = 'מחלת אלצהיימר' THEN 'Alzheimers disease & other degenerative diseases of nervous system'
WHEN s.Death_Cause_Desc = 'יתר לחץ דם  ' THEN 'Hypertensive diseases'
WHEN s.Death_Cause_Desc = 'Other ischaemic heart diseases' THEN 'Ischaemic heart diseases'
WHEN s.Death_Cause_Desc = 'מחלות כליה' THEN 'Diseases of the kidney and ureter'
WHEN s.Death_Cause_Desc = 'מחלות כבד כרוניות ' THEN 'Diseases of the liver'
WHEN s.Death_Cause_Desc = 'ללא סיבה ידועה' THEN 'Sudden & unattended death, cause unknown'
WHEN s.Death_Cause_Desc = 'תאונות  ' THEN 'Accidents'
Else s.Death_Cause_Desc
End Death_Cause_Desc_Changed,

s.Year,


 
  sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where s.Death_Cause_Desc = 'Malignant neoplasms' 
group by 
CASE
WHEN s.Death_Cause_Desc = 'אלח דם' THEN 'Septicaemia'
WHEN s.Death_Cause_Desc = 'מחלת אלצהיימר' THEN 'Alzheimers disease & other degenerative diseases of nervous system'
WHEN s.Death_Cause_Desc = 'יתר לחץ דם  ' THEN 'Hypertensive diseases'
WHEN s.Death_Cause_Desc = 'Other ischaemic heart diseases' THEN 'Ischaemic heart diseases'
WHEN s.Death_Cause_Desc = 'מחלות כליה' THEN 'Diseases of the kidney and ureter'
WHEN s.Death_Cause_Desc = 'מחלות כבד כרוניות ' THEN 'Diseases of the liver'
WHEN s.Death_Cause_Desc = 'ללא סיבה ידועה' THEN 'Sudden & unattended death, cause unknown'
WHEN s.Death_Cause_Desc = 'תאונות  ' THEN 'Accidents'
Else s.Death_Cause_Desc
End ,

s.Year

having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--gender + year:
select 
s.Gender_Desc,
s.Year,

  sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where s.Death_Cause_Desc = 'סיבות סב-לידתית'
group by 
s.Gender_Desc,
s.Year
having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Region_Desc + year:
select 
case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
     Else s.Region_Desc
End Region_Desc_Changed,
s.Year,

  sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where s.Death_Cause_Desc = 'סיבות סב-לידתית'
group by 
case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
     Else s.Region_Desc
End ,
s.Year
having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Region_Desc + Age_Group_Desc:
select 
case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
     Else s.Region_Desc
End Region_Desc_Changed,

case
WHEN s.Age_Group_Desc is null THEN 'לא נמסר'
     Else s.Age_Group_Desc
End Age_Group_Desc_Changed,


  sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where s.Death_Cause_Desc = 'סיבות סב-לידתית'
group by 
case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
     Else s.Region_Desc
End ,
case
WHEN s.Age_Group_Desc is null THEN 'לא נמסר'
     Else s.Age_Group_Desc
End
having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Death_Cause_Desc + Gender_Desc:
select 
CASE
WHEN s.Death_Cause_Desc = 'אלח דם' THEN 'Septicaemia'
WHEN s.Death_Cause_Desc = 'מחלת אלצהיימר' THEN 'Alzheimers disease & other degenerative diseases of nervous system'
WHEN s.Death_Cause_Desc = 'יתר לחץ דם  ' THEN 'Hypertensive diseases'
WHEN s.Death_Cause_Desc = 'Other ischaemic heart diseases' THEN 'Ischaemic heart diseases'
WHEN s.Death_Cause_Desc = 'מחלות כליה' THEN 'Diseases of the kidney and ureter'
WHEN s.Death_Cause_Desc = 'מחלות כבד כרוניות ' THEN 'Diseases of the liver'
WHEN s.Death_Cause_Desc = 'ללא סיבה ידועה' THEN 'Sudden & unattended death, cause unknown'
WHEN s.Death_Cause_Desc = 'תאונות  ' THEN 'Accidents'
Else s.Death_Cause_Desc
End Death_Cause_Desc_Changed,

s.Gender_Desc, 

 
  sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
CASE
WHEN s.Death_Cause_Desc = 'אלח דם' THEN 'Septicaemia'
WHEN s.Death_Cause_Desc = 'מחלת אלצהיימר' THEN 'Alzheimers disease & other degenerative diseases of nervous system'
WHEN s.Death_Cause_Desc = 'יתר לחץ דם  ' THEN 'Hypertensive diseases'
WHEN s.Death_Cause_Desc = 'Other ischaemic heart diseases' THEN 'Ischaemic heart diseases'
WHEN s.Death_Cause_Desc = 'מחלות כליה' THEN 'Diseases of the kidney and ureter'
WHEN s.Death_Cause_Desc = 'מחלות כבד כרוניות ' THEN 'Diseases of the liver'
WHEN s.Death_Cause_Desc = 'ללא סיבה ידועה' THEN 'Sudden & unattended death, cause unknown'
WHEN s.Death_Cause_Desc = 'תאונות  ' THEN 'Accidents'
Else s.Death_Cause_Desc
End ,
s.Gender_Desc
having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--year +Age_Group_Desc:
select
s.year, 
CASE --from source
WHEN s.Age_Group_Desc is  null THEN 'לא נמסר'
     Else  '^' + s.Age_Group_Desc
End Age_Group_Desc_Changed, 



   sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
s.year,
CASE --from source
WHEN s.Age_Group_Desc is  null THEN 'לא נמסר'
     Else  '^' + s.Age_Group_Desc
End 

--having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--ICD10_Code +Gender_Desc:
select
CASE
WHEN s.ICD10_Code = 'A40,A41' THEN 'A40-A41'
WHEN s.ICD10_Code = 'G30' THEN 'G30,G31'
WHEN s.ICD10_Code = 'I10, I12, I15' THEN 'I10-I15'
WHEN s.ICD10_Code = 'II20; I24-I25' THEN 'I20-I25'
WHEN s.ICD10_Code = 'N00-N07, N17-N19, N25-N27' THEN 'N00-N29'
WHEN s.ICD10_Code = 'K70, K73-K74' THEN 'K70-K76'
WHEN s.ICD10_Code = 'R96-R99' THEN 'R96-R98'
WHEN s.ICD10_Code = 'V01-X59' THEN 'V01-X59, Y85-Y86'
Else  s.ICD10_Code
End ICD10_Code_Changed,
s.Gender_Desc, 




   sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
CASE
WHEN s.ICD10_Code = 'A40,A41' THEN 'A40-A41'
WHEN s.ICD10_Code = 'G30' THEN 'G30,G31'
WHEN s.ICD10_Code = 'I10, I12, I15' THEN 'I10-I15'
WHEN s.ICD10_Code = 'II20; I24-I25' THEN 'I20-I25'
WHEN s.ICD10_Code = 'N00-N07, N17-N19, N25-N27' THEN 'N00-N29'
WHEN s.ICD10_Code = 'K70, K73-K74' THEN 'K70-K76'
WHEN s.ICD10_Code = 'R96-R99' THEN 'R96-R98'
WHEN s.ICD10_Code = 'V01-X59' THEN 'V01-X59, Y85-Y86'
Else  s.ICD10_Code
End,
s.Gender_Desc

having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--ICD10_Code:
select
CASE
WHEN s.ICD10_Code = 'A40,A41' THEN 'A40-A41'
WHEN s.ICD10_Code = 'G30' THEN 'G30,G31'
WHEN s.ICD10_Code = 'I10, I12, I15' THEN 'I10-I15'
WHEN s.ICD10_Code = 'II20; I24-I25' THEN 'I20-I25'
WHEN s.ICD10_Code = 'N00-N07, N17-N19, N25-N27' THEN 'N00-N29'
WHEN s.ICD10_Code = 'K70, K73-K74' THEN 'K70-K76'
WHEN s.ICD10_Code = 'R96-R99' THEN 'R96-R98'
WHEN s.ICD10_Code = 'V01-X59' THEN 'V01-X59, Y85-Y86'
Else  s.ICD10_Code
End ICD10_Code_Changed,
--s.Gender_Desc, 




   sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
CASE
WHEN s.ICD10_Code = 'A40,A41' THEN 'A40-A41'
WHEN s.ICD10_Code = 'G30' THEN 'G30,G31'
WHEN s.ICD10_Code = 'I10, I12, I15' THEN 'I10-I15'
WHEN s.ICD10_Code = 'II20; I24-I25' THEN 'I20-I25'
WHEN s.ICD10_Code = 'N00-N07, N17-N19, N25-N27' THEN 'N00-N29'
WHEN s.ICD10_Code = 'K70, K73-K74' THEN 'K70-K76'
WHEN s.ICD10_Code = 'R96-R99' THEN 'R96-R98'
WHEN s.ICD10_Code = 'V01-X59' THEN 'V01-X59, Y85-Y86'
Else  s.ICD10_Code
End
--,s.Gender_Desc

having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 2 asc
--order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Death_Cause_Desc:
select
CASE
WHEN s.Death_Cause_Desc = 'אלח דם' THEN 'Septicaemia'
WHEN s.Death_Cause_Desc = 'מחלת אלצהיימר' THEN 'Alzheimers disease & other degenerative diseases of nervous system'
WHEN s.Death_Cause_Desc = 'יתר לחץ דם  ' THEN 'Hypertensive diseases'
WHEN s.Death_Cause_Desc = 'Other ischaemic heart diseases' THEN 'Ischaemic heart diseases'
WHEN s.Death_Cause_Desc = 'מחלות כליה' THEN 'Diseases of the kidney and ureter'
WHEN s.Death_Cause_Desc = 'מחלות כבד כרוניות ' THEN 'Diseases of the liver'
WHEN s.Death_Cause_Desc = 'ללא סיבה ידועה' THEN 'Sudden & unattended death, cause unknown'
WHEN s.Death_Cause_Desc = 'תאונות  ' THEN 'Accidents'
Else s.Death_Cause_Desc
End Death_Cause_Desc_Changed,
--s.Gender_Desc, 




   sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
CASE
WHEN s.Death_Cause_Desc = 'אלח דם' THEN 'Septicaemia'
WHEN s.Death_Cause_Desc = 'מחלת אלצהיימר' THEN 'Alzheimers disease & other degenerative diseases of nervous system'
WHEN s.Death_Cause_Desc = 'יתר לחץ דם  ' THEN 'Hypertensive diseases'
WHEN s.Death_Cause_Desc = 'Other ischaemic heart diseases' THEN 'Ischaemic heart diseases'
WHEN s.Death_Cause_Desc = 'מחלות כליה' THEN 'Diseases of the kidney and ureter'
WHEN s.Death_Cause_Desc = 'מחלות כבד כרוניות ' THEN 'Diseases of the liver'
WHEN s.Death_Cause_Desc = 'ללא סיבה ידועה' THEN 'Sudden & unattended death, cause unknown'
WHEN s.Death_Cause_Desc = 'תאונות  ' THEN 'Accidents'
Else s.Death_Cause_Desc
End
--,s.Gender_Desc

having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 2 asc
--order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Population_Group_Desc+Region_Desc:
select

s.Population_Group_Desc,
case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
     Else s.Region_Desc
End Region_Desc_Changed,



   sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
s.Population_Group_Desc,
case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
     Else s.Region_Desc
End

having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc
--order by 3 asc


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--s.Gender_Desc,+Region_Desc:
select
s.Gender_Desc,
case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
     Else s.Region_Desc
End Region_Desc_Changed,



   sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
s.Gender_Desc,
case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
     Else s.Region_Desc
End

having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc
--order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Population_Group_Desc+Age_Group_Desc:
select
s.Population_Group_Desc,
CASE --from source
WHEN s.Age_Group_Desc is  null THEN 'לא נמסר'
     Else  s.Age_Group_Desc
End Age_Group_Desc_Changed, 



   sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
s.Population_Group_Desc,
CASE --from source
WHEN s.Age_Group_Desc is  null THEN 'לא נמסר'
     Else  s.Age_Group_Desc
End

having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc
--order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Gender_Desc+Age_Group_Desc:
select
s.Gender_Desc, 
CASE --from source
WHEN s.Age_Group_Desc is  null THEN 'לא נמסר'
     Else  s.Age_Group_Desc
End Age_Group_Desc_Changed, 



   sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
s.Gender_Desc, 
CASE --from source
WHEN s.Age_Group_Desc is  null THEN 'לא נמסר'
     Else  s.Age_Group_Desc
End

having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 3 asc
--order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Gender_Desc:
select
s.Gender_Desc, 




   sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
s.Gender_Desc


--having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 2 asc
--order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Region_Desc:
select
case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
     Else s.Region_Desc
End Region_Desc_Changed,




   sum(s.Death_Count) as k
from dbo.Amir_Ptirot_Hactzana s
--where src.ICD10_Code = 'A39' 
group by 
case
WHEN s.Region_Desc = 'מחוז לא רשום  ' THEN 'מחוז לא ידוע'
     Else s.Region_Desc
End


--having  sum(s.Death_Count)<4 -- Without this line, I will find all the binning options available to eliminte the problem
order by 2 asc
--order by 3 asc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
select s.ICD10_Code, s.Death_Cause_Desc, s.Death_Cause_Type_Desc, s.Region_Desc, s.Population_Group_Desc, s.Age_Group_Desc, s.Gender_Desc, s.[Year], sum(s.Death_Count) as Sum_Death_Count
from dbo.Amir_Ptirot_Hactzana s
group by s.ICD10_Code, s.Death_Cause_Desc, s.Death_Cause_Type_Desc, s.Region_Desc, s.Population_Group_Desc, s.Age_Group_Desc, s.Gender_Desc, s.[Year]
having  sum(s.Death_Count)<4

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
select s.ICD10_Code, s.Death_Cause_Desc, s.Death_Cause_Type_Desc, s.Region_Desc, s.Population_Group_Desc, s.Age_Group_Desc, s.Gender_Desc, s.[Year], sum(s.Death_Count) as Sum_Death_Count
from dbo.Before_Run4_Ptirot_Amir_United s
group by s.ICD10_Code, s.Death_Cause_Desc, s.Death_Cause_Type_Desc, s.Region_Desc, s.Population_Group_Desc, s.Age_Group_Desc, s.Gender_Desc, s.[Year]
having  sum(s.Death_Count)<4
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--rename table

EXEC sp_rename 'dbo.Ptirot_Amir_United', 'Before_Run4_Ptirot_Amir_United'; 

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

select s.ICD10_Code, s.Death_Cause_Desc, s.Death_Cause_Type_Desc, s.Region_Desc, s.Population_Group_Desc, s.Age_Group_Desc, s.Gender_Desc, s.[Year], sum(s.Death_Count) as Sum_Death_Count
from dbo.Before_Run5_Ptirot_Amir_United s
--where s.[Year] = 'לא ידוע'
group by s.ICD10_Code, s.Death_Cause_Desc, s.Death_Cause_Type_Desc, s.Region_Desc, s.Population_Group_Desc, s.Age_Group_Desc, s.Gender_Desc, s.[Year]
--having  sum(s.Death_Count)<4
order by sum(s.Death_Count) desc

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

select s.ICD10_Code, s.Death_Cause_Desc, s.Death_Cause_Type_Desc, s.Region_Desc, s.Population_Group_Desc, s.Age_Group_Desc, s.Gender_Desc, s.[Year], sum(s.Death_Count) as Sum_Death_Count
from dbo.Before_Run6_Ptirot_Amir_United s
group by s.ICD10_Code, s.Death_Cause_Desc, s.Death_Cause_Type_Desc, s.Region_Desc, s.Population_Group_Desc, s.Age_Group_Desc, s.Gender_Desc, s.[Year]
--having  sum(s.Death_Count)<4