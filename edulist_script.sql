            /*Data Analysis of Higher Education outcome of UAE (2018-2023)*/
/*Dataset : Open Data UAE | Higher Education Graduates Data for 2018-2023 (fcsc.gov.ae)*/

SELECT * FROM higher_education.educationlist;
alter table higher_education.educationlist
rename  column Nationality_EN to Nationality;

update higher_education.educationlist 
set STEM_Indicator='Engineering'
WHERE STEM_Indicator ='E';
update higher_education.educationlist 
set STEM_Indicator='Management'
WHERE STEM_Indicator ='Science_Management';

/* List of the no.of Institutes(higher education) in all the emirates of UAE  */
select distinct emirate,count( distinct Institution) as Num_of_institutes from higher_education.educationlist
group by emirate,sector;
select distinct emirate, Sector ,count( distinct Institution) as Num_of_institutes from higher_education.educationlist
group by emirate,sector;

/* Total no. of Students under  various Sectors */
select distinct Academic_Year,  sector, emirate ,Sum(Total_Graduates) from higher_education.graduates
group by Academic_Year, sector, emirate 
order by Academic_Year,emirate;

/*Total Graduates under STEM and Non-STEM*/
with g2 as
(select  distinct Academic_Year,  emirate, 
sum(CASE WHEN STEM_Indicator  like '%Non_STEM%' THEN Total_Graduates Else 0  END) AS Non_STEM,
sum( CASE WHEN STEM_Indicator   like '%Science%' THEN Total_Graduates Else 0 END) AS Science,
sum(CASE WHEN STEM_Indicator   like '%Technology%' THEN Total_Graduates Else 0 END) AS Technology,
sum(CASE WHEN STEM_Indicator   like '%Engineering%' THEN Total_Graduates Else 0 END) AS Engineering,
sum(CASE WHEN STEM_Indicator   like '%Management%' THEN Total_Graduates Else 0 END) AS Science_Management


 from higher_education.educationlist
 group by Academic_Year,  emirate 
order by Academic_Year,emirate
)
select * from g2;

/* Total No.of National and Non-National Students*/

update higher_education.educationlist 
set Nationality='Foreign_Student'
WHERE Nationality ='Non-National';

with g3 as
(select  distinct Academic_Year,  emirate,Academic_Degree,
sum(CASE WHEN Nationality  like '%National%' THEN Total_Graduates else 0 END) AS National_Student,
sum( CASE WHEN Nationality   like '%Foreign_Student%' THEN Total_Graduates else 0 END) AS Non_National_student
 from higher_education.educationlist
 group by Academic_Year,  emirate , Academic_Degree 
order by Academic_Year,emirate,Academic_Degree
),
g4 as
( select Distinct Academic_Degree,Academic_Year,emirate,National_Student,Non_National_student)
select * from g3;
