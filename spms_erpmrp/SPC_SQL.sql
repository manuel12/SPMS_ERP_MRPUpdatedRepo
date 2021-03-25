/******************************************************************************************************

Description:			

By:                  Modupe Ogunlaja (NHS England & NHS Improvement) (nhsi.improvementanalyticsteam@nhs.net)
Date:                07-August-2019 

Changes:             
                     07/08/19 - MO - Creation of initial script. 
					 18/09/19 - MO - Added Target and #SPCTestXMRChartRules_Extract into the final extract.
					 07/11/19 - TN - Added Variance Type icon to include high and low and added capability icon.
					 15/01/20 - TN - Correction of Capability Icon case statement.
							 
******************************************************************************************************/   





/*****************************************************************************************************
1. Create the data tables from the XmR chart and populate with sample data 
- Sample data to be replaced by links to local data tables - using same column names and format
******************************************************************************************************/

IF OBJECT_ID('tempdb..#SPCTestData') IS NOT NULL
	DROP TABLE #SPCTestData
GO
IF OBJECT_ID('tempdb..#SPCTestIndicator') IS NOT NULL
	DROP TABLE #SPCTestIndicator
GO
IF OBJECT_ID('tempdb..#SPCTestXMRChart') IS NOT NULL
	DROP TABLE #SPCTestXMRChart
GO
IF OBJECT_ID('tempdb..#SPCTestXMRChartRules') IS NOT NULL
	DROP TABLE #SPCTestXMRChartRules
GO
IF OBJECT_ID('tempdb..#SPCTestXMRChartRules_Extract') IS NOT NULL
	DROP TABLE #SPCTestXMRChartRules_Extract
GO
IF OBJECT_ID('tempdb..#SPCTestXMRChartRules_Extract_Deep') IS NOT NULL
	DROP TABLE #SPCTestXMRChartRules_Extract_Deep
GO
CREATE TABLE #SPCTestData ---Sample data table to be replaced by relevant local table
(
       SampleDate Date,  
       AreaCode VARCHAR(5),		--- AreaCode (This could represennt trusts, sites, providers, wards, specialities etc)
       AreaName VARCHAR(50),	--- Area Name (This could represennt trusts, sites, providers, wards, specialities etc)
       MeasureCode VARCHAR(5),	--- Indicator Code
       MeasureName VARCHAR(50), --- Indicator Name
       Value float				--- Performance Value
)
---Sample data
---Note for testing you need to change parameter input below depending on section testing:
Insert into #SPCTestData values    ('20170401','ADU','Adult','Ind1','Indicator 1','53')
Insert into #SPCTestData values    ('20170501','ADU','Adult','Ind1','Indicator 1','51')
Insert into #SPCTestData values    ('20170601','ADU','Adult','Ind1','Indicator 1','48')
Insert into #SPCTestData values    ('20170701','ADU','Adult','Ind1','Indicator 1','20')
Insert into #SPCTestData values    ('20170801','ADU','Adult','Ind1','Indicator 1','50')
Insert into #SPCTestData values    ('20170901','ADU','Adult','Ind1','Indicator 1','80')
Insert into #SPCTestData values    ('20171001','ADU','Adult','Ind1','Indicator 1','48')
Insert into #SPCTestData values    ('20171101','ADU','Adult','Ind1','Indicator 1','47')
Insert into #SPCTestData values    ('20171201','ADU','Adult','Ind1','Indicator 1','45')
Insert into #SPCTestData values    ('20180101','ADU','Adult','Ind1','Indicator 1','43')
Insert into #SPCTestData values    ('20180201','ADU','Adult','Ind1','Indicator 1','40')
Insert into #SPCTestData values    ('20180301','ADU','Adult','Ind1','Indicator 1','35')
Insert into #SPCTestData values    ('20180401','ADU','Adult','Ind1','Indicator 1','55')
Insert into #SPCTestData values    ('20180501','ADU','Adult','Ind1','Indicator 1','30')
Insert into #SPCTestData values    ('20180601','ADU','Adult','Ind1','Indicator 1','25')
Insert into #SPCTestData values    ('20180701','ADU','Adult','Ind1','Indicator 1','22')
Insert into #SPCTestData values    ('20180801','ADU','Adult','Ind1','Indicator 1','21')
Insert into #SPCTestData values    ('20180901','ADU','Adult','Ind1','Indicator 1','61')
Insert into #SPCTestData values    ('20181001','ADU','Adult','Ind1','Indicator 1','59')
Insert into #SPCTestData values    ('20181101','ADU','Adult','Ind1','Indicator 1','60')
Insert into #SPCTestData values    ('20181201','ADU','Adult','Ind1','Indicator 1','42')
Insert into #SPCTestData values    ('20190101','ADU','Adult','Ind1','Indicator 1','58')
Insert into #SPCTestData values    ('20190201','ADU','Adult','Ind1','Indicator 1','59')
Insert into #SPCTestData values    ('20190301','ADU','Adult','Ind1','Indicator 1','61')
Insert into #SPCTestData values    ('20190401','ADU','Adult','Ind1','Indicator 1','63')
Insert into #SPCTestData values    ('20190501','ADU','Adult','Ind1','Indicator 1','65')
Insert into #SPCTestData values    ('20190601','ADU','Adult','Ind1','Indicator 1','70')
Insert into #SPCTestData values    ('20190701','ADU','Adult','Ind1','Indicator 1','59')

