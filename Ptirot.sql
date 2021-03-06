--1. Without changing the source file, 152696 records
-- Have 83640 records with sum_Death_Count <4 (54% of total)

--2. Grouping Year
--Created file = Z:\Amir\Big_Data\De_Identification\Ptirot_Hachtzana\Amir_Toad_Ptirot_Year.xlsx
select a.ICD10_Code, a.Death_Cause_Desc, a.Death_Cause_Type_Desc, a.Region_Desc, 
a.Population_Group_Desc, a.Age_Group_Desc, a.Gender_Desc, a.Year_Group, sum(a.Death_Count) as sum_Death_Count
from  (
select  src.ICD10_Code, src.Death_Cause_Desc,
src.Death_Cause_Type_Desc,src.Region_Desc, src.Population_Group_Desc, src.Age_Group_Desc, src.Gender_Desc,
Case 
When (src.Year<2005) Then  '2000-2004' 
When (src.Year>2004 and src.Year <2010) Then  '2005-2009' 
When (src.Year>2009 and src.Year <2015) Then  '2010-2014' 
When (src.Year>2014 and src.Year <2020) Then  '2015-2019' 
End Year_Group,
src.Death_Count
from dbo.Amir_Ptirot_Hactzana src  ) a
--where Age_Group_Desc ='5-14'
group by  a.ICD10_Code, a.Death_Cause_Desc, a.Death_Cause_Type_Desc, a.Region_Desc, 
a.Population_Group_Desc, a.Age_Group_Desc, a.Gender_Desc, a.Year_Group
--having sum(a.Death_Count)<4
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--3. Grouping Year_Group + Revised_Age_Group
--Created file = Z:\Amir\Big_Data\De_Identification\Ptirot_Hachtzana\Amir_Toad_Ptirot_Year+Revised_Age.xlsx
select a.ICD10_Code, a.Death_Cause_Desc, a.Death_Cause_Type_Desc, a.Region_Desc, 
a.Population_Group_Desc, a.Revised_Age_Group, a.Gender_Desc, a.Year_Group, sum(a.Death_Count) as sum_Death_Count
from  (
select  src.ICD10_Code, src.Death_Cause_Desc,
src.Death_Cause_Type_Desc,src.Region_Desc, src.Population_Group_Desc, 

Case 
When (src.Age_Group_Desc= '0-4') Then  '^0-14' 
When (src.Age_Group_Desc= '5-14') Then  '^0-14' 
When (src.Age_Group_Desc= '15-24') Then  '^15-34' 
When (src.Age_Group_Desc= '25-34') Then  '^15-34'
When (src.Age_Group_Desc= '35-44') Then  '^35-54' 
When (src.Age_Group_Desc= '45-54') Then  '^35-54' 
When (src.Age_Group_Desc= '55-64') Then  '^55-74' 
When (src.Age_Group_Desc= '65-74') Then  '^55-74' 
When (src.Age_Group_Desc= '75-84') Then  '^85+' 
When (src.Age_Group_Desc= '85+') Then  '^85+'
When (src.Age_Group_Desc is null) Then  'לא ידוע'
End Revised_Age_Group,
src.Gender_Desc,
Case 
When (src.Year<2005) Then  '2000-2004' 
When (src.Year>2004 and src.Year <2010) Then  '2005-2009' 
When (src.Year>2009 and src.Year <2015) Then  '2010-2014' 
When (src.Year>2014 and src.Year <2020) Then  '2015-2019' 
End Year_Group,
src.Death_Count
from dbo.Amir_Ptirot_Hactzana src  ) a
--where Age_Group_Desc ='5-14'
group by  a.ICD10_Code, a.Death_Cause_Desc, a.Death_Cause_Type_Desc, a.Region_Desc, 
a.Population_Group_Desc, a.Revised_Age_Group, a.Gender_Desc, a.Year_Group
--having sum(a.Death_Count)<4

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--4. Grouping Year_Group + Revised_Age_Group + Revised_Region_Desc
--Created file = Z:\Amir\Big_Data\De_Identification\Ptirot_Hachtzana\Amir_Toad_Ptirot_Year+Revised_Age.xlsx
select a.ICD10_Code, a.Death_Cause_Desc, a.Death_Cause_Type_Desc, a.Revised_Region, 
a.Population_Group_Desc, a.Revised_Age_Group, a.Gender_Desc, a.Year_Group, sum(a.Death_Count) as sum_Death_Count
from  (
select  src.ICD10_Code, src.Death_Cause_Desc,
src.Death_Cause_Type_Desc,
 
Case 
When (src.Region_Desc= 'מחוז חיפה') Then  'מחוז צפון' 
When (src.Region_Desc= 'מחוז צפון') Then  'מחוז צפון' 
When (src.Region_Desc= 'מחוז ירושלים') Then  'מחוז דרום' 
When (src.Region_Desc= 'מחוז דרום') Then  'מחוז דרום' 
When (src.Region_Desc= 'מחוז תל-אביב') Then  'מחוז מרכז' 
When (src.Region_Desc= 'מחוז מרכז') Then  'מחוז מרכז' 
When (src.Region_Desc= 'אזורי יו"ש ועזה') Then  'אזורי יו"ש ועזה' 
When (src.Region_Desc= 'מחוז לא ידוע') Then  'מחוז לא ידוע' 
When (src.Region_Desc= 'מחוז לא רשום') Then  'מחוז לא ידוע' 
End Revised_Region,

src.Population_Group_Desc, 

Case 
When (src.Age_Group_Desc= '0-4') Then  '^0-14' 
When (src.Age_Group_Desc= '5-14') Then  '^0-14' 
When (src.Age_Group_Desc= '15-24') Then  '^15-34' 
When (src.Age_Group_Desc= '25-34') Then  '^15-34'
When (src.Age_Group_Desc= '35-44') Then  '^35-54' 
When (src.Age_Group_Desc= '45-54') Then  '^35-54' 
When (src.Age_Group_Desc= '55-64') Then  '^55-74' 
When (src.Age_Group_Desc= '65-74') Then  '^55-74' 
When (src.Age_Group_Desc= '75-84') Then  '^85+' 
When (src.Age_Group_Desc= '85+') Then  '^85+'
When (src.Age_Group_Desc is null) Then  'לא ידוע'
End Revised_Age_Group,
src.Gender_Desc,
Case 
When (src.Year<2005) Then  '2000-2004' 
When (src.Year>2004 and src.Year <2010) Then  '2005-2009' 
When (src.Year>2009 and src.Year <2015) Then  '2010-2014' 
When (src.Year>2014 and src.Year <2020) Then  '2015-2019' 
End Year_Group,
src.Death_Count
from dbo.Amir_Ptirot_Hactzana src  ) a
--where Age_Group_Desc ='5-14'
group by  a.ICD10_Code, a.Death_Cause_Desc, a.Death_Cause_Type_Desc, a.Revised_Region, 
a.Population_Group_Desc, a.Revised_Age_Group, a.Gender_Desc, a.Year_Group
--having sum(a.Death_Count)<4

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--5. Saved the previous SQL to File = Z:\Amir\Big_Data\De_Identification\Ptirot_Hachtzana\Amir_Toad_Ptirot_Year+Revised_Age+Revised_Region.xlsx
-- Manipulated in that file when sum_Death_Count <4 for ALL the fields by changing MANUALLY, Gender_Desc field to לא נמסר
--Saved that to File = Z:\Amir\Big_Data\De_Identification\Ptirot_Hachtzana\Amir_Toad_Ptirot_Year+Revised_Age+Revised_Region+Gender.xlsx
--Uploaded this file to a SQL table Amir_Toad_Ptirot_Year+Revised_Age+Revised_Region+Gender

