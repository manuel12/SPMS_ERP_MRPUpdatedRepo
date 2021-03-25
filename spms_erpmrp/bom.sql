DECLARE
@level int;



--create working table

SELECT ParentPart as StockCode, CAST(0 as int) As Lev, CAST(10 as float) as Reqd, CAST(1 as int) as Mnth

INTO #tmp

FROM BomStructure

WHERE 1=0;



--insert all the models and requirements

SET @level = 0;



INSERT INTO #tmp
VALUES('DAD261', @level, 1860, 1);


------------------------------------------------------------------------
--This example inserts two top level assemblies into a temporary table along
--with the number of each model required for 12 months in advance, and by
--and by doing so it calculates the budgeted quantity of each bought out
--component required by an assembly type factory or process pivoted for a
--12 month look ahead period.
------------------------------------------------------------------------
--The technique used here is much more efficient that using a recursive
--common table expression (CTE), but it cannot list a bill of materials
--in hierarchical order. It could be possible to list in this order with a few
--modifications.
--It calculates the requirements for components on a level-by-level basis. The
--initial level is set to zero, and the top level items are inserted at this level --into a temporary table. Each successive level is grabbed from a BOM structure
-- table where each line represents a parent/child pair. Each successive level
--looks at the previously appended level and multiplies the requirement for the

--parent (from the previous level) with the new items found in the structure
--table until no more items are returned from the structure table.
------------------------------------------------------------------------


DECLARE
@level int;

 

--create working table

SELECT ParentPart as StockCode, CAST(0 as int) As Lev, CAST(10 as float) as Reqd, CAST(1 as int) as Mnth

INTO #tmp

FROM BomStructure

WHERE 1=0;

 

--insert all the models and requirements

SET @level = 0;

 

INSERT INTO #tmp VALUES('DAD261',@level,1860,1);

INSERT INTO #tmp VALUES('DAD261',@level,1860,2);

INSERT INTO #tmp VALUES('DAD261',@level,4000,3);

INSERT INTO #tmp VALUES('DAD261',@level,2142,4);

INSERT INTO #tmp VALUES('DAD261',@level,2289,5);

INSERT INTO #tmp VALUES('DAD261',@level,2289,6);

INSERT INTO #tmp VALUES('DAD261',@level,4000,7);

INSERT INTO #tmp VALUES('DAD261',@level,3000,8);

INSERT INTO #tmp VALUES('DAD261',@level,3969,9);

INSERT INTO #tmp VALUES('DAD261',@level,3780,10);

INSERT INTO #tmp VALUES('DAD261',@level,3806,11);

INSERT INTO #tmp VALUES('DAD261',@level,826,12);

INSERT INTO #tmp VALUES('DAD262',@level,820,1);

INSERT INTO #tmp VALUES('DAD262',@level,820,2);

INSERT INTO #tmp VALUES('DAD262',@level,820,3);

INSERT INTO #tmp VALUES('DAD262',@level,2000,4);

INSERT INTO #tmp VALUES('DAD262',@level,2289,5);

INSERT INTO #tmp VALUES('DAD262',@level,2289,6);

INSERT INTO #tmp VALUES('DAD262',@level,820,7);

INSERT INTO #tmp VALUES('DAD262',@level,1578,8);

INSERT INTO #tmp VALUES('DAD262',@level,600,9);

INSERT INTO #tmp VALUES('DAD262',@level,800,10);

INSERT INTO #tmp VALUES('DAD262',@level,1000,11);

INSERT INTO #tmp VALUES('DAD262',@level,700,12);

 

--loop through each matching level in the BOM table
WHILE (@@RowCount > 0) AND (@level < 15)
BEGIN

      SET @level = @level + 1;

      INSERT INTO #tmp

      SELECT B.Component, @level , A.Reqd * B.QtyPer, A.Mnth

      FROM BomStructure B JOIN #tmp A

      ON A.StockCode = B.ParentPart

      JOIN InvMaster I

      ON I.StockCode = B.ParentPart

      WHERE A.Lev = @level - 1

      AND ((B.StructureOffDate IS NULL) OR (B.StructureOffDate >=GetDate()))

      AND ((B.StructureOnDate IS NULL) OR (B.StructureOnDate <= GetDate()))

      AND B.Route='0'

      AND I.PartCategory <> 'B'

     

END;

 

-- This example uses a pivot inside a CTE, so we can process the CTE further

WITH MyCTE

AS

(

      SELECT *

      FROM #tmp AS Result

      PIVOT

      (

         SUM(Reqd)

            FOR Mnth IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])

      ) AS PVT

)

 
SELECT * FROM MyCTE;

DROP TABLE #tmp
GO

INSERT INTO #tmp
VALUES('DAD261', @level, 2142, 4);

INSERT INTO #tmp
VALUES('DAD261', @level, 2289, 5);

INSERT INTO #tmp
VALUES('DAD261', @level, 2289, 6);

INSERT INTO #tmp
VALUES('DAD261', @level, 4000, 7);

INSERT INTO #tmp
VALUES('DAD261', @level, 3000, 8);

INSERT INTO #tmp
VALUES('DAD261', @level, 3969, 9);

INSERT INTO #tmp
VALUES('DAD261', @level, 3780, 10);

INSERT INTO #tmp
VALUES('DAD261', @level, 3806, 11);

INSERT INTO #tmp
VALUES('DAD261', @level, 826, 12);

INSERT INTO #tmp
VALUES('DAD262', @level, 820, 1);

INSERT INTO #tmp
VALUES('DAD262', @level, 820, 2);

INSERT INTO #tmp
VALUES('DAD262', @level, 820, 3);

INSERT INTO #tmp
VALUES('DAD262', @level, 2000, 4);

INSERT INTO #tmp
VALUES('DAD262', @level, 2289, 5);

INSERT INTO #tmp
VALUES('DAD262', @level, 2289, 6);

INSERT INTO #tmp
VALUES('DAD262', @level, 820, 7);

INSERT INTO #tmp
VALUES('DAD262', @level, 1578, 8);

INSERT INTO #tmp
VALUES('DAD262', @level, 600, 9);

INSERT INTO #tmp
VALUES('DAD262', @level, 800, 10);

INSERT INTO #tmp

------------------------------------------------------------------------
--This example inserts two top level assemblies into a temporary table along
--with the number of each model required for 12 months in advance, and by
--and by doing so it calculates the budgeted quantity of each bought out
--component required by an assembly type factory or process pivoted for a
--12 month look ahead period.
------------------------------------------------------------------------
--The technique used here is much more efficient that using a recursive
--common table expression (CTE), but it cannot list a bill of materials
--in hierarchical order. It could be possible to list in this order with a few
--modifications.
--It calculates the requirements for components on a level-by-level basis. The
--initial level is set to zero, and the top level items are inserted at this level --into a temporary table. Each successive level is grabbed from a BOM structure
-- table where each line represents a parent/child pair. Each successive level
--looks at the previously appended level and multiplies the requirement for the

--parent (from the previous level) with the new items found in the structure
--table until no more items are returned from the structure table.
------------------------------------------------------------------------


DECLARE
@level int;

 

--create working table

SELECT ParentPart as StockCode, CAST(0 as int) As Lev, CAST(10 as float) as Reqd, CAST(1 as int) as Mnth

INTO #tmp

FROM BomStructure

WHERE 1=0;

 

--insert all the models and requirements

SET @level = 0;

 

INSERT INTO #tmp VALUES('DAD261',@level,1860,1);

INSERT INTO #tmp VALUES('DAD261',@level,1860,2);

INSERT INTO #tmp VALUES('DAD261',@level,4000,3);

INSERT INTO #tmp VALUES('DAD261',@level,2142,4);

INSERT INTO #tmp VALUES('DAD261',@level,2289,5);

INSERT INTO #tmp VALUES('DAD261',@level,2289,6);

INSERT INTO #tmp VALUES('DAD261',@level,4000,7);

INSERT INTO #tmp VALUES('DAD261',@level,3000,8);

INSERT INTO #tmp VALUES('DAD261',@level,3969,9);

INSERT INTO #tmp VALUES('DAD261',@level,3780,10);

INSERT INTO #tmp VALUES('DAD261',@level,3806,11);

INSERT INTO #tmp VALUES('DAD261',@level,826,12);

INSERT INTO #tmp VALUES('DAD262',@level,820,1);

INSERT INTO #tmp VALUES('DAD262',@level,820,2);

INSERT INTO #tmp VALUES('DAD262',@level,820,3);

INSERT INTO #tmp VALUES('DAD262',@level,2000,4);

INSERT INTO #tmp VALUES('DAD262',@level,2289,5);

INSERT INTO #tmp VALUES('DAD262',@level,2289,6);

INSERT INTO #tmp VALUES('DAD262',@level,820,7);

INSERT INTO #tmp VALUES('DAD262',@level,1578,8);

INSERT INTO #tmp VALUES('DAD262',@level,600,9);

INSERT INTO #tmp VALUES('DAD262',@level,800,10);

INSERT INTO #tmp VALUES('DAD262',@level,1000,11);

INSERT INTO #tmp VALUES('DAD262',@level,700,12);

 

