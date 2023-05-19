   Select *
From PortfolioProject1Covid..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject1Covid..CovidVaccinations
--order by 3,4

--Select the Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject1Covid..CovidDeaths
Where continent is not null
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows the Likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (convert(float,total_deaths)/convert(float,total_cases))*100 as DeathPercentage
From PortfolioProject1Covid..CovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2


-- Looking at Total Cases bc Population
-- Shows what percentage of population got Covid

Select location, date, population, total_cases, (convert(float,total_cases)/convert(float,population))*100 as PercentPopulationInfected
From PortfolioProject1Covid..CovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2


-- Looking at Countries with Highest Infection Rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, Max((convert(float,total_cases)/convert(float,population)))*100 as 
	PercentPopulationInfected
From PortfolioProject1Covid..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Location, population
order by PercentPopulationInfected desc


-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as bigint)) as TotalDeathCount
From PortfolioProject1Covid..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc


-- BREAKING IT DOWN BY CONTINENT


Select location, MAX(cast(total_deaths as bigint)) as TotalDeathCount
From PortfolioProject1Covid..CovidDeaths
--Where location like '%states%'
Where continent is null
and location NOT LIKE '%income%' -- and iso_code NOT LIKE '%C' <-- this works too
Group by location
order by TotalDeathCount desc


-- Showing continents with the highest death count per population

Select continent, MAX(cast(total_deaths as bigint)) as TotalDeathCount
From PortfolioProject1Covid..CovidDeaths
--Where location like '%states%'
Where continent is NOT null
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS


SELECT 
       SUM(new_cases) as total_cases, 
       SUM(cast(new_deaths as bigint)) as total_deaths, 
       SUM(cast(new_deaths as bigint))/NULLIF(SUM(new_cases), 0)*100 as DeathPercentage --NULLIF was included because I was getting a division error when Alex wasn't
FROM PortfolioProject1Covid..CovidDeaths
--Where location like '%states%'
WHERE continent IS NOT null
--GROUP BY date
ORDER BY 1,2


-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) --Cast can also be used instead of using CONVERT
OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1Covid..CovidDeaths dea
Join PortfolioProject1Covid..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent IS NOT null
order by 2,3


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) 
as --If the number of columns in the CTE is different than in the SELECT statement, then it gives an error
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) --Cast can also be used instead of using CONVERT
OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1Covid..CovidDeaths dea
Join PortfolioProject1Covid..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent IS NOT null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated -- Add this if you plan on making any alterations and if you run it multiple times you won't have to delete the temp table
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) --Cast can also be used instead of using CONVERT
OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1Covid..CovidDeaths dea
Join PortfolioProject1Covid..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent IS NOT null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) --Cast can also be used instead of using CONVERT
OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1Covid..CovidDeaths dea
Join PortfolioProject1Covid..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent IS NOT null
--order by 2,3

SELECT TABLE_NAME as ViewName
FROM INFORMATION_SCHEMA.VIEWS
-- Check "System Databases -> master -> Views -> dbo.PercentPopulationVaccinated"
-- Ctrl + Shft + R to refresh and remove red lines. Now it recognizes it.


Select *
From PercentPopulationVaccinated -- This is permanent now, not like a temp table. It can be used in a visualization later.