select a.ICD10_Code, a.Death_Cause_Desc, a.Death_Cause_Type_Desc, a.Revised_Region, a.Population_Group_Desc, 
a.Revised_Age_Group, a.Gender_Desc, a.Year_Group, sum(a.sum_Death_Count) as sum_Death_Count
from dbo.[Amir_Toad_Ptirot_Year+Revised_Age+Revised_Region+Gender] a
group by a.ICD10_Code, a.Death_Cause_Desc, a.Death_Cause_Type_Desc, a.Revised_Region, a.Population_Group_Desc, 
a.Revised_Age_Group, a.Gender_Desc, a.Year_Group
--having sum(a.sum_Death_Count)<4
--Still have 3031 records with sum_Death_Count <4 from total of original 152696 -  2%

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 6. Made trial & error on the table created in the previuos step, by dropping each time a different remaining yet "untouched" field
select 
a.ICD10_Code, 
--a.Death_Cause_Desc, 
a.Death_Cause_Type_Desc, 
a.Revised_Region, 
--a.Population_Group_Desc, 
a.Revised_Age_Group, a.Gender_Desc, a.Year_Group, sum(a.sum_Death_Count) as sum_Death_Count
from dbo.[Amir_Toad_Ptirot_Year+Revised_Age+Revised_Region+Gender] a
group by 
a.ICD10_Code, 
a.Death_Cause_Desc, 
a.Death_Cause_Type_Desc, 
a.Revised_Region, 
--a.Population_Group_Desc, 
a.Revised_Age_Group, a.Gender_Desc, a.Year_Group
--having sum(a.sum_Death_Count)<4

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--7. Decided to drop field Population_Group_Desc (it has only 2 values--> can't be grouped
-- Saved the run of the previous SQL to File = Z:\Amir\Big_Data\De_Identification\Ptirot_Hachtzana\Amir_Toad_Ptirot_Year+Revised_Age+Gender+Population.xlsx
-- Saved that file to Z:\Amir\Big_Data\De_Identification\Ptirot_Hachtzana\Amir_Toad_Ptirot_Year+Revised_Age+Gender+Population_1.xlsx
--Still have 3026 records with sum_Death_Count <4
-- Manipulated in that file when sum_Death_Count <4 for ALL the fields by changing MANUALLY  to לא נמסר fields: ICD10_Code,Death_Cause_Desc, Death_Cause_Type_Desc 
-- All these fields are related: code + descriptions
--Uploaded File= z:\Amir\Big_Data\De_Identification\Ptirot_Hachtzana\Amir_Toad_Ptirot_Year+Revised_Age+Revised_Region+Gender+Population_1.xlsx
--to table Amir_Toad_Ptirot_Year+Revised_Age+Revised_Region+Gender+Population_1

select a.ICD10_Code, a.Death_Cause_Desc, a.Death_Cause_Type_Desc, a.Revised_Region,  
a.Revised_Age_Group, a.Gender_Desc, a.Year_Group, sum(a.sum_Death_Count) as sum_Death_Count
from dbo.[Amir_Toad_Ptirot_Year+Revised_Age+Revised_Region+Gender+Population_1] a
group by a.ICD10_Code, a.Death_Cause_Desc, a.Death_Cause_Type_Desc, a.Revised_Region,  
a.Revised_Age_Group, a.Gender_Desc, a.Year_Group
--having sum(a.sum_Death_Count)<4
--9790 rcords left
-- Saved the run of the previous SQL to File = Z:\Amir\Big_Data\De_Identification\Ptirot_Hachtzana\Amir_Toad_Ptirot_Year+Revised_Age+Gender+Population_2.xlsx
--End process
--Still have 3 records with sum_Death_Count <4, but according to the data they hold - they can't be re-identified
--End process
