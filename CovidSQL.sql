SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

#Total Cases vs Total Deaths, Probability of death should covid be contracted
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE location LIKE '%Hungary%'
AND continent IS NOT NULL
ORDER BY 1,2;

#Total Cases vs Population, % of population contracted Covid
SELECT location, date, total_cases, population, (total_cases/population)*100 AS PopulationInfectionPercentage
FROM coviddeaths
WHERE location LIKE '%Hungary%'
AND continent IS NOT NULL
ORDER BY 1,2;

#Countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PopulationInfectionPercentage
FROM coviddeaths
WHERE location IS NOT NULL
GROUP BY location, population
ORDER BY PopulationInfectionPercentage DESC;

#Continents with highest infection rate compared to population
SELECT continent, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PopulationInfectionPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent, population
ORDER BY PopulationInfectionPercentage DESC;

#Countries with Highest Death Count per Population
SELECT location, MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE location IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

#Continents with Highest Death Count per Population
SELECT continent, MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

#Global Numbers on each date
SELECT date, SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS UNSIGNED)) AS Total_Deaths, SUM(CAST(new_deaths AS UNSIGNED))/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

#Total Population vs Vaccinations
WITH PopulationVsVaccination (continent, location, date, population, new_vaccinations, PeopleVaccinated)
AS
(
SELECT coviddeaths.continent, coviddeaths.location, coviddeaths.date, coviddeaths.population, covidvaccinations.new_vaccinations
, SUM(CAST(covidvaccinations.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY coviddeaths.location ORDER BY coviddeaths.location, coviddeaths.date) AS PeopleVaccinated
FROM coviddeaths
JOIN covidvaccinations
	ON coviddeaths.location = covidvaccinations.location
    AND coviddeaths.date = covidvaccinations.date
WHERE coviddeaths.continent IS NOT NULL
)
SELECT *, (PeopleVaccinated/Population)*100
FROM PopulationVsVaccination;

CREATE VIEW PercentPopulationVaccinated AS
SELECT coviddeaths.continent, coviddeaths.location, coviddeaths.date, coviddeaths.population, covidvaccinations.new_vaccinations
, SUM(CAST(covidvaccinations.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY coviddeaths.location ORDER BY coviddeaths.location, coviddeaths.date) AS PeopleVaccinated
FROM coviddeaths
JOIN covidvaccinations
	ON coviddeaths.location = covidvaccinations.location
    AND coviddeaths.date = covidvaccinations.date
WHERE coviddeaths.continent IS NOT NULL;



    
 


















