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
order by 4 asc