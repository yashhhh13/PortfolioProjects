SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2

-- looking at total cases vs total deaths
-- shows the likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM CovidDeaths
where location like 'malaysia'
ORDER BY 1, 2

-- looking at the total cases vs the population
SELECT location, date, population, total_cases, (total_cases/population) * 100 AS PercentPopulationInfected
FROM CovidDeaths
where location like 'malaysia'
ORDER BY 1, 2

-- looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--showing country with highest death count per populatio
--earlier i did like this CAST(MAX(total_deaths)AS INT), this is wrong
SELECT location, MAX(CAST(total_deaths AS INT)) AS HighestTotalDeath
FROM CovidDeaths  
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestTotalDeath DESC

--lets break things down by continent
-- showing continents with teh highest death count per population
SELECT location, MAX(CAST(total_deaths AS INT)) AS HighestTotalDeath
FROM CovidDeaths  
WHERE continent IS NULL
GROUP BY location
ORDER BY HighestTotalDeath DESC

-- global numbers
SELECT SUM(new_cases) as  TotalCases, SUM(CAST(new_deaths AS INT)) as TotalDeath, SUM(CAST(new_deaths AS INT))/SUM(new_cases) * 100 AS DeathPercentage
FROM CovidDeaths
-- where location like 'malaysia'
where continent IS NOT NULL 

--USE CTE
WITH PopvsVac (Continent, location, date, population, new_vaccinations, rollingPeopleVaccinated)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS INT)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) as rollingPeopleVaccinated
-- (rollingPeopleVaccinated/population) * 100
FROM CovidDeaths dea 
INNER JOIN CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (rollingPeopleVaccinated/population) * 100
FROM PopvsVac


--temp table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(225),
location nvarchar(255),
date datetime,
population numeric, 
new_vaccinations numeric,
rollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS INT)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) as rollingPeopleVaccinated
-- (rollingPeopleVaccinated/population) * 100
FROM CovidDeaths dea 
INNER JOIN CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (rollingPeopleVaccinated/population) * 100
FROM #PercentPopulationVaccinated

-- creating view to store data for later visualization

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS INT)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) as rollingPeopleVaccinated
-- (rollingPeopleVaccinated/population) * 100
FROM CovidDeaths dea 
INNER JOIN CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated