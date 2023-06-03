--Explore the Data:
select * from NashVilleProject..Sheet

-- let's Clean the Data:
---------------------------------------------------------------
--Standarize  the SaleDate from "2015-02-13 00:00:00.000" to "2015-02-13":
alter table NashVilleProject..Sheet add SaleDateConvert date
update NashVilleProject..Sheet set SaleDateConvert=convert(date,SaleDate)
select SaleDateConvert from NashVilleProject..Sheet
--check:
select * from NashVilleProject..Sheet

---------------------------------------------------------------------------------
--populate the PropertyAdresse and replace the "NULL" with the adresse based on ParceID:
--find theses rows First:
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress 
from NashVilleProject..Sheet a
join NashVilleProject..Sheet b ON a.ParcelID=b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
--fixe the probleme:
update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress) 
from NashVilleProject..Sheet a join NashVilleProject..Sheet b 
ON a.ParcelID=b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
--check:
select PropertyAddress from NashVilleProject..Sheet where PropertyAddress is null
------------------------------------------------------------------------------------------------
--separate the Propertyadresse into Individuals Columns "adresse , city":
select PropertyAddress from NashVilleProject..Sheet 

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Adresse,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as city
from NashVilleProject..Sheet

alter table NashVilleProject..Sheet add PropertyAdressSplit nvarchar(255)
alter table NashVilleProject..Sheet add PropertyCitySplit nvarchar(255)
update NashVilleProject..Sheet set PropertyAdressSplit=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
update NashVilleProject..Sheet set PropertycitySplit=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
-- check:
select * from NashVilleProject..Sheet

--separate the owneradresse into Individuals Columns "adresse ,city,state":
select OwnerAddress from NashVilleProject..Sheet
select PARSENAME(REPLACE(OwnerAddress,',','.'),3) OwnerAdresse,PARSENAME(REPLACE(OwnerAddress,',','.'),2) OwnerCity,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) OwnerAdresse
from NashVilleProject..Sheet

alter table NashVilleProject..Sheet add OwnerAdressSplit nvarchar(255)
alter table NashVilleProject..Sheet add OwnerCitySplit nvarchar(255)
alter table NashVilleProject..Sheet add OwnerStatSplit nvarchar(255)
update NashVilleProject..Sheet set OwnerCitySplit=PARSENAME(REPLACE(OwnerAddress,',','.'),2)
update NashVilleProject..Sheet set OwnerAdressSplit=PARSENAME(REPLACE(OwnerAddress,',','.'),3)
update NashVilleProject..Sheet set OwnerStatSplit=PARSENAME(REPLACE(OwnerAddress,',','.'),1)
--check :
select * from NashVilleProject..Sheet
--------------------------------------------------------------------------------------------------------------
--change N and Y to yes and No in SoldAsVacant :
select DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
from NashVilleProject..Sheet GROUP BY SoldAsVacant ORDER BY 2

update NashVilleProject..Sheet 
set SoldAsVacant=CASE WHEN SoldAsVacant='Y' then 'YES'
                      WHEN SoldAsVacant='N' then 'NO'
					  ELSE SoldAsVacant END

select DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
from NashVilleProject..Sheet GROUP BY SoldAsVacant ORDER BY 2
------------------------------------------------------------------------------------------------------------
--Remove Duplicates :

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashVilleProject..Sheet

)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
From NashVilleProject..Sheet

-- Delete Unused Columns



Select *
From NashVilleProject..Sheet


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate