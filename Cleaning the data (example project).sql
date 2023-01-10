/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvileHousing]

  --Standarize Date Format
  select *
  from PortfolioProject.dbo.NashvileHousing

  select SaleDate, CONVERT(Date, SaleDate)
  from PortfolioProject.dbo.NashvileHousing

  Update NashvileHousing
  Set SaleDate = CONVERT(Date, SaleDate)

  ALTER TABLE NashvileHousing
  Add SaleDateConverted Date;

   Update NashvileHousing
  Set SaleDateConverted = CONVERT(Date, SaleDate)

  select SaleDateConverted, CONVERT(Date, SaleDate)
  from PortfolioProject.dbo.NashvileHousing

  --Populate Property Address Data

  select *
  from PortfolioProject.dbo.NashvileHousing
  --where PropertyAddress is null
  order by ParcelID

  select a.ParcelId, a.PropertyAddress, b.ParcelId, b.PropertyAddress
  from PortfolioProject.dbo.NashvileHousing a
  JOIN PortfolioProject.dbo.NashvileHousing b
	on a.ParcelId = b.ParcelId
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select a.ParcelId, a.PropertyAddress, b.ParcelId, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  from PortfolioProject.dbo.NashvileHousing a
  JOIN PortfolioProject.dbo.NashvileHousing b
	on a.ParcelId = b.ParcelId
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvileHousing a
  JOIN PortfolioProject.dbo.NashvileHousing b
	on a.ParcelId = b.ParcelId
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address Into individual Columns

select PropertyAddress
from PortfolioProject.dbo.NashvileHousing

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address

from PortfolioProject.dbo.NashvileHousing

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

from PortfolioProject.dbo.NashvileHousing


  ALTER TABLE NashvileHousing
  Add PropertySplitAddress nvarchar(255);

   Update NashvileHousing
  Set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

   ALTER TABLE NashvileHousing
  Add PropertySplitCity nvarchar(255);

   Update NashvileHousing
  Set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


select *
  from PortfolioProject.dbo.NashvileHousing

  select OwnerAddress
  from PortfolioProject.dbo.NashvileHousing

  select
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
  ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
  ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
  from PortfolioProject.dbo.NashvileHousing

    select
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
  ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
  ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
  from PortfolioProject.dbo.NashvileHousing


   ALTER TABLE NashvileHousing
  Add OwnerSplitAddress nvarchar(255);

   Update NashvileHousing
  Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

   ALTER TABLE NashvileHousing
  Add OwnerSplitCity nvarchar(255);

   Update NashvileHousing
  Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

   ALTER TABLE NashvileHousing
  Add OwnerSplitState nvarchar(255);

   Update NashvileHousing
  Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

  select *
   from PortfolioProject.dbo.NashvileHousing

--Change Y and N to Yes and No in "Sold as Vacant" column

select Distinct(SoldAsVacant)
from PortfolioProject.dbo.NashvileHousing

select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.NashvileHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE	When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
from PortfolioProject.dbo.NashvileHousing

Update NashvileHousing
SET SoldAsVacant = CASE	When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


--Remove Duplicate


select *
   from PortfolioProject.dbo.NashvileHousing



select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from PortfolioProject.dbo.NashvileHousing
Order by ParcelID


WITH RowNumbCTE AS(
select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from PortfolioProject.dbo.NashvileHousing
--Order by ParcelID
)
select *
from RowNumbCTE

WITH RowNumbCTE AS(
select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from PortfolioProject.dbo.NashvileHousing
--Order by ParcelID
)
select *
from RowNumbCTE
where row_num > 1
order by PropertyAddress


WITH RowNumbCTE AS(
select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from PortfolioProject.dbo.NashvileHousing
--Order by ParcelID
)
DELETE
from RowNumbCTE
where row_num > 1
--order by PropertyAddress

WITH RowNumbCTE AS(
select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from PortfolioProject.dbo.NashvileHousing
--Order by ParcelID
)
select *
from RowNumbCTE
where row_num > 1
order by PropertyAddress

-- Delete Unuse Column


select *
from PortfolioProject.dbo.NashvileHousing

ALTER TABLE PortfolioProject.dbo.NashvileHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvileHousing
DROP COLUMN SaleDate

