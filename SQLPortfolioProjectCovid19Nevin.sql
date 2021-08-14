SELECT * 
FROM PortfolioProjectCOVID.dbo.[Covid Deaths]
where continent is not null
ORDER BY 3,4

--SELECT * 
--FROM PortfolioProjectCOVID.dbo.[Covid Vaccinations]
--ORDER BY 3,4

--Select Data for Project
Select location, date, total_cases,new_cases, total_deaths,population
FROM PortfolioProjectCOVID.dbo.[Covid Deaths]
where continent is not null
ORDER BY 1,2

-- Look at  Total Cases Vs Total Deaths -- 
-- Shows the likelihood in percentage of dying if you contract Covid 19 in a country - Canada
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjectCOVID.dbo.[Covid Deaths]
where location like '%Canada%'
where continent is not null
ORDER BY 1,2 


-- Looking at Total Cases Vs Population 
-- Shows what percentage of Canadian population affected by Covid19
Select location, date, population, total_cases,  (total_cases/population)*100 as PercentInfectedpopulation
FROM PortfolioProjectCOVID.dbo.[Covid Deaths]
where location like '%Canada%'
where continent is not null
ORDER BY 1,2 

-- Identifying countries with highest infection rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentInfectedpopulation
FROM PortfolioProjectCOVID.dbo.[Covid Deaths]
GROUP BY location,population
where continent is not null
ORDER BY PercentInfectedpopulation DESC

--Displaying Countries with Highest Death Count per Population
Select location, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProjectCOVID.dbo.[Covid Deaths]
where continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Breaking Down by Continent 


Select location, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProjectCOVID.dbo.[Covid Deaths]
where continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Showing Continent with highest death count
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProjectCOVID.dbo.[Covid Deaths]
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers

Select  date, SUM (new_cases) as total_cases , Sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as  DeathPercentage
FROM PortfolioProjectCOVID.dbo.[Covid Deaths] 
--where location like '%Canada%'
where continent is not null
GROUP BY date
ORDER BY 1,2 

-- Total Cases and Total Deaths and death percent
Select SUM (new_cases) as total_cases , Sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as  DeathPercentage
FROM PortfolioProjectCOVID.dbo.[Covid Deaths] 
--where location like '%Canada%'
where continent is not null
--GROUP BY date
ORDER BY 1,2 


-- Looking at total populaiton vs Vaccination  -- Vaccinations 


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location Order by dea.location ,
dea.date  ) as PeopleVaccinated
From PortfolioProjectCOVID.dbo.[Covid Deaths] dea
Join PortfolioProjectCOVID.dbo.[Covid Vaccinations] vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
ORDER BY 2 ,3

--Find percentage population vaccinated per country
-- Using CTE

With popvsvac (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (int,vac.new_vaccinations)) over (partition by dea.location Order by dea.location ,
dea.Date  ) as PeopleVaccinated
--,(PeopleVaccinated/population)*100
From PortfolioProjectCOVID.dbo.[Covid Deaths] dea
Join PortfolioProjectCOVID.dbo.[Covid Vaccinations] vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--ORDER BY 2 ,3
)
Select*, (PeopleVaccinated/Population)*100 
from popvsvac 

--TEMP TABLE 1

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
PeopleVaccinated numeric
)
Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (int,vac.new_vaccinations)) over (partition by dea.location Order by dea.location ,
dea.Date  ) as PeopleVaccinated
--,(PeopleVaccinated/population)*100
From PortfolioProjectCOVID.dbo.[Covid Deaths] dea
Join PortfolioProjectCOVID.dbo.[Covid Vaccinations] vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--ORDER BY 2 ,3
 
 Select*, (PeopleVaccinated/Population)*100 
from #PercentPopulationVaccinated 



-- Creating View to store Data for Later Vizualisation

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (int,vac.new_vaccinations)) over (partition by dea.location Order by dea.location ,
dea.Date  ) as PeopleVaccinated
--,(PeopleVaccinated/population)*100
From PortfolioProjectCOVID.dbo.[Covid Deaths] dea
Join PortfolioProjectCOVID.dbo.[Covid Vaccinations] vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--ORDER BY 2 ,3  

Create View PercentPopulationVaccinatedandDeath as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations , dea.new_deaths
,SUM(CONVERT (int,vac.new_vaccinations)) over (partition by dea.location Order by dea.location ,
dea.Date  ) as PeopleVaccinated
--,(PeopleVaccinated/population)*100
From PortfolioProjectCOVID.dbo.[Covid Deaths] dea
Join PortfolioProjectCOVID.dbo.[Covid Vaccinations] vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--ORDER BY 2 ,3  








Select * 
From PercentPopulationVaccinated






