create database HR_DB;

use HR_DB;

select * from hr_analytics;

-- Data Cleaning and Processing
alter table hr_analytics
change column ï»¿EmpID EmpID varchar(20) null;

describe hr_analytics;

-- Remove Duplicate Employee ID
set sql_safe_updates = 0;

create temporary table temp_table as
select EmpID
from hr_analytics
group by EmpID
having count(*) > 1;

delete from hr_analytics
where EmpID in (select EmpID from temp_table);

drop temporary table if exists temp_table;

-- Removed Columns
alter table hr_analytics
drop column YearsWithCurrManager;
 
 -- Replaced Values 
update hr_analytics
set BusinessTravel = "Travel_Rarely"
where BusinessTravel = "TravelRarely";

-- KPI Cards
-- Count of Employee
select count(distinct EmpID) as `Count of Employee`
from hr_analytics;

-- Attrition
select count(Attrition) as `Attrition`
from hr_analytics
where Attrition = "Yes";

-- Attrition Rate
select round(sum(case 
           when Attrition = "Yes" 
           then 1 
           else 0
           End) / count(EmpID) * 100, 2) as `Attrition Rate`
from hr_analytics;

-- Avg Age
select round(avg(Age), 2) as `Avg Age`
from hr_analytics;

-- Avg Salary
select round(avg(MonthlyIncome), 2) as `Avg Salary`
from hr_analytics;

-- Avg Years
select round(avg(YearsAtCompany), 2) as `Avg Years`
from hr_analytics;

-- Charts
-- Attrition by Gender
select Gender, count(Attrition) as `Attrition_Count`
from hr_analytics
where Attrition = "Yes"
group by Gender;

-- Attrition by Education
select EducationField, count(Attrition) as `Attrition_Count`
from hr_analytics
where Attrition = "Yes"
group by EducationField
order by Attrition_Count desc;

-- Attrition by Age
select AgeGroup, count(Attrition) as `Attrition_Count`
from hr_analytics
where Attrition = "Yes"
group by AgeGroup
order by Attrition_Count desc;

-- Attrition by Salary Slab
select SalarySlab, count(Attrition) as `Attrition_Count`
from hr_analytics
where Attrition = "Yes"
group by SalarySlab
order by Attrition_Count desc;

-- Attrition by Job Role
select JobRole, count(Attrition) as `Attrition_Count`
from hr_analytics
where Attrition = "Yes"
group by JobRole
order by Attrition_Count desc
limit 5;

-- Employee Attrition by Years at Company
select YearsAtCompany, count(Attrition) as `Attrition_Count`
from hr_analytics
where Attrition = "Yes"
group by YearsAtCompany
order by Attrition_Count desc;

-- Job Role Satisfaction Comparison
select JobRole,
sum(case when JobSatisfaction = 1 then 1 else 0 end) as `JobSatisfaction_1`,
sum(case when JobSatisfaction = 2 then 1 else 0 end) as `JobSatisfaction_2`,
sum(case when JobSatisfaction = 3 then 1 else 0 end) as `JobSatisfaction_3`,
sum(case when JobSatisfaction = 4 then 1 else 0 end) as `JobSatisfaction_4`,
count(Attrition) as `Total`
from hr_analytics
where Attrition = 'Yes'
group by JobRole;


