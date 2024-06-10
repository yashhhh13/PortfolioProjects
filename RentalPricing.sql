SELECT * 
FROM RentalPricingMalaysia

-- finding mean rent for diff region 
SELECT region, AVG(monthly_rent) AS monthly_rent
FROM RentalPricingMalaysia
GROUP BY region

-- finding mean rent for diff furnished status
SELECT furnished, AVG(monthly_rent) AS monthly_rent
FROM RentalPricingMalaysia
GROUP BY furnished
ORDER BY 2 DESC

-- finding mean rent for diff property type and property count for each of it
SELECT property_type, AVG(monthly_rent) AS avg_monthly_rent, COUNT(property_type) AS property_count
FROM RentalPricingMalaysia
GROUP BY property_type 
ORDER BY avg_monthly_rent

SELECT region, property_type, AVG(monthly_rent) AS avg_monthly_rent, COUNT(property_type) AS property_count
FROM RentalPricingMalaysia
GROUP BY region, property_type 
ORDER BY 1, 3

-- finding the mean rent for diff regions, furnished status and property type
SELECT region, furnished, property_type, AVG(monthly_rent) AS avg_monthly_rent
FROM RentalPricingMalaysia
GROUP BY region, furnished, property_type
ORDER BY 1, 2, 4

-- there was a hidden leading or trailing spaces in the location values (use TRIM)
SELECT region, location
FROM RentalPricingMalaysia
WHERE region like 'Kuala Lumpur' AND TRIM(location) like 'Ampang' 

-- finding the location with most rental available
SELECT region, location, count(location) AS total_count
FROM RentalPricingMalaysia
GROUP BY region, location
ORDER BY 1, 3 DESC

-- updating the null rooms values which is more than 10 initally to 11
UPDATE RentalPricingMalaysia
SET rooms = 11
WHERE rooms IS NULL;

-- average Rent by Room Count
SELECT rooms, AVG(monthly_rent) AS AvgRent
FROM RentalPricingMalaysia
GROUP BY rooms
ORDER BY rooms;

-- renaming a column name
EXEC sp_rename 'RentalPricingMalaysia.[size sq#ft#]', 'size', 'COLUMN';

-- finding how the number of rooms, bathrooms, parking spaces, and size affect the monthly rent.
SELECT rooms, bathroom, parking, size, AVG(monthly_rent) AS avg_rent
FROM RentalPricingMalaysia
GROUP BY rooms, bathroom, parking, size
ORDER BY avg_rent DESC