--Second Area Data
Insert into #SPCTestData values    ('20170401','CHI','Childrens','Ind1','Indicator 1','51')
Insert into #SPCTestData values    ('20170501','CHI','Childrens','Ind1','Indicator 1','52')
Insert into #SPCTestData values    ('20170601','CHI','Childrens','Ind1','Indicator 1','51')
Insert into #SPCTestData values    ('20170701','CHI','Childrens','Ind1','Indicator 1','50')
Insert into #SPCTestData values    ('20170801','CHI','Childrens','Ind1','Indicator 1','51')
Insert into #SPCTestData values    ('20170901','CHI','Childrens','Ind1','Indicator 1','52')
Insert into #SPCTestData values    ('20171001','CHI','Childrens','Ind1','Indicator 1','48')
Insert into #SPCTestData values    ('20171101','CHI','Childrens','Ind1','Indicator 1','47')
Insert into #SPCTestData values    ('20171201','CHI','Childrens','Ind1','Indicator 1','45')
Insert into #SPCTestData values    ('20180101','CHI','Childrens','Ind1','Indicator 1','51')
Insert into #SPCTestData values    ('20180201','CHI','Childrens','Ind1','Indicator 1','52')
Insert into #SPCTestData values    ('20180301','CHI','Childrens','Ind1','Indicator 1','50')
Insert into #SPCTestData values    ('20180401','CHI','Childrens','Ind1','Indicator 1','55')
Insert into #SPCTestData values    ('20180501','CHI','Childrens','Ind1','Indicator 1','50')
Insert into #SPCTestData values    ('20180601','CHI','Childrens','Ind1','Indicator 1','50')
Insert into #SPCTestData values    ('20180701','CHI','Childrens','Ind1','Indicator 1','52')
Insert into #SPCTestData values    ('20180801','CHI','Childrens','Ind1','Indicator 1','50')
Insert into #SPCTestData values    ('20180901','CHI','Childrens','Ind1','Indicator 1','61')
Insert into #SPCTestData values    ('20181001','CHI','Childrens','Ind1','Indicator 1','59')
Insert into #SPCTestData values    ('20181101','CHI','Childrens','Ind1','Indicator 1','60')
Insert into #SPCTestData values    ('20181201','CHI','Childrens','Ind1','Indicator 1','52')
Insert into #SPCTestData values    ('20190101','CHI','Childrens','Ind1','Indicator 1','58')
Insert into #SPCTestData values    ('20190201','CHI','Childrens','Ind1','Indicator 1','59')
Insert into #SPCTestData values    ('20190301','CHI','Childrens','Ind1','Indicator 1','61')
Insert into #SPCTestData values    ('20190401','CHI','Childrens','Ind1','Indicator 1','63')
Insert into #SPCTestData values    ('20190501','CHI','Childrens','Ind1','Indicator 1','50')
Insert into #SPCTestData values    ('20190601','CHI','Childrens','Ind1','Indicator 1','50')
Insert into #SPCTestData values    ('20190701','CHI','Childrens','Ind1','Indicator 1','59')

--Third Area Data
Insert into #SPCTestData values    ('20170401','ADU','Adult','Ind2','Indicator 2','1.5')
Insert into #SPCTestData values    ('20170501','ADU','Adult','Ind2','Indicator 2','1.1')
Insert into #SPCTestData values    ('20170601','ADU','Adult','Ind2','Indicator 2','1.2')
Insert into #SPCTestData values    ('20170701','ADU','Adult','Ind2','Indicator 2','1.3')
Insert into #SPCTestData values    ('20170801','ADU','Adult','Ind2','Indicator 2','2.3')
Insert into #SPCTestData values    ('20170901','ADU','Adult','Ind2','Indicator 2','1.8')
Insert into #SPCTestData values    ('20171001','ADU','Adult','Ind2','Indicator 2','1.9')
Insert into #SPCTestData values    ('20171101','ADU','Adult','Ind2','Indicator 2','2.7')
Insert into #SPCTestData values    ('20171201','ADU','Adult','Ind2','Indicator 2','2.7')
Insert into #SPCTestData values    ('20180101','ADU','Adult','Ind2','Indicator 2','1.9')
Insert into #SPCTestData values    ('20180201','ADU','Adult','Ind2','Indicator 2','1.9')
Insert into #SPCTestData values    ('20180301','ADU','Adult','Ind2','Indicator 2','2.3')
Insert into #SPCTestData values    ('20180401','ADU','Adult','Ind2','Indicator 2','2.1')
Insert into #SPCTestData values    ('20180501','ADU','Adult','Ind2','Indicator 2','1.5')
Insert into #SPCTestData values    ('20180601','ADU','Adult','Ind2','Indicator 2','1.0')
Insert into #SPCTestData values    ('20180701','ADU','Adult','Ind2','Indicator 2','1.1')
Insert into #SPCTestData values    ('20180801','ADU','Adult','Ind2','Indicator 2','1.1')
Insert into #SPCTestData values    ('20180901','ADU','Adult','Ind2','Indicator 2','1.4')
Insert into #SPCTestData values    ('20181001','ADU','Adult','Ind2','Indicator 2','1.2')
Insert into #SPCTestData values    ('20181101','ADU','Adult','Ind2','Indicator 2','1.7')
Insert into #SPCTestData values    ('20181201','ADU','Adult','Ind2','Indicator 2','2.8')
Insert into #SPCTestData values    ('20190101','ADU','Adult','Ind2','Indicator 2','1.6')
Insert into #SPCTestData values    ('20190201','ADU','Adult','Ind2','Indicator 2','1.9')
Insert into #SPCTestData values    ('20190301','ADU','Adult','Ind2','Indicator 2','2.6')
Insert into #SPCTestData values    ('20190401','ADU','Adult','Ind2','Indicator 2','3.1')
Insert into #SPCTestData values    ('20190501','ADU','Adult','Ind2','Indicator 2','2.0')
Insert into #SPCTestData values    ('20190601','ADU','Adult','Ind2','Indicator 2','1.8')
Insert into #SPCTestData values    ('20190701','ADU','Adult','Ind2','Indicator 2','1.5')