--loop through each matching level in the BOM table
WHILE (@@RowCount > 0) AND (@level < 15)
BEGIN

      SET @level = @level + 1;

      INSERT INTO #tmp

      SELECT B.Component, @level , A.Reqd * B.QtyPer, A.Mnth

      FROM BomStructure B JOIN #tmp A

      ON A.StockCode = B.ParentPart

      JOIN InvMaster I

      ON I.StockCode = B.ParentPart

      WHERE A.Lev = @level - 1

      AND ((B.StructureOffDate IS NULL) OR (B.StructureOffDate >=GetDate()))

      AND ((B.StructureOnDate IS NULL) OR (B.StructureOnDate <= GetDate()))

      AND B.Route='0'

      AND I.PartCategory <> 'B'

     

END;

 

-- This example uses a pivot inside a CTE, so we can process the CTE further

WITH MyCTE

AS

(

      SELECT *

      FROM #tmp AS Result

      PIVOT

      (

         SUM(Reqd)

            FOR Mnth IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])

      ) AS PVT

)

 
SELECT * FROM MyCTE;

DROP TABLE #tmp
GO
VALUES('DAD262', @level, 1000, 11);

INSERT INTO #tmp
VALUES('DAD262', @level, 700, 12);



--loop through each matching level in the BOM table
WHILE (@@RowCount > 0) AND (@level < 15)
BEGIN

  SET @level = @level + 1;

  INSERT INTO #tmp

  SELECT B.Component, @level , A.Reqd * B.QtyPer, A.Mnth

  FROM BomStructure B JOIN #tmp A

    ON A.StockCode = B.ParentPart

    JOIN InvMaster I

------------------------------------------------------------------------
--This example inserts two top level assemblies into a temporary table along
--with the number of each model required for 12 months in advance, and by
--and by doing so it calculates the budgeted quantity of each bought out
--component required by an assembly type factory or process pivoted for a
--12 month look ahead period.
------------------------------------------------------------------------
--The technique used here is much more efficient that using a recursive
--common table expression (CTE), but it cannot list a bill of materials
--in hierarchical order. It could be possible to list in this order with a few
--modifications.
--It calculates the requirements for components on a level-by-level basis. The
--initial level is set to zero, and the top level items are inserted at this level --into a temporary table. Each successive level is grabbed from a BOM structure
-- table where each line represents a parent/child pair. Each successive level
--looks at the previously appended level and multiplies the requirement for the

--parent (from the previous level) with the new items found in the structure
--table until no more items are returned from the structure table.
------------------------------------------------------------------------


DECLARE
@level int;

 

--create working table

SELECT ParentPart as StockCode, CAST(0 as int) As Lev, CAST(10 as float) as Reqd, CAST(1 as int) as Mnth

INTO #tmp

FROM BomStructure

WHERE 1=0;

 

--insert all the models and requirements

SET @level = 0;

 

INSERT INTO #tmp VALUES('DAD261',@level,1860,1);

INSERT INTO #tmp VALUES('DAD261',@level,1860,2);

INSERT INTO #tmp VALUES('DAD261',@level,4000,3);

INSERT INTO #tmp VALUES('DAD261',@level,2142,4);

INSERT INTO #tmp VALUES('DAD261',@level,2289,5);

INSERT INTO #tmp VALUES('DAD261',@level,2289,6);

INSERT INTO #tmp VALUES('DAD261',@level,4000,7);

INSERT INTO #tmp VALUES('DAD261',@level,3000,8);

INSERT INTO #tmp VALUES('DAD261',@level,3969,9);

INSERT INTO #tmp VALUES('DAD261',@level,3780,10);

INSERT INTO #tmp VALUES('DAD261',@level,3806,11);

INSERT INTO #tmp VALUES('DAD261',@level,826,12);

INSERT INTO #tmp VALUES('DAD262',@level,820,1);

INSERT INTO #tmp VALUES('DAD262',@level,820,2);

INSERT INTO #tmp VALUES('DAD262',@level,820,3);

INSERT INTO #tmp VALUES('DAD262',@level,2000,4);

INSERT INTO #tmp VALUES('DAD262',@level,2289,5);

INSERT INTO #tmp VALUES('DAD262',@level,2289,6);

INSERT INTO #tmp VALUES('DAD262',@level,820,7);

INSERT INTO #tmp VALUES('DAD262',@level,1578,8);

INSERT INTO #tmp VALUES('DAD262',@level,600,9);

INSERT INTO #tmp VALUES('DAD262',@level,800,10);

INSERT INTO #tmp VALUES('DAD262',@level,1000,11);

INSERT INTO #tmp VALUES('DAD262',@level,700,12);

 

--loop through each matching level in the BOM table
WHILE (@@RowCount > 0) AND (@level < 15)
BEGIN

      SET @level = @level + 1;

      INSERT INTO #tmp

      SELECT B.Component, @level , A.Reqd * B.QtyPer, A.Mnth

      FROM BomStructure B JOIN #tmp A

      ON A.StockCode = B.ParentPart

      JOIN InvMaster I

      ON I.StockCode = B.ParentPart

      WHERE A.Lev = @level - 1

      AND ((B.StructureOffDate IS NULL) OR (B.StructureOffDate >=GetDate()))

      AND ((B.StructureOnDate IS NULL) OR (B.StructureOnDate <= GetDate()))

      AND B.Route='0'

      AND I.PartCategory <> 'B'

     

END;

 

-- This example uses a pivot inside a CTE, so we can process the CTE further

WITH MyCTE

AS

(

      SELECT *

      FROM #tmp AS Result

      PIVOT

      (

         SUM(Reqd)

            FOR Mnth IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])

      ) AS PVT

)

 
SELECT * FROM MyCTE;

DROP TABLE #tmp
GO

    ON I.StockCode = B.ParentPart

  WHERE A.Lev = @level - 1

    AND ((B.StructureOffDate IS NULL) OR (B.StructureOffDate >=GetDate()))

    AND ((B.StructureOnDate IS NULL) OR (B.StructureOnDate <= GetDate()))

    AND B.Route='0'

    AND I.PartCategory <> 'B'



END;

SELECT Count(1)
FROM   Production.Product P
WHERE  P.SellEndDate is NULL
       AND p.DiscontinuedDate is NULL
       AND NOT EXISTS
       (SELECT 1
        FROM   Production.BillOfMaterials BOM
        WHERE  BOM.ProductAssemblyID = p.ProductID
               OR BOM.ComponentID = p.ProductID

SELECT P.ProductID,
       P.Name,
       P.ProductNumber,
       P.FinishedGoodsFlag,
       P.ListPrice
FROM   Production.Product P
WHERE  P.SellEndDate is NULL
       AND p.DiscontinuedDate is NULL
       AND NOT EXISTS (SELECT 1
                       FROM  Production.BillOfMaterials BOM
                       WHERE P.ProductID = BOM.ProductAssemblyID)

SELECT P.ProductID,
       P.Name,
       P.ProductNumber,
       P.FinishedGoodsFlag,
       P.ListPrice
FROM   Production.Product P
WHERE  P.SellEndDate is NULL
       AND p.DiscontinuedDate is NULL
       AND NOT EXISTS (SELECT 1
                       FROM  Production.BillOfMaterials BOM
                       WHERE P.ProductID = BOM.ComponentID)

SELECT P.ProductID,
       P.Name,
       P.ProductNumber,
       P.FinishedGoodsFlag,
       P.ListPrice
FROM   Production.Product P
WHERE  P.SellEndDate is NULL
       AND p.DiscontinuedDate is NULL
       AND EXISTS (SELECT 1
                   FROM  Production.BillOfMaterials BOM
                   WHERE P.ProductID = BOM.ComponentID

-- This example uses a pivot inside a CTE, so we can process the CTE further

WITH
  MyCTE

  AS

  (

    SELECT *

    FROM #tmp AS Result

      PIVOT

      (

         SUM(Reqd)

            FOR Mnth IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])

      ) AS PVT

  )


SELECT *
FROM MyCTE;

DROP TABLE #tmp
GO

CREATE TABLE ProductMaterials
(
  ProductCode nvarchar(50),
  MaterialCode nvarchar(50),
  Quantity int
)

INSERT INTO ProductMaterials SELECT N'P01', N'M01', 5
INSERT INTO ProductMaterials SELECT N'P01', N'M02', 10
INSERT INTO ProductMaterials SELECT N'P02', N'M03', 1
INSERT INTO ProductMaterials SELECT N'P03', N'M01', 10
INSERT INTO ProductMaterials SELECT N'P03', N'M02', 1
INSERT INTO ProductMaterials SELECT N'P03', N'M04', 2
INSERT INTO ProductMaterials SELECT N'P04', N'M05', 4

SET NAMES 'utf8';

INSERT INTO mysql.bom(PartNum, PartName, Weight) VALUES
(1, 'Assembly 1', 0),
(2, 'Assembly 2', 0),
(3, 'Assembly 3', 0),
(4, 'Assembly 4', 0),
(5, 'Assembly 5', 0),
(6, 'Part 1', 10),
(7, 'Part 2', 5);

DECLARE @bom int = 301755

SELECT *
FROM
(
  SELECT
    ProductCode,
    RN = ROW_NUMBER() OVER (PARTITION BY ProductCode ORDER BY Quantity DESC),
    MaterialCode
  FROM ProductMaterials
) AS BOM
PIVOT
(
  MIN(MaterialCode)
  FOR
  RN IN ([1],[2],[3])
) AS Pivots
CREATE TABLE #t(
    BOM int,
    KitID varchar(20),
    SubAssy varchar(20),
    BOMLevel int,
    StdQty float
)

