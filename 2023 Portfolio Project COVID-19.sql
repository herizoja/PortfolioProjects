-- Datasets are available at (https://ourworldindata.org/covid-deaths) -- 


SELECT *
FROM PortfolioProject.  .CovidDeaths
WHERE continent is not NULL
ORDER BY 3,4

-- SELECT *
-- FROM PortfolioProject.  .CovidDeaths
-- ORDER BY 3,4

-- Select data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.  .CovidDeaths
WHERE continent is not NULL
ORDER BY 1,2

-- Looking at TotalCases vs TotalDeaths
-- Shows likelihood of dying if you contract Covid in China 

SELECT location, date, total_cases, total_deaths, (total_deaths*1.0)/(total_cases*1.0)*100 as DeathPercentage
FROM PortfolioProject.  .CovidDeaths
WHERE location like '%china%' 
AND continent is not NULL
ORDER BY 1,2

-- Looking at Total_cases vs Population
-- Shows what percentage of population got Covid in China

SELECT location, date, total_cases, population, (total_cases*1.0)/(population*1.0)*100 as PercentPopulationInfected 
FROM PortfolioProject.  .CovidDeaths
WHERE location like '%China%'
AND continent is not NULL
ORDER BY 1,2

-- Looking at countries with Highest Infection Rate compared to Population

SELECT location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases*1.0)/(population*1.0)*100) as PercentPopulationInfected 
FROM PortfolioProject.  .CovidDeaths
GROUP BY location, population 
WHERE continent is not NULL
ORDER BY PercentPopulationInfected DESC

-- LET'S BREAK THINGS DOWN BY CONTINENT 

-- Showing Continent with Highest Death Count per Population

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject.  .CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)*1.0/ NULLIF(SUM(new_cases),0)*1.0*100 as DeathPercentage
FROM PortfolioProject.  .CovidDeaths
WHERE continent is not NULL 
GROUP BY date
ORDER BY 1,2

-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject.  .CovidDeaths dea 
JOIN PortfolioProject.  .CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date 
WHERE dea.continent is not NULL
ORDER BY 2,3

-- USE CTE

WITH PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) 
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject.  .CovidDeaths dea 
JOIN PortfolioProject.  .CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date 
WHERE dea.continent is not NULL
)
SELECT *, (RollingPeopleVaccinated*1.0/population*1.0)*100
FROM PopvsVac

-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent NVARCHAR(255), 
Location NVARCHAR(255), 
Date datetime,
Population numeric, 
New_vaccinations numeric, 
Rollingpeoplevaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject.  .CovidDeaths dea 
JOIN PortfolioProject.  .CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date 
WHERE dea.continent is not NULL

SELECT *, (RollingPeopleVaccinated*1.0/population*1.0)*100
FROM #PercentPopulationVaccinated

-- Creating View to Store Data for Later Visualizations

CREATE VIEW PercentPopulationVaccinated  AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject.  .CovidDeaths dea 
JOIN PortfolioProject.  .CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date 
WHERE dea.continent is not NULL

SELECT*
FROM PercentPopulationVaccinated

