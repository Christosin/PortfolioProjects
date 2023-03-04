SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER by 3,4

SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER by 3,4

--Select the data that we ar going to be using

SELECT [location],[date],total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER by 1,2

--Looking at Total Cases versus Total Deaths
--Shows likelihood of dying if you contrast COVID in your Country.

SELECT [location],[date],total_cases, total_deaths, (cast(total_deaths as numeric))/(cast(total_cases as int))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE [location] like '%states%'
ORDER by 1,2

---Looking at Total Cases vs Population
--Shows percentage of population that got COVID

SELECT [location],[date],population,total_cases, (cast(total_cases as int))/(cast(population as numeric))*100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE [location] like '%states%'
ORDER by 1,2

--Looking at Countries with Highest Infection Rate compared to Population

SELECT [location],population, MAX(cast(total_cases as int)) as HighestInfectionCount, MAX((cast(total_cases as int))/(cast(population as numeric)))*100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE [location] like '%states%'
GROUP by [location],population
ORDER by PercentagePopulationInfected DESC

--Showing Countries with the Highest Death Count per population

SELECT [location], MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP by [location]
ORDER by TotalDeathCount DESC

--LET'S BREAK THINGS DOWN BY CONTINENT

----Showing the continents with the highest death counts per population

SELECT [continent], MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP by [continent]
ORDER by TotalDeathCount DESC


--GLOBAL NUMBERS

SELECT [date],SUM(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as numeric)) as total_deaths, SUM(cast(new_deaths as numeric))/SUM(cast(new_cases as int))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE [continent] is not null
GROUP by [date]
ORDER by 1,2

SELECT SUM(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as numeric)) as total_deaths, SUM(cast(new_deaths as numeric))/SUM(cast(new_cases as int))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE [continent] is not null
--GROUP by [date]
ORDER by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
ORDER by 2,3



-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER by 2,3
)
SELECT *, (RollingPeopleVaccinated/Cast(Population as numeric))*100
FROM PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated

CREATE Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER by 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

CREATE VIEW PercentagePopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER by 2,3

SELECT * 
FROM PercentagePopulationVaccinated