INSERT #t(BOM, KitID, SubAssy, BOMLevel, StdQty) VALUES 
        (301755, '301755',   '31161201', 0, 1),
        (301755, '301755',   '29975413', 0, 2),
        (301755, '301755',   '299756', 0, 2),
        (301755, '301755',   '305958', 0, 1),
        (301755, '305958',   '311620', 1, 4),
        (301755, '305958',   '311620', 1, .1),
        (301755, '299756',   'RDBSSL012', 1, .1),
        (301755, '299756',   'RDBSSL012', 1, 3.417),
        (301755, '29975413', 'PLTSSL902', 1, 1),
        (301755, '29975413', 'CAPSSL4SCH40', 1, 1),
        (301755, '29975413', 'PIPSSL4SCH40', 1, 3.96),
        (301755, '29975413', 'LABSTR', 1, .166),
        (301755, '31161201', 'PIPSSL2SCH40', 1, 4)

;WITH cte AS (
    SELECT KitID, SubAssy, StdQty FROM #t WHERE KitID = @bom
UNION ALL
    SELECT #t.KitID, #t.SubAssy, cte.StdQty * #t.StdQty FROM #t 
    INNER JOIN cte ON cte.SubAssy = #t.KitID
)


SELECT * FROM cte ORDER BY KitID, SubAssy

CREATE TABLE #TableBom
(
 Bom INT
,KitId INT
,SubAssy VARCHAR(20)
,BomLevel INT
,StdQty DECIMAL(10 ,3)
);

INSERT INTO #TableBom
SELECT 301755, 301755, '29975413', 0, 2
UNION ALL
SELECT 301755, 29975413, 'PLTSSL902', 1, 1
UNION ALL
SELECT 301755, 29975413, 'CAPSSL902', 1, 1
UNION ALL
SELECT 301755, 29975413, 'PIPSSL4SCH40',1,3.96
UNION ALL
SELECT 301755, 29975413, 'LABSTR', 1, 0.166
UNION ALL
SELECT 301755, 299756, 'RDBSSL012', 1, 3.147

SELECT  b.Bom
   ,b2.SubAssy
   ,CONCAT(b2.SubAssy, ' = ' ,CAST(b2.StdQty AS DECIMAL(10,3)) ,' pc x ' ,CAST(b.StdQty AS DECIMAL(10,3)) ,' = ' ,CAST((b2.StdQty * b.StdQty) AS DECIMAL(10,2)) ,' pc') AS Calc
FROM    #TableBom AS b
    INNER JOIN #TableBom AS b2 ON b.SubAssy = CAST(b2.KitId AS VARCHAR(20));