--Fourth Area Data
Insert into #SPCTestData values    ('20170401','CHI','Childrens','Ind2','Indicator 2','0.4')
Insert into #SPCTestData values    ('20170501','CHI','Childrens','Ind2','Indicator 2','0.2')
Insert into #SPCTestData values    ('20170601','CHI','Childrens','Ind2','Indicator 2','0.3')
Insert into #SPCTestData values    ('20170701','CHI','Childrens','Ind2','Indicator 2','0.0')
Insert into #SPCTestData values    ('20170801','CHI','Childrens','Ind2','Indicator 2','0.0')
Insert into #SPCTestData values    ('20170901','CHI','Childrens','Ind2','Indicator 2','0.2')
Insert into #SPCTestData values    ('20171001','CHI','Childrens','Ind2','Indicator 2','0.2')
Insert into #SPCTestData values    ('20171101','CHI','Childrens','Ind2','Indicator 2','0.6')
Insert into #SPCTestData values    ('20171201','CHI','Childrens','Ind2','Indicator 2','0.7')
Insert into #SPCTestData values    ('20180101','CHI','Childrens','Ind2','Indicator 2','0.8')
Insert into #SPCTestData values    ('20180201','CHI','Childrens','Ind2','Indicator 2','1.1')
Insert into #SPCTestData values    ('20180301','CHI','Childrens','Ind2','Indicator 2','0.1')
Insert into #SPCTestData values    ('20180401','CHI','Childrens','Ind2','Indicator 2','0.5')
Insert into #SPCTestData values    ('20180501','CHI','Childrens','Ind2','Indicator 2','0.0')
Insert into #SPCTestData values    ('20180601','CHI','Childrens','Ind2','Indicator 2','0.0')
Insert into #SPCTestData values    ('20180701','CHI','Childrens','Ind2','Indicator 2','0.5')
Insert into #SPCTestData values    ('20180801','CHI','Childrens','Ind2','Indicator 2','0.1')
Insert into #SPCTestData values    ('20180901','CHI','Childrens','Ind2','Indicator 2','0.5')
Insert into #SPCTestData values    ('20181001','CHI','Childrens','Ind2','Indicator 2','0.3')
Insert into #SPCTestData values    ('20181101','CHI','Childrens','Ind2','Indicator 2','0.2')
Insert into #SPCTestData values    ('20181201','CHI','Childrens','Ind2','Indicator 2','0.1')
Insert into #SPCTestData values    ('20190101','CHI','Childrens','Ind2','Indicator 2','0.0')
Insert into #SPCTestData values    ('20190201','CHI','Childrens','Ind2','Indicator 2','0.1')
Insert into #SPCTestData values    ('20190301','CHI','Childrens','Ind2','Indicator 2','0.1')
Insert into #SPCTestData values    ('20190401','CHI','Childrens','Ind2','Indicator 2','0.0')
Insert into #SPCTestData values    ('20190501','CHI','Childrens','Ind2','Indicator 2','0.2')
Insert into #SPCTestData values    ('20190601','CHI','Childrens','Ind2','Indicator 2','0.3')
Insert into #SPCTestData values    ('20190701','CHI','Childrens','Ind2','Indicator 2','0.2')

---SELECT * from #SPCTestData

CREATE TABLE #SPCTestIndicator ---Sample table to contain metadata about the metrics
(
       MeasureCode VARCHAR(5), --- Indicator Code
       Target float,		   --- IndicatorTarget
       HighImprovement bit     --- Which direction is improvement or lower pressure? 1 if high numbers, 0 if low numbers.
)

---Sample data for reference
Insert into #SPCTestIndicator values  ('Ind1','90','1')
Insert into #SPCTestIndicator values  ('Ind2','1','0')

---SELECT * from #SPCTestIndicator


/*****************************************************************************************************
2. Adding SPC Details such as Mean and Process Limits
******************************************************************************************************/

---MEAN AND MOVING RANGE

---Drop table  #SPCTestXMRChart  
SELECT 
DENSE_RANK() OVER (order by TestData.areacode, TestData.MeasureCode) AS Section, ---A Section is the individual area and indicator group			
ROW_NUMBER() OVER(PARTITION BY TestData.MeasureCode,TestData.AreaCode ORDER BY TestData.SampleDate ASC,TestData.AreaCode ASC,TestData.MeasureCode ASC) AS RowSection, ---The number of rows in the Section	
TestData.*,
M.Mean,
MR.MovingRange,
MRA.MovingRangeAverage,
M.Mean - (MovingRangeAverage * 2.66) AS LCL,  ---LOWER CONTROL LIMIT
M.Mean + (MovingRangeAverage * 2.66) AS UCL,  ---UPPER CONTROL LIMIT
CASE   WHEN TestData.Value > M.Mean THEN 1
       ELSE 0
       END 
       As [Above Mean], ---FLAG FOR VALUE ABOVE MEAN
CASE   WHEN TestData.Value < M.Mean THEN 1
       ELSE 0
       END 
       AS [Below Mean],  --FLAG FOR VALUE BELOW MEAN
TestData.Value - LAG(TestData.Value, 1) OVER (PARTITION BY TestData.MeasureCode, TestData.AreaCode ORDER BY TestData.AreaCode,TestData.MeasureCode, TestData.SampleDate) AS Diff, ---Difference between sequential values within sections.
MovingRangeAverage * 3.27 AS [MovingRangeLimit], ---MOVING RANGE LIMIT SPECIAL CAUSE VALUE 
CASE   WHEN MR.MovingRange > (MovingRangeAverage * 3.27) THEN 1
       ELSE 0
       END 
       AS [OutsideMovingRangeLimit] --- MOVING RANGE LIMIT SPECIAL CAUSE RULE FLAG 

INTO #SPCTestXMRChart  
       
FROM #SPCTestData TestData

LEFT JOIN --- Calculating Mean
              ( SELECT 
                AreaCode,
                MeasureCode,
                MeasureName,
                AVG(value) AS Mean
                FROM #SPCTestData
                GROUP BY 	
                AreaCode,
                MeasureCode,
                MeasureName
               ) M
ON M.MeasureCode = TestData.MeasureCode
AND M.AreaCode   = TestData.AreaCode

LEFT JOIN --- Calculating Moving range
              ( SELECT 
                AreaCode,
                MeasureCode, 
                SampleDate, 
                Value,
				ABS(Value - LAG(Value, 1) OVER (
										  PARTITION BY MeasureCode,AreaCode
								          ORDER BY MeasureCode,AreaCode,SampleDate)) AS MovingRange
                FROM #SPCTestData
               ) MR
ON  MR.MeasureCode = TestData.MeasureCode
AND MR.SampleDate  = TestData.SampleDate
AND MR.AreaCode    = TestData.AreaCode

LEFT JOIN --- Calculating Moving range Average
                    (
                             SELECT
                             a.AreaCode,
                             a.MeasureCode,
                             AVG(a.MovingRange) AS MovingRangeAverage
                             FROM
                                         (
                                           SELECT 
                                           MR.AreaCode,
                                           MR.MeasureCode,
                                           MR.MovingRange
                                           FROM #SPCTestData b

                                           LEFT JOIN --- Calculating Moving range
                                                                   ( SELECT 
                                                                      AreaCode,
                                                                      MeasureCode, 
                                                                      SampleDate, 
                                                                      Value,                                                                   
																	  ABS(Value - LAG(Value, 1) OVER (
																								PARTITION BY MeasureCode,AreaCode
																								ORDER BY MeasureCode,AreaCode,SampleDate)) AS MovingRange
                                                                      FROM #SPCTestData
                                                                    ) MR
                                           ON  MR.MeasureCode = b.MeasureCode
                                           AND MR.SampleDate = b.SampleDate
                                           AND MR.AreaCode = b.AreaCode
                                          ) AS a

                                  GROUP BY a.MeasureCode,
                                           a.AreaCode
                    ) AS MRA
ON MRA.MeasureCode = TestData.MeasureCode
AND MRA.AreaCode   = TestData.AreaCode

/*
SELECT * 
FROM  #SPCTestXMRChart
ORDER BY Section,RowSection
*/


/*****************************************************************************************************
3. Adding SPC Rules
******************************************************************************************************/

--drop table #SPCTestXMRChartRules

DECLARE @Counter AS INT				--- A counter used to break loop at the end of each section (Area,Indicator)
SET @Counter = 1 

DECLARE @SectionCounter AS INT		--- Used to count number of seperate sections (Area,Indicator) combinations.
SET @SectionCounter = 1 

DECLARE @SectionRecords AS INT		--- Used as count the maximun number of rows is each section (Area,Indicator)

DECLARE @SectionTotal AS INT		--- Used to count total number of seperate sections (Area,Indicator) combinations.
SET @SectionTotal = (SELECT MAX(Section) FROM #SPCTestXMRChart) --- Set to the maximun number of seperate sections (Area,Indicator) combinations.

DECLARE @PreviousValue AS INT;
SET @PreviousValue = 0;

DECLARE @PreviousMetricValue AS VARCHAR(100);
SET @PreviousMetricValue = '';

DECLARE @CurrentValue AS INT;

DECLARE @MetricValue AS VARCHAR(100);

DECLARE @PreviousValueB AS INT;
SET @PreviousValueB = 0;

DECLARE @PreviousMetricValueB AS NVARCHAR(100);
SET @PreviousMetricValueB = '';

DECLARE @CurrentValueB AS INT;
DECLARE @MetricValueB AS NVARCHAR(100);


---CREATE A BASE TABLE TO BE POPULATED
SELECT
a.*,
CASE   WHEN Value > UCL THEN 1
       WHEN Value < LCL THEN 1
       ELSE 0
       END AS [Astronomical Point],
0 AS [Above Mean Run],  
0 AS [Below Mean Run],
0 AS [Above Mean Run Group],		--- identifying 7 run or more above 
0 AS [Below Mean Run Group],		--- identifying 7 run or more below
CASE	WHEN  Diff < 0 THEN 1
		ELSE 0
		END AS [Desc],
CASE	WHEN  Diff > 0 THEN 1
		ELSE 0
		END AS [Asc],
0 AS [Desc Run],  
0 AS [Asc Run] ,
0 AS [Asc Run Group],				--- identifying 6 runs or more above
0 AS [Desc Run Group],				--- identifying 6 runs or more below
[Mean] +((2.66* [MovingRangeAverage] * 2/3)) AS [UpperTwoSigma],
[Mean] -((2.66* [MovingRangeAverage] * 2/3)) AS [LowerTwoSigma],
CASE	WHEN [Value] > ([Mean] +((2.66* [MovingRangeAverage] * 2/3))) THEN 1 
		WHEN [Value] < ([Mean] -((2.66* [MovingRangeAverage] * 2/3))) THEN 1
		ELSE 0
		End AS [BeyondTwoSigma],
0 AS [TwoOutOfThreeBeyondTwoSigma],
0 AS [TwoOutOfThree],
0 AS [TwoOutOfThreeBeyondTwoSigmaGroup] 

INTO #SPCTestXMRChartRules

FROM
		(
			SELECT * FROM #SPCTestXMRChart
		)  AS a

/*
SELECT * 
FROM  #SPCTestXMRChartRules
ORDER BY Section, RowSection, SampleDate
*/

-----ABOVE MEAN RUN LOOP------------------------------------------
WHILE(@SectionCounter <= @SectionTotal)  ---Run through all the sections (area and indicator) seperately.
BEGIN 

	set @SectionRecords = (select max(RowSection) from #SPCTestXMRChartRules where Section = @SectionCounter) ---For each section what is the number of rows within

	WHILE(@Counter <= @SectionRecords) --- change to RowSection
	--- Start of loop Above Mean Run (Cummulative calculation of Above mean which reset value to 0 when Above mean = 0)
	BEGIN


				  SELECT 
				  @CurrentValue = ISNULL([Above Mean],0)
				  FROM #SPCTestXMRChartRules
				  WHERE RowSection = @Counter AND Section = @SectionCounter ---Row and Section
						  IF @Counter = 1
								BEGIN
								SET @PreviousValue = 0  ---FOR A NEW SECTION START THE RUN AGAIN
								END      

		UPDATE #SPCTestXMRChartRules
		SET [Above Mean Run] = CASE  WHEN @CurrentValue = 0 THEN 0 ELSE (@PreviousValue + @CurrentValue) END  ---IF NOT ABOVE MEAN SET BACK TO 0 ELSE ADD 1 to PREVIOUS RUN
		WHERE RowSection = @Counter AND Section = @SectionCounter ---Row and Section
		SET @PreviousValue = (CASE WHEN (@CurrentValue = 0) THEN 0 ELSE (@PreviousValue + @CurrentValue) END)
		SET @Counter = @Counter + 1;
	END -- end of loop Above Mean Run
SET  @SectionCounter = @SectionCounter + 1;
SET  @Counter = 1;
END
-----END ABOVE MEAN RUN LOOP------------------------------------------



-----BELOW MEAN RUN LOOP------------------------------------------
SET @Counter=1
SET @SectionCounter = 1 

WHILE(@SectionCounter <= @SectionTotal)  --- Run through all the sections (area and indicator) seperately.
BEGIN 

	set @SectionRecords = (select max(RowSection) from #SPCTestXMRChartRules where Section = @SectionCounter) --- For each section what is the number of rows within

	WHILE(@Counter <= @SectionRecords)  --- change to RowSection

	BEGIN
				  SELECT @CurrentValueB = ISNULL([Below Mean],0)
				  FROM #SPCTestXMRChartRules
				  WHERE RowSection = @Counter AND Section = @SectionCounter
						IF @Counter = 1
							BEGIN
								SET @PreviousValueB = 0  ---FOR A NEW SECTION START THE RUN AGAIN
							END
						
		UPDATE #SPCTestXMRChartRules
		SET [Below Mean Run] = CASE  WHEN @CurrentValueB = 0 THEN 0 ELSE (@PreviousValueB + @CurrentValueB) END
		WHERE RowSection = @Counter AND Section = @SectionCounter
		SET @PreviousValueB = (CASE WHEN (@CurrentValueB = 0) THEN 0 ELSE (@PreviousValueB + @CurrentValueB) END)
		SET @Counter = @Counter + 1;
	END --- end of loop below Mean Run
SET  @SectionCounter = @SectionCounter + 1;
SET  @Counter = 1;
END
-----END BELOW MEAN RUN LOOP------------------------------------------

---select * from #SPCTestXMRChartRules order by 1,2


-----START ABOVE / BELOW MEAN RUN GROUP LOOP------------------------------------------

----Script to update the Above Mean Run Group and Below Mean Run Group based on identifying 6 runs below/above mean run----
 DECLARE	@AMR AS INT, --- Above mean run
			@BMR AS INT  --- Below mean run

SET @Counter = 1 
SET @SectionCounter = 1 

WHILE(@SectionCounter <= @SectionTotal)  --- Run through all the sections (area and indicator) seperately.
BEGIN 

	set @SectionRecords = (select max(RowSection) from #SPCTestXMRChartRules where Section = @SectionCounter) ---For each section what is the number of rows within

	WHILE(@Counter <= @SectionRecords)  --- change to RowSection
	
	BEGIN --- Start of loop Above/Below Mean Run Group
			SELECT @AMR = [Above Mean Run], 
				   @BMR = [Below Mean Run]
			FROM  #SPCTestXMRChartRules
			WHERE RowSection = @Counter AND Section = @SectionCounter
				IF (@AMR=0) ---check above mean run rule
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Above Mean Run Group] = 0
						WHERE  RowSection = @Counter AND Section = @SectionCounter
					END
				ELSE IF (@AMR>7) ---SET FOR SPECIAL CAUSE ABOVE MEAN 7 - CHANGE FOR LOCAL REQUIREMENT
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Above Mean Run Group]=1
						WHERE  RowSection = @Counter AND Section = @SectionCounter
					END
				ELSE IF  (@AMR=7) ---SET FOR SPECIAL CAUSE ABOVE MEAN 7 - CHANGE FOR LOCAL REQUIREMENT
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Above Mean Run Group]=1
						WHERE  RowSection BETWEEN (@Counter-6) AND @Counter AND Section = @SectionCounter ---SET FOR SPECIAL CAUSE ABOVE MEAN 7 - CHANGE FOR LOCAL REQUIREMENT
					END 
				IF (@BMR=0)  ---check below mean run rule
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Below Mean Run Group] = 0
						WHERE  RowSection = @Counter AND Section = @SectionCounter
					END
				ELSE IF (@BMR>7) ---SET FOR SPECIAL CAUSE BELOW MEAN 7 - CHANGE FOR LOCAL REQUIREMENT
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Below Mean Run Group] = 1
						WHERE  RowSection = @Counter  AND Section = @SectionCounter
					END
				ELSE IF  (@BMR=7) ---SET FOR SPECIAL CAUSE BELOW MEAN 7 - CHANGE FOR LOCAL REQUIREMENT
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Below Mean Run Group] = 1
						WHERE  RowSection BETWEEN (@Counter-6) AND @Counter AND Section = @SectionCounter ---SET FOR SPECIAL CAUSE BELOW MEAN 7 - CHANGE FOR LOCAL REQUIREMENT
					END

		SET @Counter = @Counter+1

	END -- End of loop Above/Below Mean Run Group
