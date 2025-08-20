-- #1 

USE project2;

WITH StateYearlyProduction AS (
    SELECT
        `Year`,
        `State Name`,
        SUM(`RICE PRODUCTION (1000 tons)`) AS TotalRiceProduction
    FROM
        `agriagri`
    GROUP BY
        `Year`,
        `State Name`
),
RankedProduction AS (
    SELECT
        `Year`,
        `State Name`,
        TotalRiceProduction,
        DENSE_RANK() OVER (PARTITION BY `Year` ORDER BY TotalRiceProduction DESC) AS ProductionRank
    FROM
        StateYearlyProduction
)
SELECT
    `Year`,
    `State Name`,
    TotalRiceProduction
FROM
    RankedProduction
WHERE
    ProductionRank <= 3
ORDER BY
    `Year` ASC,
    TotalRiceProduction DESC;
    
    
-- #2

-- SELECT
--     StartYearData.`Dist Name`,
--     (EndYearData.EndYield - StartYearData.StartYield) AS YieldIncrease
-- FROM
--     (
--         -- This subquery gets the yield for each district at the START of the 5-year period
--         SELECT
--             `Dist Name`,
--             `WHEAT YIELD (Kg per ha)` AS StartYield
--         FROM
--             agriagri
--         WHERE
--             `Year` = (SELECT MAX(`Year`) FROM agriagri) - 4
--     ) AS StartYearData
-- JOIN
--     (
--         -- This subquery gets the yield for each district at the END of the 5-year period
--         SELECT
--             `Dist Name`,
--             `WHEAT YIELD (Kg per ha)` AS EndYield
--         FROM
--             agriagri
--         WHERE
--             `Year` = (SELECT MAX(`Year`) FROM agriagri)
--     ) AS EndYearData
-- ON
--     StartYearData.`Dist Name` = EndYearData.`Dist Name`
-- WHERE
--     (EndYearData.EndYield - StartYearData.StartYield) > 0 -- Optional: only show positive increases
-- ORDER BY
--     YieldIncrease DESC
-- LIMIT 5;


-- #3 

-- SELECT
--     StartProductionData.`State Name`,
--     (
--         (
--             EndProductionData.EndProduction - StartProductionData.StartProduction
--         ) / StartProductionData.StartProduction
--     ) * 100 AS GrowthRatePercentage
-- FROM
--     (
--         -- This gets the total production for each state at the START of the 5-year period
--         SELECT
--             `State Name`,
--             SUM(`OILSEEDS PRODUCTION (1000 tons)`) AS StartProduction
--         FROM
--             agriagri
--         WHERE
--             `Year` = (
--                 SELECT
--                     MAX(`Year`)
--                 FROM
--                     agriagri
--             ) - 4
--         GROUP BY
--             `State Name`
--     ) AS StartProductionData
-- JOIN (
--     -- This gets the total production for each state at the END of the 5-year period
--     SELECT
--         `State Name`,
--         SUM(`OILSEEDS PRODUCTION (1000 tons)`) AS EndProduction
--     FROM
--         agriagri
--     WHERE
--         `Year` = (
--             SELECT
--                 MAX(`Year`)
--             FROM
--                 agriagri
--         )
--     GROUP BY
--         `State Name`
-- ) AS EndProductionData ON StartProductionData.`State Name` = EndProductionData.`State Name`
-- WHERE
--     StartProductionData.StartProduction > 0 -- This avoids division-by-zero errors
-- ORDER BY
--     GrowthRatePercentage DESC
-- LIMIT 5;

-- #4

-- SELECT
--     `Dist Name`,
--     SUM(`RICE AREA (1000 ha)`) AS Total_Rice_Area,
--     SUM(`RICE PRODUCTION (1000 tons)`) AS Total_Rice_Production,
--     SUM(`WHEAT AREA (1000 ha)`) AS Total_Wheat_Area,
--     SUM(`WHEAT PRODUCTION (1000 tons)`) AS Total_Wheat_Production,
--     SUM(`MAIZE AREA (1000 ha)`) AS Total_Maize_Area,
--     SUM(`MAIZE PRODUCTION (1000 tons)`) AS Total_Maize_Production
-- FROM
--     `agriagri`
-- GROUP BY
--     `Dist Name`
-- ORDER BY
--     `Dist Name`;

-- #5

-- Step 1: Create a temporary list of the Top 5 cotton-producing states
-- WITH Top5States AS (
--     SELECT
--         `State Name`
--     FROM
--         agriagri
--     GROUP BY
--         `State Name`
--     ORDER BY
--         SUM(`COTTON PRODUCTION (1000 tons)`) DESC
--     LIMIT 5
-- ),
-- Step 2: Get the total yearly production for ONLY those top 5 states
-- YearlyProduction AS (
--     SELECT
--         `Year`,
--         `State Name`,
--         SUM(`COTTON PRODUCTION (1000 tons)`) AS TotalProduction
--     FROM
--         agriagri
--     WHERE
--         `State Name` IN (SELECT `State Name` FROM Top5States)
--     GROUP BY
--         `Year`,
--         `State Name`
-- ),
-- Step 3: Use the LAG() function to get the previous year's production
-- ProductionGrowth AS (
--     SELECT
--         `Year`,
--         `State Name`,
--         TotalProduction,
--         LAG(TotalProduction, 1, 0) OVER (PARTITION BY `State Name` ORDER BY `Year`) AS PreviousYearProduction
--     FROM
--         YearlyProduction
-- )
-- Step 4: Calculate the final growth value
-- SELECT
--     `Year`,
--     `State Name`,
--     TotalProduction,
--     (TotalProduction - PreviousYearProduction) AS ProductionGrowth
-- FROM
--     ProductionGrowth
-- ORDER BY
--     `State Name`,
--     `Year`;


-- #6

-- SELECT
--     `Dist Name`,
--     `State Name`,
--     SUM(`GROUNDNUT PRODUCTION (1000 tons)`) AS TotalGroundnutProduction
-- FROM
--     agriagri
-- WHERE
--     `Year` = (SELECT MAX(`Year`) FROM agriagri WHERE `Year` <= 2020)
-- GROUP BY
--     `Dist Name`,
--     `State Name`
-- ORDER BY
--     TotalGroundnutProduction DESC
-- LIMIT 10;



-- #7


-- SELECT
--     `Year`,
--     `State Name`,
--     AVG(`MAIZE YIELD (Kg per ha)`) AS Average_Maize_Yield
-- FROM
--     agriagri
-- GROUP BY
--     `Year`,
--     `State Name`
-- ORDER BY
--     `Year`,
--     `State Name`;


-- #8


-- SELECT
--     `State Name`,
--     SUM(`OILSEEDS AREA (1000 ha)`) AS Total_Oilseed_Area
-- FROM
--     agriagri
-- GROUP BY
--     `State Name`
-- ORDER BY
--     Total_Oilseed_Area DESC;


-- #9

-- SELECT
--     `Dist Name`,
--     `State Name`,
--     AVG(`RICE YIELD (Kg per ha)`) AS Average_Rice_Yield
-- FROM
--     agriagri
-- GROUP BY
--     `Dist Name`,
--     `State Name`
-- ORDER BY
--     Average_Rice_Yield DESC
-- LIMIT 10;


-- #10

-- First, find the top 5 states based on combined rice and wheat production
-- WITH Top5States AS (
--     SELECT
--         `State Name`
--     FROM
--         agriagri
--     GROUP BY
--         `State Name`
--     ORDER BY
--         SUM(`RICE PRODUCTION (1000 tons)`) + SUM(`WHEAT PRODUCTION (1000 tons)`) DESC
--     LIMIT 5
-- )
-- Now, get the yearly production data for those states for the last 10 years
-- SELECT
--     `Year`,
--     `State Name`,
--     SUM(`RICE PRODUCTION (1000 tons)`) AS Rice_Production,
--     SUM(`WHEAT PRODUCTION (1000 tons)`) AS Wheat_Production
-- FROM
--     agriagri
-- WHERE
--     `State Name` IN (SELECT `State Name` FROM Top5States) AND
--     `Year` >= (SELECT MAX(`Year`) FROM agriagri) - 9
-- GROUP BY
--     `Year`,
--     `State Name`
-- ORDER BY
--     `State Name`,
--     `Year`;