WITH PartsExplosion (PartNum, MtlPartNum, lv, QtyPer, rowid, Name, SORT)
AS (
-- Anchor
  SELECT Erp.Part.PartNum, 
         Erp.Part.PartNum, 
         0,
         cast(Erp.Part.PurchasingFactor as int) as QtyPer,
         Erp.Part.SysRowID,
         CAST(Erp.Part.PartDescription as nvarchar(100)) as Name, 
         CAST('\' + Erp.Part.PartDescription as nvarchar(254)) as Sort
FROM Erp.Part
-- Recursive Call
UNION ALL
SELECT BOM.PartNum, BOM.MtlPartNum, lv + 1, cast(BOM.QtyPer as int) as QtyPer, BOM.SysRowID,
       CAST(REPLICATE ('|    ' , lv +1 ) + BOM.PartDescription as nvarchar(100)),
       CAST(cte.Sort + '\' +  BOM.PartDescription as nvarchar(254)) 
FROM PartsExplosion CTE
JOIN (SELECT Erp.PartMtl.PartNum , Erp.PartMtl.MtlPartNum, cast(Erp.PartMtl.QtyPer as int) as QtyPer, Erp.PartMtl.SysRowID, b.PartDescription
FROM Erp.PartMtl Join Erp.Part AS b on Erp.PartMtl.MtlPartNum = b.PartNum
inner join dbo.PartRev on Erp.PartMtl.RevisionNum = dbo.PartRev.RevisionNum and Erp.PartMtl.PartNum = dbo.PartRev.PartNum and Erp.PartMtl.Company = dbo.PartRev.Company 
WHERE dbo.PartRev.Approved = 1
) AS BOM
ON CTE.MtlPartNum = BOM.PartNum
)
select Name,pe.QtyPer, pe.rowid, PartNum,PE.MtlPartNum,  lv,sort
FROM PartsExplosion AS PE
ORDER BY sort

SELECT Erp.Part.PartNum,
Erp.Part.PartNum,
0,
cast(Erp.Part.PurchasingFactor as int) as QtyPer,
Erp.Part.SysRowID,
CAST(Erp.Part.PartDescription as nvarchar(100)) as Name,
CAST(’’ + Erp.Part.PartDescription as nvarchar(254)) as Sort
FROM Erp.Part
Where partnum in (‘part1’, ‘part2’)

with [BOMReviewParent] as 
(select 
	(Part.ShortChar10) as [Calculated_Customer],
	(PartRev.PartNum) as [Calculated_TopPart],
	(PartRev.RevisionNum) as [Calculated_TopPartRev],
	(part.PartNum) as [Calculated_ParentPartNum],
	(PartRev.RevisionNum) as [Calculated_ParentRevNum],
	(part.PartNum) as [Calculated_ChildPartNum],
	(PartRev.RevisionNum) as [Calculated_ChildRevNum],
    (CAST(Part.TypeCode as nvarchar(500))) as [Calculated_TypeCode],
	(0) as [Calculated_lv],
	(Cast(part.PurchasingFactor as  decimal(10,2))) as [Calculated_QtyPer],
	(Cast(part.PartDescription as nvarchar(500))) as [Calculated_PartName],
	(0) as [Calculated_OpSeq],
	(CAST(part.PartNum + '-' + partrev.RevisionNum as nvarchar(500))) as [Calculated_Sort]
from dbo.Part as Part
inner join Erp.PartRev as PartRev on 
	Part.Company = PartRev.Company
	and Part.PartNum = PartRev.PartNum
 --and ( PartRev.PartNum = '003-718')
  and Part.InActive = 0 
  and Part.ClassID in ( 'FGD',  'FGA')
  and PartRev.Approved = 1
  --and PartRev.PartNum <> '001-855'
union all
select 
	[BOMReviewParent].[Calculated_Customer] as [Calculated_Customer],
	[BOMReviewParent].[Calculated_TopPart] as [Calculated_TopPart],
	[BOMReviewParent].[Calculated_TopPartRev] as [Calculated_TopPartRev],
	[BOMChildren].[PartMtl_PartNum] as [PartMtl_PartNum],
	[BOMChildren].[PartMtl_RevisionNum] as [PartMtl_RevisionNum],
	[BOMChildren].[PartMtl_MtlPartNum] as [PartMtl_MtlPartNum],
	[BOMChildren].[Calculated_RevNum] as [Calculated_RevNum],
   (CAST(BOMChildren.TypeCode as nvarchar(500))) as PlaceHolder,
	(BOMReviewParent.Calculated_lv + 1) as [Calculated_BOMlv],
	(cast(BOMChildren.Calculated_ChildQtyPer as  decimal(10,2))) as [Calculated_BOMQtyPer],
	(CAST(REPLICATE ('|     ' , BOMReviewParent.Calculated_lv +1) + BOMChildren.PartBOMChild_PartDescription as nvarchar(500))) as [Calculated_BOMPartName],
	(BOMChildren.Calculated_MtlSeq) as [Calculated_BOMMtlSeq],
	(CAST(BOMReviewParent.Calculated_Sort + '-' + RIGHT( '0000'+ Convert(varchar, BOMChildren.Calculated_SeqNum), 4)as nvarchar(500))) as [Calculated_BOMSort]
from  (select PartBOMChild.TypeCode as TypeCode,
	[PartMtl].[PartNum] as [PartMtl_PartNum],
	[PartMtl].[RevisionNum] as [PartMtl_RevisionNum],
	[PartMtl].[MtlPartNum] as [PartMtl_MtlPartNum],
	(((select 
	[PartRevA].[RevisionNum] as [PartRevA_RevisionNum]
from Erp.PartRev as PartRevA
inner join  (select PartRevB.Company,
	[PartRevB].[PartNum] as [PartRevB_PartNum],
	[PartRevB].[RevisionNum] as [PartRevB_RevisionNum],
	(ROW_NUMBER() OVER (PARTITION BY partrevb.PartNum ORDER BY  partrevb.ApprovedDate DESC)) as [Calculated_PartRevB_RowNum]
from Erp.PartRev as PartRevB
where (PartRevB.Approved = 1  and PartRevB.EffectiveDate <= getdate() and PartRevB.PartNum = [PartMtl].[MtlPartNum] ))  as PartRevB1 on 
	PartRevA.PartNum = PartRevB1.PartRevB_PartNum
	and PartRevA.RevisionNum = PartRevB1.PartRevB_RevisionNum
         and PartRevA.Company = PartRevB1.Company
where PartRevB1.Calculated_PartRevB_RowNum = 1))) as [Calculated_RevNum],
	(cast(PartMtl.QtyPer as  decimal(10,2))) as [Calculated_ChildQtyPer],
	[PartBOMChild].[PartDescription] as [PartBOMChild_PartDescription],
	(cast(PartMtl.MtlSeq as nvarchar(254))) as [Calculated_SeqNum],
	(CAST(PartMtl.MtlSeq as Int)) as [Calculated_MtlSeq]
from Erp.PartMtl as PartMtl
inner join dbo.Part as PartBOMChild on 
	PartMtl.Company = PartBOMChild.Company
	and PartMtl.MtlPartNum = PartBOMChild.PartNum
	
  )  as BOMChildren
inner join  BOMReviewParent  as BOMReviewParent on 
	BOMChildren.PartMtl_PartNum = BOMReviewParent.Calculated_ChildPartNum
	and BOMChildren.PartMtl_RevisionNum = BOMReviewParent.Calculated_ChildRevNum
   )
 
 select BOMReviewParentTOP.[Calculated_Customer],
	BOMReviewParentTOP.[Calculated_TopPart],
	BOMReviewParentTOP.[Calculated_TopPartRev],
	BOMReviewParentTOP.[Calculated_ParentPartNum],
	BOMReviewParentTOP.[Calculated_ParentRevNum],
	BOMReviewParentTOP.[Calculated_ChildPartNum],
	BOMReviewParentTOP.[Calculated_ChildRevNum],
	BOMReviewParentTOP.[Calculated_lv],
	BOMReviewParentTOP.[Calculated_QtyPer],
	BOMReviewParentTOP.[Calculated_PartName],
	BOMReviewParentTOP.[Calculated_OpSeq],
	BOMReviewParentTOP.[Calculated_Sort]
 from  BOMReviewParent  as BOMReviewParentTOP
 
 ;WITH BOM

AS

(

SELECT

BillNo

, ComponentItemCode

, QuantityPerBill

, UnitOfMeasure

FROM dbo.BillOfMat FG WHERE billno LIKE '[0-9]%' --starts with numeric

UNION ALL

SELECT

BOM.BillNo

, BOM.ComponentItemCode

, BOM.QuantityPerBill

, BOM.UnitOfMeasure

FROM

dbo.BillOfMat FG INNER JOIN BOM ON BOM.BillNo = FG.ComponentItemCode

)

SELECT * FROM BOM

;WITH mlBOM
AS
(
    SELECT 
          BillNo as ItemCode
        , BillNo, ComponentItemCode
        , QuantityPerBill
        , CAST(QuantityPerBill AS [decimal](17,6)) as ExtendedQuantityPer --was having "anchor recursion type doesn't match" sort of errors. this corrected it
   FROM BillOfMat
   WHERE BillNo LIKE '[2-9]%' 

   UNION ALL -- CTE recursion

    SELECT 
          c.ItemCode
        , n.BillNo
        , n.ComponentItemCode
        , n.QuantityPerBill
        , CAST(n.QuantityPerBill*c.ExtendedQuantityPer as [decimal](17,6)) --was having "anchor recursion type doesn't match" sort of errors. this corrected it
   FROM BillOfMat n
   inner join mlBOM c on c.ComponentItemCode = n.BillNo
)
-- final SELECT aggregating ExtendedQuantityPer values
-- displays unique BillNo - ComponentItemCode combinations

SELECT mlbom.ItemCode
     , Partnumber_key = master.dbo.fn_PartNumberKey(mlbom.ItemCode)
     , ComponentItemCode
     , CASE WHEN(sum(ExtendedQuantityPer))> .0004 THEN (sum(ExtendedQuantityPer)) else 0 END  as QuantityPerBill
     , unitofmeasure = CI_item.PurchaseUnitOfMeasure
FROM mlBOM
    LEFT OUTER JOIN CI_Item ON mlBOM.ComponentItemCode = CI_Item.ItemCode
WHERE 
    ProductLine<> 'PACK'
group by mlbom.ItemCode, ComponentItemCode, PurchaseUnitOfMeasure
ORDER BY itemcode, ComponentItemCode
;
UNION ALL
SELECT
BOM.BillNo
, BOM.ComponentItemCode
, BOM.QuantityPerBill
, BOM.UnitOfMeasure
FROM
dbo.BillOfMat FG INNER JOIN BOM ON BOM.BillNo = FG.ComponentItemCode

WITH BOM AS
(
    SELECT
        BillNo
        , ComponentItemCode
        , QuantityPerBill
        , UnitOfMeasure
    FROM sqlmas.dbo.BillOfMat BOM WHERE billno LIKE 'Y%' --start at the "grand parent" (tank)
    UNION ALL
    SELECT
        FG.BillNo
        , BOM.ComponentItemCode
        , BOM.QuantityPerBill
        , BOM.UnitOfMeasure
    FROM
    dbo.BillOfMat FG INNER JOIN BOM ON FG.BillNo = BOM.ComponentItemCode
)
SELECT * FROM BOM

WITH BOM AS
(
    SELECT
        BillNo
        , ComponentItemCode
        , QuantityPerBill
        , UnitOfMeasure
    FROM sqlmas.dbo.BillOfMat BOM WHERE billno LIKE 'Y%' --start at the "grand parent" (tank)
    UNION ALL
    SELECT
        FG.BillNo
        , BOM.ComponentItemCode
        , BOM.QuantityPerBill
        , BOM.UnitOfMeasure
    FROM
    dbo.BillOfMat FG INNER JOIN BOM ON FG.BillNo = BOM.ComponentItemCode
)
SELECT * FROM BOM

SELECT   MGR.EMP_FIRST_NAME_0415 AS MGR_1ST_NAME,                      
         MGR.EMP_LAST_NAME_0415 AS MGR_SURNAME,                        
         S.STRUCTURE_CODE_0460 AS SC,                                  
         EMP.EMP_FIRST_NAME_0415 AS EMP_1ST_NAME,                      
         EMP.EMP_LAST_NAME_0415 AS EMP_SURNAME    
  FROM   EMPLOYEE  MGR, STRUCTURE  S, EMPLOYEE  EMP               
WHERE    MGR.EMP_FIRST_NAME_0415 = 'HERBERT'                            
         AND MANAGES.MGR.S                                                  
         AND "REPORTS-TO".S.EMP; 
       
       (Table as table, Parent as text, Child as text, Qty as text) =>
let

/* Debug parameters
Table = tblBOM,
Parent = "ProductAssemblyID",
Child = "ComponentID",
Qty = "PerAssemblyQty",
*/

	ChgTypeKeyCols = Table.Buffer(Table.TransformColumnTypes(Table,{{Parent, type text}, {Child, type text}})),
	ReplaceNulls = Table.ReplaceValue(ChgTypeKeyCols ,null,"",Replacer.ReplaceValue,{Parent}),
	MissingParents = List.Buffer(List.Select(List.Difference(List.Distinct(Table.Column(ReplaceNulls , Parent)), List.Distinct(Table.Column(ReplaceNulls , Child))), each _ <> "")),
	CleanTable = Table.Buffer(Table.Combine({ReplaceNulls , #table({Child, Parent}, List.Transform(MissingParents, each {_, ""}))})),
// Start the iteration with the top-parents onlyWITH RecursiveBOM(source_id,related_id,indent_level) AS

(

    SELECT SOURCE_ID,RELATED_ID, 0

    FROM innovator.PART_BOM pbom

    WHERE SOURCE_ID = '@'

    UNION ALL

    SELECT pbom.SOURCE_ID,pbom.RELATED_ID, indent_level +1 

    FROM innovator.PART_BOM  pbom

    INNER JOIN RecursiveBOM rbom ON rbom.related_id = pbom.SOURCE_ID

)

 

SELECT 

indent_level,

sp.ITEM_NUMBER,

sp.NAME,

rp.ITEM_NUMBER,

rp.NAME,

[innovator].[PART_BOM].[REFERENCE_DESIGNATOR],

[innovator].[PART_BOM].[QUANTITY],

[innovator].[MANUFACTURER_PART].[ITEM_NUMBER],

[innovator].[MANUFACTURER].[NAME],

[innovator].[MANUFACTURER_PART].[STATE],

[innovator].[DOCUMENT].[ITEM_NUMBER],

[innovator].[DOCUMENT].[NAME],

[innovator].[DOCUMENT].[MAJOR_REV]

 

FROM RecursiveBOM rb

 

INNER JOIN innovator.PART sp 

ON rb.source_id = sp.ID

 

    INNER JOIN innovator.PART rp 

ON rb.related_id = rp.ID

 

LEFT JOIN innovator.PART_BOM

on innovator.PART_BOM.SOURCE_ID = sp.ID

LEFT JOIN innovator.PART_AML

on innovator.PART_AML.SOURCE_ID = rp.ID

 

LEFT JOIN innovator.PART_DOCUMENT

on innovator.PART_DOCUMENT.SOURCE_ID = sp.ID

 

LEFT JOIN innovator.DOCUMENT

on innovator.DOCUMENT.ID = innovator.PART_DOCUMENT.RELATED_ID

 

LEFT JOIN innovator.MANUFACTURER_PART

on innovator.MANUFACTURER_PART.ID = innovator.PART_AML.RELATED_ID

 

LEFT JOIN innovator.MANUFACTURER

on innovator.MANUFACTURER.ID = innovator.MANUFACTURER_PART.MANUFACTURER
	SelectTopParents = Table.SelectRows(CleanTable , each Record.Field(_, Parent)=""),
	Custom1 = SelectTopParents,
// Add Path-column where the necessary 2 fields: Child and Qty are collected
	AddPath = Table.AddColumn(Custom1, "Path", each #table({"Path_", "Qty_"}, {{Record.Field(_, Child), Record.Field(_, Qty)}})),
// Combine Parent and Child of the BOM-table as long as there are still new children in the next iteration step & write the elements into the Path-table
	ResolveBOM = List.Generate(()=>
		[Result=AddPath, Level=0],
		each Table.RowCount([Result]) > 0,
		each [ Result = let
			A = Table.NestedJoin(ChgTypeKeyCols,{Parent},[Result],{Child},"NewColumn",JoinKind.Inner),
			B = Table.ExpandTableColumn(A, "NewColumn", {"Path"}, {"PathOld"}),
			C = Table.AddColumn(B,"Path", each Table.Combine({[PathOld], #table({"Path_", "Qty_"}, {{Record.Field(_, Child), Record.Field(_, Qty)}})}))
			in C,
			Level = [Level]+1 ]),
	ConvertToTable = Table.FromList(ResolveBOM, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
	ExpandBOM1 = Table.ExpandRecordColumn(ConvertToTable, Table.ColumnNames(ConvertToTable){0}, {"Level", "Result"}, {"Level", "Result"}),
	ExpandBOM2 = Table.ExpandTableColumn(ExpandBOM1, "Result", Table.ColumnNames(ExpandBOM1[Result]{1})),
// Add a couple of fields/columns needed for the reports
	AddFields = Table.AddColumn(ExpandBOM2, "NewFields", each [
	TotalQty = List.Product([Path][Qty_]),
	SpacedPath = Text.Repeat(" | ", [Level])&Record.Field(_, Child),
	PathItems = [Path][Path_],
	PathExplode = Text.Combine(PathItems, "/"),
// PathWhereUsed = Text.Combine(List.Reverse(PathItems), "/"),
	TopParentProduct = PathItems{0} ]),
	ExpandNewFields = Table.ExpandRecordColumn(AddFields, "NewFields", Record.FieldNames(AddFields[NewFields]{0})),
// Create column indicating if item is purchase item
	PurchaseItems = Table.Buffer(Table.FromColumns({List.Difference(List.Distinct(Table.Column(ChgTypeKeyCols, Child)), List.Distinct(Table.Column(ChgTypeKeyCols, Parent)))})),
	MergePurchaseItem = Table.NestedJoin(ExpandNewFields,{Child},PurchaseItems,{Table.ColumnNames(PurchaseItems){0}},"NewColumn",JoinKind.LeftOuter),
	ExpandPurchaseItem = Table.ExpandTableColumn(MergePurchaseItem, "NewColumn", {Table.ColumnNames(PurchaseItems){0}}, {"PurchaseItem"}),
	Cleanup1 = Table.RemoveColumns(ExpandPurchaseItem,{"PathOld", "Path", "PathItems"}),
	Cleanup2 = Table.TransformColumnTypes(Cleanup1,{{Qty, type number}, {"TotalQty", type number}})
	in
	Cleanup2  

SELECT
p.product_id,
if(p.is_custom and cm.customer_material_id is not null, cm.material_information, m.material_information) as material_information

from my_products as p
left join materials as m on p.material_id = m.material_id
left join custom_materials as cm on p.custom_material_id = cm.custom_material_id

WITH RPL (PART, SUBPART, QUANTITY) AS
     (  SELECT ROOT.PART, ROOT.SUBPART, ROOT.QUANTITY
        FROM PARTLIST ROOT
        WHERE ROOT.PART = '01'
      UNION ALL
        SELECT CHILD.PART, CHILD.SUBPART, CHILD.QUANTITY
        FROM RPL PARENT, PARTLIST CHILD
        WHERE  PARENT.SUBPART = CHILD.PART
     )
SELECT DISTINCT PART, SUBPART, QUANTITY
 FROM RPL
  ORDER BY PART, SUBPART, QUANTITY;
  
  WITH RPL (PART, SUBPART, QUANTITY) AS
   (
      SELECT ROOT.PART, ROOT.SUBPART, ROOT.QUANTITY
       FROM PARTLIST ROOT
       WHERE ROOT.PART = '01'
    UNION ALL
      SELECT PARENT.PART, CHILD.SUBPART, PARENT.QUANTITY*CHILD.QUANTITY
       FROM RPL PARENT, PARTLIST CHILD
       WHERE PARENT.SUBPART = CHILD.PART
   )
SELECT PART, SUBPART, SUM(QUANTITY) AS "Total QTY Used"
 FROM RPL
  GROUP BY PART, SUBPART
  ORDER BY PART, SUBPART;
  
  WITH RPL (LEVEL, PART, SUBPART, QUANTITY) AS
      (
         SELECT 1,               ROOT.PART, ROOT.SUBPART, ROOT.QUANTITY
          FROM PARTLIST ROOT
          WHERE ROOT.PART = '01'
       UNION ALL
         SELECT PARENT.LEVEL+1, CHILD.PART, CHILD.SUBPART, CHILD.QUANTITY
          FROM RPL PARENT, PARTLIST CHILD
          WHERE PARENT.SUBPART = CHILD.PART
            AND PARENT.LEVEL < 2
      )
 SELECT PART, LEVEL, SUBPART, QUANTITY
   FROM RPL;

WITH RecursiveBOM(source_id,related_id,indent_level) AS

(

    SELECT SOURCE_ID,RELATED_ID, 0

    FROM innovator.PART_BOM pbom

    WHERE SOURCE_ID = '@'

    UNION ALL

    SELECT pbom.SOURCE_ID,pbom.RELATED_ID, indent_level +1 

    FROM innovator.PART_BOM  pbom

    INNER JOIN RecursiveBOM rbom ON rbom.related_id = pbom.SOURCE_ID

)

 

SELECT 

indent_level,

sp.ITEM_NUMBER,

sp.NAME,

rp.ITEM_NUMBER,

rp.NAME,

[innovator].[PART_BOM].[REFERENCE_DESIGNATOR],

[innovator].[PART_BOM].[QUANTITY],

[innovator].[MANUFACTURER_PART].[ITEM_NUMBER],

[innovator].[MANUFACTURER].[NAME],

[innovator].[MANUFACTURER_PART].[STATE],

[innovator].[DOCUMENT].[ITEM_NUMBER],

[innovator].[DOCUMENT].[NAME],

[innovator].[DOCUMENT].[MAJOR_REV]

 

FROM RecursiveBOM rb

 

INNER JOIN innovator.PART sp 

ON rb.source_id = sp.ID

 

    INNER JOIN innovator.PART rp 

ON rb.related_id = rp.ID

 

LEFT JOIN innovator.PART_BOM

on innovator.PART_BOM.SOURCE_ID = sp.ID

LEFT JOIN innovator.PART_AML

on innovator.PART_AML.SOURCE_ID = rp.ID

 

LEFT JOIN innovator.PART_DOCUMENT

on innovator.PART_DOCUMENT.SOURCE_ID = sp.ID

 

LEFT JOIN innovator.DOCUMENT

on innovator.DOCUMENT.ID = innovator.PART_DOCUMENT.RELATED_ID

 

LEFT JOIN innovator.MANUFACTURER_PART

on innovator.MANUFACTURER_PART.ID = innovator.PART_AML.RELATED_ID

 

LEFT JOIN innovator.MANUFACTURER

on innovator.MANUFACTURER.ID = innovator.MANUFACTURER_PART.MANUFACTURER

SELECT    M1.WTPARTNUMBER AS COMPONENT, M2.WTPARTNUMBER AS ASSEMBLY

FROM      WTPART, WTPARTMASTER M2, WTPARTUSAGELINK, WTPARTMASTER M1

WHERE     WTPART.IDA3MASTERREFERENCE = M2.IDA2A2

  AND WTPART.IDA2A2 = WTPARTUSAGELINK.IDA3A5

  AND WTPARTUSAGELINK.IDA3B5 = M1.IDA2A2

  and M2.WTPARTNUMBER = '<Part_number>'

GROUP BY  M2.WTPARTNUMBER, M1.WTPARTNUMBER

order by  M2.WTPARTNUMBER, M1.WTPARTNUMBER;

select count(*)
from BOM_BILL_OF_MATERIALS
where ASSEMBLY_ITEM_ID IN
(select distinct ASSEMBLY_ITEM_ID
from BOM_BILL_OF_MATERIALS
group by ASSEMBLY_ITEM_ID,ORGANIZATION_ID,ALTERNATE_BOM_DESIGNATOR
having count(*) > 1 );

select ORGANIZATION_ID,ASSEMBLY_ITEM_ID,ALTERNATE_BOM_DESIGNATOR,COUNT(*)
from BOM_BILL_OF_MATERIALS
group by ORGANIZATION_ID,ASSEMBLY_ITEM_ID,ALTERNATE_BOM_DESIGNATOR
having count(*) > 1 ;

WITH PartsExplosion (PartNum, MtlPartNum, lv, QtyPer, rowid, Name, SORT)
AS (
-- Anchor
  SELECT Erp.PaSELECT Erp.Part.PartNum,
Erp.Part.PartNum,
0,
cast(Erp.Part.PurchasingFactor as int) as QtyPer,
Erp.Part.SysRowID,
CAST(Erp.Part.PartDescription as nvarchar(100)) as Name,
CAST(’’ + Erp.Part.PartDescription as nvarchar(254)) as Sort
FROM Erp.Part
Where partnum in (‘part1’, ‘part2’)rp.Part.PartDescription as nvarchar(100)) as Name, 
         CAST('\' + Erp.Part.PartDescription as nvarchar(254)) as Sort
FROM Erp.Part
-- Recursive Call
UNION ALL
SELECT BOM.PartNum, BOM.MtlPartNum, lv + 1, cast(BOM.QtyPer as int) as QtyPer, BOM.SysRowID,
       CAST(REPLICATE ('|    ' , lv +1 ) + BOM.PartDescription as nvarchar(100)),
       CAST(cte.Sort + '\' +  BOM.PartDescription as nvarchar(254)) 
FROM PartsExplosion CTE
JOIN (SELECT Erp.PartMtl.PartNum , Erp.PartMtl.MtlPartNum, cast(Erp.PartMtl.QtyPer as int) as QtyPer, Erp.PartMtl.SysRowID, b.PartDescription
FROM Erp.PartMtl Join Erp.Part AS b on Erp.PartMtl.MtlPartNum = b.PartNum
inner join dbo.PartRev on Erp.PartMtl.RevisionNum = dbo.PartRev.RevisionNum and Erp.PartMtl.PartNum = dbo.PartRev.PartNum and Erp.PartMtl.Company = dbo.PartRev.Company 
WHERE dbo.PartRev.Approved = 1
) AS BOM
ON CTE.MtlPartNum = BOM.PartNum
)
select Name,pe.QtyPer, pe.rowid, PartNum,PE.MtlPartNum,  lv,sort
FROM PartsExplosion AS PE
ORDER BY sort

SELECT Erp.Part.PartNum,
Erp.Part.PartNum,
0,
cast(Erp.Part.PurchasingFactor as int) as QtyPer,
Erp.Part.SysRowID,
CAST(Erp.Part.PartDescription as nvarchar(100)) as Name,
CAST(’’ + Erp.Part.PartDescription as nvarchar(254)) as Sort
FROM Erp.Part
Where partnum in (‘part1’, ‘part2’)

SELECT
mif.item_number,
assembly_item_id,
bbom.organization_id,
alternate_bom_designator,
count(*)
FROM bom_bill_of_materials bbom, mtl_item_flexfields mif
WHERE
bbom.assembly_item_id = mif.inventory_item_id and
bbom.organization_id = mif.organization_id
GROUP BY item_number, assembly_item_id,
bbom.organization_id, alternate_bom_designator
HAVING count(*) >1;

 SELECT DISTINCT LEVEL "LEV", component_quantity, msib.inventory_item_id,
                   msib2.inventory_item_id use_item, msib2.primary_uom_code,
                      msib2.segment1
                   || '.'
                   || msib2.segment2
                   || '.'
                   || msib2.segment3
                   || '.'
                   || msib2.segment4
                   || '.'
                   || msib2.segment5 AS "COMP_ITEM"
              /*bic.component_item_id,*/
              /*msib.inventory_item_id,*/
              /*msib2.inventory_item_id*/
   FROM            bom.bom_components_b bic,
                   bom.bom_structures_b bom,
                   inv.mtl_system_items_b msib,
                   inv.mtl_system_items_b msib2
             WHERE 1 = 1
               AND bic.bill_sequence_id = bom.bill_sequence_id
               AND bic.disable_date IS NULL
               AND bom.assembly_item_id = msib.inventory_item_id
               AND bom.organization_id = msib.organization_id
               AND bic.component_item_id = msib2.inventory_item_id
               AND bom.organization_id = msib2.organization_id
               AND bom.organization_id = 85         /* organization id here */
               AND msib2.segment5 = 'F00'
               AND bic.effectivity_date < SYSDATE
               AND bom.alternate_bom_designator IS NULL
        START WITH    msib.segment1
                   || msib.segment2
                   || msib.segment3
                   || msib.segment4
                   || msib.segment5 = 'ITEM CODE'
        /* top parent item here */
   CONNECT BY NOCYCLE PRIOR bic.component_item_id = msib.inventory_item_id
          ORDER BY LEVEL;

WITH cte_name (column1, column2, …)
AS
(
cte_query_definition -- Anchor member
UNION ALL
cte_query_definition -- Recursive member; references cte_name.
)
-- Statement using the CTE
SELECT *
FROM cte_name 

WITH RPL (LEVEL, PART, SUBPART, QUANTITY) AS
      (
         SELECT 1,               ROOT.PART, ROOT.SUBPART, ROOT.QUANTITY
          FROM PARTLIST ROOT
          WHERE ROOT.PART = '01'
       UNION ALL
         SELECT PARENT.LEVEL+1, CHILD.PART, CHILD.SUBPART, CHILD.QUANTITY
          FROM RPL PARENT, PARTLIST CHILD
          WHERE PARENT.SUBPART = CHILD.PART
            AND PARENT.LEVEL < 2
      )
 SELECT PART, LEVEL, SUBPART, QUANTITY
   FROM RPL;0

WITH cte_BOM (Mainitem,ProductLevel,Subitem, Sort )
AS  (SELECT P.t_mitm,
			1,
			p.t_sitm,
			            CAST (P.t_mitm AS VARCHAR (100))
     FROM   [dbo].[ttibom010100]  AS P where p.t_mitm 
                        UNION ALL
     SELECT bom.t_mitm,
            cte_BOM.ProductLevel,with [BOMReviewParent] as 
(select 
	(Part.ShortChar10) as [Calculated_Customer],
	(PartRev.PartNum) as [Calculated_TopPart],
	(PartRev.RevisionNum) as [Calculated_TopPartRev],
	(part.PartNum) as [Calculated_ParentPartNum],
	(PartRev.RevisionNum) as [Calculated_ParentRevNum],
	(part.PartNum) as [Calculated_ChildPartNum],
	(PartRev.RevisionNum) as [Calculated_ChildRevNum],
    (CAST(Part.TypeCode as nvarchar(500))) as [Calculated_TypeCode],
	(0) as [Calculated_lv],
	(Cast(part.PurchasingFactor as  decimal(10,2))) as [Calculated_QtyPer],
	(Cast(part.PartDescription as nvarchar(500))) as [Calculated_PartName],
	(0) as [Calculated_OpSeq],
	(CAST(part.PartNum + '-' + partrev.RevisionNum as nvarchar(500))) as [Calculated_Sort]
from dbo.Part as Part
inner join Erp.PartRev as PartRev on 
	Part.Company = PartRev.Company
	and Part.PartNum = PartRev.PartNum
 --and ( PartRev.PartNum = '003-718')
  and Part.InActive = 0 
  and Part.ClassID in ( 'FGD',  'FGA')
  and PartRev.Approved = 1
  --and PartRev.PartNum <> '001-855'
union all
select 
	[BOMReviewParent].[Calculated_Customer] as [Calculated_Customer],
	[BOMReviewParent].[Calculated_TopPart] as [Calculated_TopPart],
	[BOMReviewParent].[Calculated_TopPartRev] as [Calculated_TopPartRev],
	[BOMChildren].[PartMtl_PartNum] as [PartMtl_PartNum],
	[BOMChildren].[PartMtl_RevisionNum] as [PartMtl_RevisionNum],
	[BOMChildren].[PartMtl_MtlPartNum] as [PartMtl_MtlPartNum],
	[BOMChildren].[Calculated_RevNum] as [Calculated_RevNum],
   (CAST(BOMChildren.TypeCode as nvarchar(500))) as PlaceHolder,
	(BOMReviewParent.Calculated_lv + 1) as [Calculated_BOMlv],
	(cast(BOMChildren.Calculated_ChildQtyPer as  decimal(10,2))) as [Calculated_BOMQtyPer],
	(CAST(REPLICATE ('|     ' , BOMReviewParent.Calculated_lv +1) + BOMChildren.PartBOMChild_PartDescription as nvarchar(500))) as [Calculated_BOMPartName],
	(BOMChildren.Calculated_MtlSeq) as [Calculated_BOMMtlSeq],
	(CAST(BOMReviewParent.Calculated_Sort + '-' + RIGHT( '0000'+ Convert(varchar, BOMChildren.Calculated_SeqNum), 4)as nvarchar(500))) as [Calculated_BOMSort]
from  (select PartBOMChild.TypeCode as TypeCode,
	[PartMtl].[PartNum] as [PartMtl_PartNum],
	[PartMtl].[RevisionNum] as [PartMtl_RevisionNum],
	[PartMtl].[MtlPartNum] as [PartMtl_MtlPartNum],
	(((select 
	[PartRevA].[RevisionNum] as [PartRevA_RevisionNum]
from Erp.PartRev as PartRevA
inner join  (select PartRevB.Company,
	[PartRevB].[PartNum] as [PartRevB_PartNum],
	[PartRevB].[RevisionNum] as [PartRevB_RevisionNum],
	(ROW_NUMBER() OVER (PARTITION BY partrevb.PartNum ORDER BY  partrevb.ApprovedDate DESC)) as [Calculated_PartRevB_RowNum]
from Erp.PartRev as PartRevB
where (PartRevB.Approved = 1  and PartRevB.EffectiveDate <= getdate() and PartRevB.PartNum = [PartMtl].[MtlPartNum] ))  as PartRevB1 on 
	PartRevA.PartNum = PartRevB1.PartRevB_PartNum
	and PartRevA.RevisionNum = PartRevB1.PartRevB_RevisionNum
         and PartRevA.Company = PartRevB1.Company
where PartRevB1.Calculated_PartRevB_RowNum = 1))) as [Calculated_RevNum],
	(cast(PartMtl.QtyPer as  decimal(10,2))) as [Calculated_ChildQtyPer],
	[PartBOMChild].[PartDescription] as [PartBOMChild_PartDescription],
	(cast(PartMtl.MtlSeq as nvarchar(254))) as [Calculated_SeqNum],
	(CAST(PartMtl.MtlSeq as Int)) as [Calculated_MtlSeq]
from Erp.PartMtl as PartMtl
inner join dbo.Part as PartBOMChild on 
	PartMtl.Company = PartBOMChild.Company
	and PartMtl.MtlPartNum = PartBOMChild.PartNum
	
  )  as BOMChildren
inner join  BOMReviewParent  as BOMReviewParent on 
	BOMChildren.PartMtl_PartNum = BOMReviewParent.Calculated_ChildPartNum
	and BOMChildren.PartMtl_RevisionNum = BOMReviewParent.Calculated_ChildRevNum
   )
 
 select BOMReviewParentTOP.[Calculated_Customer],
	BOMReviewParentTOP.[Calculated_TopPart],
	BOMReviewParentTOP.[Calculated_TopPartRev],
	BOMReviewParentTOP.[Calculated_ParentPartNum],
	BOMReviewParentTOP.[Calculated_ParentRevNum],
	BOMReviewParentTOP.[Calculated_ChildPartNum],
	BOMReviewParentTOP.[Calculated_ChildRevNum],
	BOMReviewParentTOP.[Calculated_lv],
	BOMReviewParentTOP.[Calculated_QtyPer],
	BOMReviewParentTOP.[Calculated_PartName],
	BOMReviewParentTOP.[Calculated_OpSeq],
	BOMReviewParentTOP.[Calculated_Sort]
 from  BOMReviewParent  as BOMReviewParentTOP
			cte_BOM.Item,
			CAST (cte_BOM.Sort+ '\' + cte_bom.Item AS VARCHAR (100))

     FROM   cte_BOM 
            INNER JOIN [dbo].[ttibom010100] AS BOM
            ON BOM.t_sitm = cte_BOM.Item
                        )
SELECT Mainitem,  
         Subitem,
         ProductLevel,
         Sort
FROM     cte_BOM  
option (maxrecursion 0)

WITH RPL (PART, SUBPART, QUANTITY) AS
   (
      SELECT ROOT.PART, ROOT.SUBPART, ROOT.QUANTITY
       FROM PARTLIST ROOT
       WHERE ROOT.PART = '01'
    UNION ALL
      SELECT PARENT.PART, CHILD.SUBPART, PARENT.QUANTITY*CHILD.QUANTITY
       FROM RPL PARENT, PARTLIST CHILD
       WHERE PARENT.SUBPART = CHILD.PART
   )
SELECT PART, SUBPART, SUM(QUANTITY) AS "Total QTY Used"
 FROM RPL
  GROUP BY PART, SUBPART
  ORDER BY PART, SUBPART;

WITH RPL (PART, SUBPART, QUANTITY) AS
     (  SELECT ROOT.PART, ROOT.SUBPART, ROOT.QUANTITY
        FROM PARTLIST ROOT
        WHERE ROOT.PART = '01'
      UNION ALL
        SELECT CHILD.PART, CHILD.SUBPART, CHILD.QUANTITY
        FROM RPL PARENT, PARTLIST CHILD
        WHERE  PARENT.SUBPART = CHILD.PART
     )
SELECT DISTINCT PART, SUBPART, QUANTITY
 FROM RPL
  ORDER BY PART, SUBPART, QUANTITY;

SELECT DISTINCT LPAD (' ', LEVEL * 2) || LEVEL ORDER_LEVEL
              , LPAD (' ', LEVEL * 1) || msib.segment1 ASSEMBLY_ITEM
              , LPAD (' ', LEVEL * 4) || msib2.segment1 AS COMPONENT_ITEM
              , msib2.description COMPONENT_ITEM_DESCRIPTION
              , bic.bill_sequence_id c, bom.bill_sequence_id b            
              , msib.description ASSEMBLY_DESCRIPTION
              , msib.inventory_item_status_code ASSEMBLY_ITEM_STATUS  
              , decode (msib2.PLANNING_MAKE_BUY_CODE, 1, 'MAKE'
                                                    , 2, 'BUY'
                       ,msib2.PLANNING_MAKE_BUY_CODE ) MAKE_BUY          
              , decode (msib2.item_type,'SUPPORT_ITEM','SUPPORT ITEM'
                                       ,'BULK_ITEM','BULK ITEM'
                                       ,'P','PURCHASED ITEM'
                                       ,'SA','SUBASSEMBLY'
                                       ,'PH','PHANTOM ITEM'
                   ,msib2.item_type ) ITEM_TYPE  
              --, v.vendor_name,v.vendor_num                                                            
              , msib2.inventory_item_status_code COMPONENT_ITEM_STATUS
              , bic.COMPONENT_QUANTITY
              , bic.ITEM_NUM
              , bic.OPERATION_SEQ_NUM    
              , bic.PLANNING_FACTOR
              , bic.COMPONENT_YIELD_FACTOR  
              , bic.effectivity_date,bic.disable_date
              ,(select distinct aps.vendor_name
                from apps.PO_Approved_SUPPLIER_list asl,
                     apps.mtl_system_items_b msi,
                     apps.ap_suppliers aps
              where msi.inventory_item_id = asl.item_id
                and asl.vendor_id = aps.vendor_id
                and msi.segment1 = msib2.segment1
                and msi.organization_id = msib2.organization_id
                --and aps.segment1 is not null
                and rownum =1
                )  VENDOR_name  
            ,(select distinct aps.segment1
                from apps.PO_Approved_SUPPLIER_list asl,
                     apps.mtl_system_items_b msi,
                     apps.ap_suppliers aps
              where msi.inventory_item_id = asl.item_id
                and asl.vendor_id = aps.vendor_id
                and msi.segment1 = msib2.segment1
                and msi.organization_id = msib2.organization_id
                --and aps.segment1 is not null
                and rownum =1
                )  VENDOR_num
              , SYS_CONNECT_BY_PATH (msib2.segment1, '/') PATH
FROM            bom.bom_components_b bic
              , bom.bom_structures_b bom
              , inv.mtl_system_items_b msib
              , inv.mtl_system_items_b msib2
              , mtl_parameters mp
--              , (select aps.vendor_name,aps.segment1 vendor_num,
--                msi.organization_id,msi.inventory_item_id
--                from apps.PO_Approved_SUPPLIER_list asl,
--                apps.mtl_system_items_b msi,
--                apps.ap_suppliers aps
--                where msi.inventory_item_id = asl.item_id
--                and asl.vendor_id = aps.vendor_id
--                ) v            
WHERE           1 = 1
AND             bic.bill_sequence_id = bom.bill_sequence_id
--AND             SYSDATE BETWEEN bic.effectivity_date AND Nvl(bic.disable_date, SYSDATE)
AND             bom.assembly_item_id = msib.inventory_item_id
AND             bom.organization_id = msib.organization_id
AND             bic.component_item_id = msib2.inventory_item_id
AND             bom.organization_id = msib2.organization_id
AND             mp.organization_id = msib.organization_id
AND             mp.organization_code = 'IND'          
AND             bom.alternate_bom_designator IS NULL
            --and msib2.segment1 = '31678'
           and msib2.item_type in( 'BULK_ITEM','SUPPORT_ITEM','P')
            --and v.inventory_item_id = msib2.inventory_item_id
            --and v.organization_id = msib2.organization_id
START WITH      msib.segment1 = '34567W'            
CONNECT BY NOCYCLE PRIOR bic.component_item_id = msib.inventory_item_id
ORDER BY  PATH ;

with [BOMReviewParent] as 
(select 
	(Part.ShortChar10) as [Calculated_Customer],
	(PartRev.PartNum) as [Calculated_TopPart],
	(PartRev.RevisionNum) as [Calculated_TopPartRev],
	(part.PartNum) as [Calculated_ParentPartNum],
	(PartRev.RevisionNum) as [Calculated_ParentRevNum],
	(part.PartNum) as [Calculated_ChildPartNum],
	(PartRev.RevisionNum) as [Calculated_ChildRevNum],
    (CAST(Part.TypeCode as nvarchar(500))) as [Calculated_TypeCode],
	(0) as [Calculated_lv],
	(Cast(part.PurchasingFactor as  decimal(10,2))) as [Calculated_QtyPer],
	(Cast(part.PartDescription as nvarchar(500))) as [Calculated_PartName],
	(0) as [Calculated_OpSeq],
	(CAST(part.PartNum + '-' + partrev.RevisionNum as nvarchar(500))) as [Calculated_Sort]
from dbo.Part as Part
inner join Erp.PartRev as PartRev on 
	Part.Company = PartRev.Company
	and Part.PartNum = PartRev.PartNum
 --and ( PartRev.PartNum = '003-718')
  and Part.InActive = 0 
  and Part.ClassID in ( 'FGD',  'FGA')
  and PartRev.Approved = 1
  --and PartRev.PartNum <> '001-855'
union all
select 
	[BOMReviewParent].[Calculated_Customer] as [Calculated_Customer],
	[BOMReviewParent].[Calculated_TopPart] as [Calculated_TopPart],
	[BOMReviewParent].[Calculated_TopPartRev] as [Calculated_TopPartRev],
	[BOMChildren].[PartMtl_PartNum] as [PartMtl_PartNum],
	[BOMChildren].[PartMtl_RevisionNum] as [PartMtl_RevisionNum],
	[BOMChildren].[PartMtl_MtlPartNum] as [PartMtl_MtlPartNum],
	[BOMChildren].[Calculated_RevNum] as [Calculated_RevNum],
   (CAST(BOMChildren.TypeCode as nvarchar(500))) as PlaceHolder,
	(BOMReviewParent.Calculated_lv + 1) as [Calculated_BOMlv],
	(cast(BOMChildren.Calculated_ChildQtyPer as  decimal(10,2))) as [Calculated_BOMQtyPer],
	(CAST(REPLICATE ('|     ' , BOMReviewParent.Calculated_lv +1) + BOMChildren.PartBOMChild_PartDescription as nvarchar(500))) as [Calculated_BOMPartName],
	(BOMChildren.Calculated_MtlSeq) as [Calculated_BOMMtlSeq],
	(CAST(BOMReviewParent.Calculated_Sort + '-' + RIGHT( '0000'+ Convert(varchar, BOMChildren.Calculated_SeqNum), 4)as nvarchar(500))) as [Calculated_BOMSort]
from  (select PartBOMChild.TypeCode as TypeCode,
	[PartMtl].[PartNum] as [PartMtl_PartNum],
	[PartMtl].[RevisionNum] as [PartMtl_RevisionNum],
	[PartMtl].[MtlPartNum] as [PartMtl_MtlPartNum],
	(((select 
	[PartRevA].[RevisionNum] as [PartRevA_RevisionNum]
from Erp.PartRev as PartRevA
inner join  (select PartRevB.Company,
	[PartRevB].[PartNum] as [PartRevB_PartNum],
	[PartRevB].[RevisionNum] as [PartRevB_RevisionNum],
	(ROW_NUMBER() OVER (PARTITION BY partrevb.PartNum ORDER BY  partrevb.ApprovedDate DESC)) as [Calculated_PartRevB_RowNum]
from Erp.PartRev as PartRevB
where (PartRevB.Approved = 1  and PartRevB.EffectiveDate <= getdate() and PartRevB.PartNum = [PartMtl].[MtlPartNum] ))  as PartRevB1 on 
	PartRevA.PartNum = PartRevB1.PartRevB_PartNum
	and PartRevA.RevisionNum = PartRevB1.PartRevB_RevisionNum
         and PartRevA.Company = PartRevB1.Company
where PartRevB1.Calculated_PartRevB_RowNum = 1))) as [Calculated_RevNum],
	(cast(PartMtl.QtyPer as  decimal(10,2))) as [Calculated_ChildQtyPer],
	[PartBOMChild].[PartDescription] as [PartBOMChild_PartDescription],
	(cast(PartMtl.MtlSeq as nvarchar(254))) as [Calculated_SeqNum],
	(CAST(PartMtl.MtlSeq as Int)) as [Calculated_MtlSeq]
from Erp.PartMtl as PartMtl
inner join dbo.Part as PartBOMChild on 
	PartMtl.Company = PartBOMChild.Company
	and PartMtl.MtlPartNum = PartBOMChild.PartNum
	
  )  as BOMChildren
inner join  BOMReviewParent  as BOMReviewParent on 
	BOMChildren.PartMtl_PartNum = BOMReviewParent.Calculated_ChildPartNum
	and BOMChildren.PartMtl_RevisionNum = BOMReviewParent.Calculated_ChildRevNum
   )
 
 select BOMReviewParentTOP.[Calculated_Customer],
	BOMReviewParentTOP.[Calculated_TopPart],
	BOMReviewParentTOP.[Calculated_TopPartRev],
	BOMReviewParentTOP.[Calculated_ParentPartNum],
	BOMReviewParentTOP.[Calculated_ParentRevNum],
	BOMReviewParentTOP.[Calculated_ChildPartNum],
	BOMReviewParentTOP.[Calculated_ChildRevNum],
	BOMReviewParentTOP.[Calculated_lv],
	BOMReviewParentTOP.[Calculated_QtyPer],
	BOMReviewParentTOP.[Calculated_PartName],
	BOMReviewParentTOP.[Calculated_OpSeq],
	BOMReviewParentTOP.[Calculated_Sort]
 from  BOMReviewParent  as BOMReviewParentTOP



------------------------------------------------------------------------
--This example inserts two top level assemblies into a temporary table along
--with the number of each model required for 12 months in advance, and by
--and by doing so it calculates the budgeted quantity of each bought out
--component required by an assembly type factory or process pivoted for a
--12 month look ahead period.
------------------------------------------------------------------------
--The technique used here is much more efficient that using a recursive
--common table expression (CTE), but it cannot list a bill of materials
--in hierarchical order. It could be possible to list in this order with a few
--modifications.
--It calculates the requirements for components on a level-by-level basis. The
--initial level is set to zero, and the top level items are inserted at this level --into a temporary table. Each successive level is grabbed from a BOM structure
-- table where each line represents a parent/child pair. Each successive level
--looks at the previously appended level and multiplies the requirement for the

--parent (from the previous level) with the new items found in the structure
--table until no more items are returned from the structure table.
------------------------------------------------------------------------


DECLARE
@level int;

 

--create working table

SELECT ParentPart as StockCode, CAST(0 as int) As Lev, CAST(10 as float) as Reqd, CAST(1 as int) as Mnth

INTO #tmp

FROM BomStructure

WHERE 1=0;

 

--insert all the models and requirements

SET @level = 0;

 

INSERT INTO #tmp VALUES('DAD261',@level,1860,1);

INSERT INTO #tmp VALUES('DAD261',@level,1860,2);

INSERT INTO #tmp VALUES('DAD261',@level,4000,3);

INSERT INTO #tmp VALUES('DAD261',@level,2142,4);

INSERT INTO #tmp VALUES('DAD261',@level,2289,5);

INSERT INTO #tmp VALUES('DAD261',@level,2289,6);

INSERT INTO #tmp VALUES('DAD261',@level,4000,7);

INSERT INTO #tmp VALUES('DAD261',@level,3000,8);

INSERT INTO #tmp VALUES('DAD261',@level,3969,9);

INSERT INTO #tmp VALUES('DAD261',@level,3780,10);

INSERT INTO #tmp VALUES('DAD261',@level,3806,11);

INSERT INTO #tmp VALUES('DAD261',@level,826,12);

INSERT INTO #tmp VALUES('DAD262',@level,820,1);

INSERT INTO #tmp VALUES('DAD262',@level,820,2);

INSERT INTO #tmp VALUES('DAD262',@level,820,3);

INSERT INTO #tmp VALUES('DAD262',@level,2000,4);

INSERT INTO #tmp VALUES('DAD262',@level,2289,5);

INSERT INTO #tmp VALUES('DAD262',@level,2289,6);

INSERT INTO #tmp VALUES('DAD262',@level,820,7);

INSERT INTO #tmp VALUES('DAD262',@level,1578,8);

INSERT INTO #tmp VALUES('DAD262',@level,600,9);

INSERT INTO #tmp VALUES('DAD262',@level,800,10);

INSERT INTO #tmp VALUES('DAD262',@level,1000,11);

INSERT INTO #tmp VALUES('DAD262',@level,700,12);

 

--loop through each matching level in the BOM table
WHILE (@@RowCount > 0) AND (@level < 15)
BEGIN

      SET @level = @level + 1;

      INSERT INTO #tmp

      SELECT B.Component, @level , A.Reqd * B.QtyPer, A.Mnth

      FROM BomStructure B JOIN #tmp A

      ON A.StockCode = B.ParentPart

      JOIN InvMaster I

      ON I.StockCode = B.ParentPart

      WHERE A.Lev = @level - 1

      AND ((B.StructureOffDate IS NULL) OR (B.StructureOffDate >=GetDate()))

      AND ((B.StructureOnDate IS NULL) OR (B.StructureOnDate <= GetDate()))

      AND B.Route='0'

      AND I.PartCategory <> 'B'

     

END;

 

-- This example uses a pivot inside a CTE, so we can process the CTE further

WITH MyCTE

AS

(

      SELECT *

      FROM #tmp AS Result

      PIVOT

      (

         SUM(Reqd)

            FOR Mnth IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])

      ) AS PVT

)

 
SELECT * FROM MyCTE;

DROP TABLE #tmp
GO

-Sql Server 2014 Express Edition
--Batches are separated by 'go'

CREATE TABLE BOM(ParentPart varchar(100), Component varchar(100), QtyPer int, UnitCost money);

INSERT INTO BOM
VALUES
('LAMP','BASE',1,100.),
('LAMP','WIRE',1,10),
('LAMP','HOLDER',1,10),
('BASE','GLASS',2,20),
('BASE','METAL',1,60),
(NULL,'LAMP',1,150);


WITH   cte
AS     (SELECT
        ParentPart,
        Component,
        QtyPer,
        UnitCost
        FROM BOM
        WHERE ParentPart IS NULL
        UNION ALL
        SELECT 
        t.ParentPart,
        t.Component,
        t.QtyPer,
        t.UnitCost
        FROM   BOM t
        INNER JOIN cte
        ON cte.Component = t.ParentPart
       )
SELECT *
FROM   cte