SET  @SectionCounter = @SectionCounter + 1;
SET  @Counter = 1;
END
-----END ABOVE / BELOW MEAN RUN GROUP LOOP------------------------------------------

--Select * from #SPCTestXMRChartRules order by 1,2


-----START TREND OF SIX IN ASC/DESC RUN LOOP------------------------------------------

-----Section for Trend of Six in ascending and decending order------------------------------

SET @Counter = 1 
SET @SectionCounter = 1 

DECLARE @PreviousValueT AS INT;
SET @PreviousValueT = 0;

DECLARE @PreviousMetricValueT AS VARCHAR(100);
SET @PreviousMetricValueT = '';

DECLARE @CurrentValueT AS INT;

DECLARE @MetricValueT AS VARCHAR(100);

DECLARE @PreviousValueTS AS INT;
SET @PreviousValueTS = 0;

DECLARE @PreviousMetricValueTS AS NVARCHAR(100);
SET @PreviousMetricValueTS = '';

DECLARE @CurrentValueTS AS INT;
DECLARE @MetricValueTS AS NVARCHAR(100);

WHILE(@SectionCounter <= @SectionTotal)
BEGIN 

	set @SectionRecords = (select max(RowSection) from #SPCTestXMRChartRules where Section = @SectionCounter) ---For each section what is the number of rows within

	WHILE(@Counter <= @SectionRecords) 
	-- Start of loop Asc Run (Cummulative calculation of Asc which reset value to 0 when Asc = 0)
	BEGIN
				  SELECT 
				  @CurrentValueT = ISNULL([Asc],0)
				  FROM #SPCTestXMRChartRules
				  WHERE RowSection = @Counter AND Section = @SectionCounter

						  IF @Counter= 1
								BEGIN
								SET @PreviousValueT = 0  ---FOR A NEW SECTION START THE RUN AGAIN
								END


		Update #SPCTestXMRChartRules
		SET [Asc Run] = case  when @CurrentValueT = 0 then 0 else (@PreviousValueT + @CurrentValueT) end
		WHERE RowSection = @Counter AND Section = @SectionCounter
		SET @PreviousValueT = (case when (@CurrentValueT = 0) then 0 else (@PreviousValueT + @CurrentValueT) end)
		SET @Counter = @Counter + 1;

	END -- end of loop Asc Run
SET  @SectionCounter = @SectionCounter + 1;
SET  @Counter = 1;
END


SET @Counter=1
SET @SectionCounter = 1 

WHILE(@SectionCounter <= @SectionTotal)
BEGIN 

	set @SectionRecords = (select max(RowSection) from #SPCTestXMRChartRules where Section = @SectionCounter) ---For each section what is the number of rows within

	WHILE(@Counter <= @SectionRecords) 
	-- Start of loop Desc Run (Cummulative calculation of Below mean which reset value to 0 when Above mean = 0)
	BEGIN
				  SELECT @CurrentValueTS = ISNULL([Desc],0)
				  FROM #SPCTestXMRChartRules
				  WHERE RowSection = @Counter AND Section = @SectionCounter

					IF @Counter = 1
						BEGIN
					SET @PreviousValueTS = 0  ---FOR A NEW SECTION START THE RUN AGAIN
						END

		UPDATE #SPCTestXMRChartRules
		SET [Desc Run] = CASE  WHEN @CurrentValueTS = 0 THEN 0 ELSE (@PreviousValueTS + @CurrentValueTS) END
		WHERE RowSection = @Counter AND Section = @SectionCounter
		SET @PreviousValueTS = (CASE WHEN (@CurrentValueTS = 0) THEN 0 ELSE (@PreviousValueTS + @CurrentValueTS) END)
		SET @Counter = @Counter + 1;

	END --end of loop Desc Run
SET  @SectionCounter = @SectionCounter + 1;
SET  @Counter = 1;
END

-----END TREND OF SIX IN ASC/DESC RUN LOOP------------------------------------------

--Select * from #SPCTestXMRChartRules order by 1,2
-----------------**********************-----------------


-----START TREND OF SIX IN ASC/DESC RUN GROUP LOOP------------------------------------------

----Script to update the Asc Run Group and Desc Run Group based on identifying 6 runs below/above mean run--------------------------------------------------------
 
 DECLARE	@AR AS INT, ---Ascending
			@DR AS INT  ---Desc

SET @Counter = 1 
SET @SectionCounter = 1 

WHILE(@SectionCounter <= @SectionTotal)
BEGIN 
	set @SectionRecords = (select max(RowSection) from #SPCTestXMRChartRules where Section = @SectionCounter) ---For each section what is the number of rows within


	WHILE(@Counter <= @SectionRecords) 

	BEGIN --- Start of loop ASC/DESC Mean Run Group
			SELECT @AR = [Asc Run], 
				   @DR = [Desc Run]
			FROM  #SPCTestXMRChartRules
			WHERE RowSection = @Counter AND Section = @SectionCounter

				IF (@AR=0)
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Asc Run Group] = 0
						WHERE  RowSection = @Counter AND Section = @SectionCounter
					END
				ELSE IF (@AR>5) ---SET FOR SPECIAL CAUSE ASCENDING 6 - CHANGE FOR LOCAL REQUIREMENT
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Asc Run Group] = 1
						WHERE  RowSection = @Counter AND Section = @SectionCounter
					END
				ELSE IF  (@AR=5) ---SET FOR SPECIAL CAUSE ASCENDING 6 - CHANGE FOR LOCAL REQUIREMENT
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Asc Run Group] = 1
						WHERE  RowSection BETWEEN (@Counter-4) AND @Counter AND Section = @SectionCounter ---SET FOR SPECIAL CAUSE ASCENDING 6 - CHANGE FOR LOCAL REQUIREMENT
					END 

				IF (@DR=0)
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Desc Run Group] = 0
						WHERE  RowSection = @Counter AND Section = @SectionCounter
					END
				ELSE IF (@DR>5) ---SET FOR SPECIAL CAUSE DESCENDING 6 - CHANGE FOR LOCAL REQUIREMENT
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Desc Run Group] = 1
						WHERE  RowSection = @Counter AND Section = @SectionCounter
					END
				ELSE IF  (@DR=5) ---SET FOR SPECIAL CAUSE DESCENDING 6 - CHANGE FOR LOCAL REQUIREMENT
					BEGIN
						UPDATE #SPCTestXMRChartRules
						SET [Desc Run Group] = 1
						WHERE  RowSection BETWEEN (@Counter-4) AND @Counter AND Section = @SectionCounter ---SET FOR SPECIAL CAUSE DESCENDING 6 - CHANGE FOR LOCAL REQUIREMENT
					END

		SET @Counter = @Counter+1

	END --End of loop ASC/Desc Run Group
SET  @SectionCounter = @SectionCounter + 1;
SET  @Counter = 1;
END

-----END TREND OF SIX IN ASC/DESC RUN GROUP LOOP------------------------------------------


---TwoOfThreeBeyongTwoSigma and group----------------------------------------------------

-----START TWO-OF-THREE BEYONG TWO SIGMA RUN GROUP LOOP------------------------------------------
SET @Counter = 1;
SET @SectionCounter = 1 

DECLARE @BeyondTwoSigmaValue AS INT;
DECLARE @LastTwoSum AS INT;
DECLARE @LastThreeSum AS INT;
DECLARE @BeyondTwoSigmaCounter AS INT;
DECLARE @MeasureCodeValue AS NVARCHAR(100);
DECLARE @PreviousMeasureCodeValue AS NVARCHAR(100);
SET @PreviousMeasureCodeValue = '';

SET @BeyondTwoSigmaCounter = 1;

WHILE(@SectionCounter <= @SectionTotal)
BEGIN 
	set @SectionRecords = (select max(RowSection) from #SPCTestXMRChartRules where Section = @SectionCounter) ---For each section what is the number of rows within


	WHILE(@Counter <= @SectionRecords) 

	BEGIN --Start of loop TwoOutOfThreeBeyongSigma Run Group
			SELECT @BeyondTwoSigmaValue = ISNULL([BeyondTwoSigma],0) 
			FROM #SPCTestXMRChartRules
			WHERE RowSection= @Counter	AND Section = @SectionCounter	

				IF (@BeyondTwoSigmaCounter = 1)
					BEGIN
						SET @PreviousMeasureCodeValue = @MeasureCodeValue;
						SET @LastTwoSum = @BeyondTwoSigmaValue;
						SET @LastThreeSum = @BeyondTwoSigmaValue;
					END
				ELSE IF (@BeyondTwoSigmaCounter = 2)
					BEGIN
						SET @LastTwoSum = @LastTwoSum + @BeyondTwoSigmaValue;
						SET @LastThreeSum = @LastTwoSum;
					END
				ELSE
					BEGIN			
						SET @LastTwoSum = @LastTwoSum + @BeyondTwoSigmaValue;
						SET @LastThreeSum = @LastThreeSum + @BeyondTwoSigmaValue;			
					END

				IF @Counter = 1
					BEGIN
						SET @BeyondTwoSigmaCounter = 0;
					--reset other values
						SET @LastTwoSum = @BeyondTwoSigmaValue;
						SET @LastThreeSum = @BeyondTwoSigmaValue;
					END

			UPDATE #SPCTestXMRChartRules
			SET TwoOutOfThreeBeyondTwoSigma = @LastThreeSum , 
			TwoOutOfThree = CASE WHEN @LastThreeSum > 1 THEN 1 ELSE 0 END		
			WHERE RowSection = @Counter AND Section = @SectionCounter

				IF @LastThreeSum > 1
					BEGIN
						UPDATE #SPCTestXMRChartRules		
						SET TwoOutOfThreeBeyondTwoSigmaGroup = 1
						WHERE RowSection BETWEEN (@Counter - 2) AND @Counter AND Section = @SectionCounter
					END
		
			SET @LastThreeSum = @LastTwoSum;
			SET @LastTwoSum = @BeyondTwoSigmaValue;
				--incrementing @Counter
			SET @Counter = @Counter + 1;
				--incrementing @BeyondTwoSigmaCounter
			SET @BeyondTwoSigmaCounter = @BeyondTwoSigmaCounter + 1;

	END --End of loop TwoOutOfThreeBeyongSigma Run Group
SET  @SectionCounter = @SectionCounter + 1;
SET  @Counter = 1;
END

-----END TWO-OF-THREE BEYONG TWO SIGMA RUN GROUP LOOP------------------------------------------

/*
SELECT * FROM  #SPCTestXMRChartRules
order by Section,RowSection,SampleDate
*/


/*****************************************************************************************************
4. Output Table
******************************************************************************************************/

SELECT 
SampleDate,
AreaCode,
AreaName,
SR.MeasureCode,
SR.MeasureName,
TI.HighImprovement,
TI.Target,
Value,
Mean,
MovingRange,
MovingRangeAverage,
LCL,
UCL,
MovingRangeLimit,
OutsideMovingRangeLimit,
[Astronomical Point] AS [Outside_Control_Limit],
[Above Mean Run Group],
[Below Mean Run Group],
[Asc Run Group], 
[Desc Run Group],
[TwoOutOfThreeBeyondTwoSigmaGroup] as [TwoOutOfThreeBeyondTwoSigma],
CASE	WHEN ([Above Mean Run Group] = 1 OR [Below Mean Run Group] = 1 OR OutsideMovingRangeLimit = 1 OR [Astronomical Point] = 1 OR [Asc Run Group] = 1 OR [Desc Run Group] = 1  OR [TwoOutOfThreeBeyondTwoSigmaGroup] = 1 )
		THEN 1
		Else 0
END AS SpecialCauseFlag,
CASE	--NOTE -DETERMINE ORDER OF RULES LOCALLY FOR CONFLICTING IMPROVEMENT 
		--Astronomical point
		WHEN ([Astronomical Point] = 1 AND [VALUE] > [UCL] AND TI.HighImprovement = 1) THEN 'Improvement' ---Improvement above UCL
		WHEN ([Astronomical Point] = 1 AND [VALUE] > [UCL] AND TI.HighImprovement = 0) THEN 'Concern' ---Concern above UCL
		WHEN ([Astronomical Point] = 1 AND [VALUE] < [LCL] AND TI.HighImprovement = 1) THEN 'Concern' ---Concern below LCL
		WHEN ([Astronomical Point] = 1 AND [VALUE] < [LCL] AND TI.HighImprovement = 0) THEN 'Improvement' ---Improvement below LCL
		--Ascending or decending
		WHEN ([Asc Run Group] = 1 AND  TI.HighImprovement = 1) THEN 'Improvement'	---Improvement due to ascending order
		WHEN ([Asc Run Group] = 1 AND  TI.HighImprovement = 0) THEN  'Concern'		---Concern due to ascending order
		WHEN ([Desc Run Group] = 1 AND  TI.HighImprovement = 1) THEN 'Concern'		---Concern due to descending order
		WHEN ([Desc Run Group] = 1 AND  TI.HighImprovement = 0) THEN 'Improvement' ---Improvement due to descending order
		--Above or below mean
		WHEN ([Above Mean Run Group] = 1 AND  TI.HighImprovement = 1) THEN 'Improvement' ---Improvement above Mean Run
		WHEN ([Above Mean Run Group] = 1 AND  TI.HighImprovement = 0) THEN 'Concern'	 ---Concern above Mean Run
		WHEN ([Below Mean Run Group] = 1 AND  TI.HighImprovement = 1) THEN 'Concern'	 ---Concern below Mean Run
		WHEN ([Below Mean Run Group] = 1 AND  TI.HighImprovement = 0) THEN 'Improvement' ---Improvement below Mean Run
		---Two out of three beyond two sigma
		WHEN ([TwoOutOfThreeBeyondTwoSigmaGroup] = 1 AND [VALUE] > [MEAN] AND TI.HighImprovement = 1) THEN 'Improvement'	---Two out of three Improvement above Mean
		WHEN ([TwoOutOfThreeBeyondTwoSigmaGroup] = 1 AND [VALUE] > [MEAN] AND TI.HighImprovement = 0) THEN 'Concern'		---Two out of three Moving Range Concern above Mean
		WHEN ([TwoOutOfThreeBeyondTwoSigmaGroup] = 1 AND [VALUE] < [MEAN] AND TI.HighImprovement = 1) THEN 'Concern'		---Two out of three Concern below Mean
		WHEN ([TwoOutOfThreeBeyondTwoSigmaGroup] = 1 AND [VALUE] < [MEAN] AND TI.HighImprovement = 0) THEN 'Improvement'	---Two out of three Improvrment below Mean
		--Moving Range
		WHEN ([OutsideMovingRangeLimit] = 1 AND [VALUE] > [MEAN] AND TI.HighImprovement = 1) THEN 'Improvement' ---Moving range Improvement above Mean
		WHEN ([OutsideMovingRangeLimit] = 1 AND [VALUE] > [MEAN] AND TI.HighImprovement = 0) THEN 'Concern'		---Moving Range Concern above Mean
		WHEN ([OutsideMovingRangeLimit] = 1 AND [VALUE] < [MEAN] AND TI.HighImprovement = 1) THEN 'Concern'		---Moving range Concern below Mean
		WHEN ([OutsideMovingRangeLimit] = 1 AND [VALUE] < [MEAN] AND TI.HighImprovement = 0) THEN 'Improvement' ---Moving Range Improvment below Mean

		Else 'Common Cause'
END AS VariationType,
CASE	--- NOTE -DETERMINE ORDER OF RULES LOCALLY FOR CONFLICTING IMPROVEMENT 
		--- Astronomical point
		WHEN ([Astronomical Point] = 1 AND [VALUE] > [UCL] AND TI.HighImprovement = 1) THEN 'Improvement (High)' --- Improvement above UCL
		WHEN ([Astronomical Point] = 1 AND [VALUE] > [UCL] AND TI.HighImprovement = 0) THEN 'Concern (High)' --- Concern above UCL
		WHEN ([Astronomical Point] = 1 AND [VALUE] < [LCL] AND TI.HighImprovement = 1) THEN 'Concern (Low)' --- Concern below LCL
		WHEN ([Astronomical Point] = 1 AND [VALUE] < [LCL] AND TI.HighImprovement = 0) THEN 'Improvement (Low)' --- Improvement below LCL
		--- Ascending or decending
		WHEN ([Asc Run Group] = 1 AND  TI.HighImprovement = 1) THEN 'Improvement (High)'	--- Improvement due to ascending order
		WHEN ([Asc Run Group] = 1 AND  TI.HighImprovement = 0) THEN  'Concern (High)'		--- Concern due to ascending order
		WHEN ([Desc Run Group] = 1 AND  TI.HighImprovement = 1) THEN 'Concern (Low)'		--- Concern due to descending order
		WHEN ([Desc Run Group] = 1 AND  TI.HighImprovement = 0) THEN 'Improvement (Low)'  --- Improvement due to descending order
		--- Above or below mean
		WHEN ([Above Mean Run Group] = 1 AND  TI.HighImprovement = 1) THEN 'Improvement (High)' --- Improvement above Mean Run
		WHEN ([Above Mean Run Group] = 1 AND  TI.HighImprovement = 0) THEN 'Concern (High)'	 --- Concern above Mean Run
		WHEN ([Below Mean Run Group] = 1 AND  TI.HighImprovement = 1) THEN 'Concern (Low)'	 --- Concern below Mean Run
		WHEN ([Below Mean Run Group] = 1 AND  TI.HighImprovement = 0) THEN 'Improvement (Low)' --- Improvement below Mean Run
		--- Two out of three beyond two sigma
		WHEN ([TwoOutOfThreeBeyondTwoSigmaGroup] = 1 AND [VALUE] > [MEAN] AND TI.HighImprovement = 1) THEN 'Improvement (High)'	--- Two out of three Improvement above Mean
		WHEN ([TwoOutOfThreeBeyondTwoSigmaGroup] = 1 AND [VALUE] > [MEAN] AND TI.HighImprovement = 0) THEN 'Concern (High)'		--- Two out of three Moving Range Concern above Mean
		WHEN ([TwoOutOfThreeBeyondTwoSigmaGroup] = 1 AND [VALUE] < [MEAN] AND TI.HighImprovement = 1) THEN 'Concern (Low)'		--- Two out of three Concern below Mean
		WHEN ([TwoOutOfThreeBeyondTwoSigmaGroup] = 1 AND [VALUE] < [MEAN] AND TI.HighImprovement = 0) THEN 'Improvement (Low)'	--- Two out of three Improvrment below Mean
		--- Moving Range
		WHEN ([OutsideMovingRangeLimit] = 1 AND [VALUE] > [MEAN] AND TI.HighImprovement = 1) THEN 'Improvement (High)' --- Moving range Improvement above Mean
		WHEN ([OutsideMovingRangeLimit] = 1 AND [VALUE] > [MEAN] AND TI.HighImprovement = 0) THEN 'Concern (High)'		--- Moving Range Concern above Mean
		WHEN ([OutsideMovingRangeLimit] = 1 AND [VALUE] < [MEAN] AND TI.HighImprovement = 1) THEN 'Concern (Low)'		--- Moving range Concern below Mean
		WHEN ([OutsideMovingRangeLimit] = 1 AND [VALUE] < [MEAN] AND TI.HighImprovement = 0) THEN 'Improvement (Low)' --- Moving Range Improvment below Mean

		Else 'Common Cause'
END AS VariationTypeIcon,

Case
		WHEN (TI.Target >= LCL and TI.Target <= UCL) then 'Unreliable'---If between upper and lower control limit regardless of desired direction we will unreliably hit the target
		WHEN (TI.Target > UCL and TI.HighImprovement = 1) then 'Not capable' ---Not capable of hitting the target if target greater than UCL and higher numbers is desired direction
		WHEN (TI.Target < LCL and TI.HighImprovement = 0) then 'Not capable' ---Not capable of hitting the target if target lower than LCL and lower numbers is desired direction
		WHEN (TI.Target < LCL and TI.HighImprovement = 1) then 'Capable' ---Capable of hitting the target if target is less than LCL and higher numbers is desired direction
		WHEN (TI.Target > UCL and TI.HighImprovement = 0) then 'Capable' ---Capable of hitting the target if target greater than UCL and lower numbers is desired direction		
else null
End as CapabilityIcon 

INTO #SPCTestXMRChartRules_Extract

FROM #SPCTestXMRChartRules AS SR

---Join back to indicator table to determine if special cause is due to improvment or decline---
LEFT JOIN #SPCTestIndicator AS TI
		ON  SR.MeasureCode = TI.MeasureCode


SELECT * FROM #SPCTestXMRChartRules_Extract
ORDER BY MeasureCode,AreaCode,SampleDate

---Second Output table (deep)---------

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'Target' as DataType,
Target as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon

into #SPCTestXMRChartRules_Extract_Deep

FROM #SPCTestXMRChartRules_Extract

Union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'Value' as DataType,
Value as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'Mean' as DataType,
Mean as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'MovingRange' as DataType,
MovingRange as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'MovingRangeAverage' as DataType,
MovingRangeAverage as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'LCL' as DataType,
LCL as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'UCL' as DataType,
UCL as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'MovingRangeLimit' as DataType,
MovingRangeLimit as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'OutsideMovingRangeLimit' as DataType,
OutsideMovingRangeLimit as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'Outside_Control_Limit' as DataType,
Outside_Control_Limit as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'Above Mean Run Group' as DataType,
[Above Mean Run Group] as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'Below Mean Run Group' as DataType,
[Below Mean Run Group] as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'Asc Mean Run Group' as DataType,
[Below Mean Run Group] as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'Desc Mean Run Group' as DataType,
[Below Mean Run Group] as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'TwoOutOfThreeBeyondTwoSigma' as DataType,
[TwoOutOfThreeBeyondTwoSigma] as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 

union

SELECT 
SampleDate,
AreaCode,
AreaName,
MeasureCode,
MeasureName,
HighImprovement,
'SpecialCauseFlag' as SpecialCauseFlag,
[SpecialCauseFlag] as Value,
VariationType,
VariationTypeIcon,
CapabilityIcon
FROM #SPCTestXMRChartRules_Extract 


select * from #SPCTestXMRChartRules_Extract_Deep
