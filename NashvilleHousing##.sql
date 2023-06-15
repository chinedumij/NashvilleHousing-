/*

Cleaning Data in SQL Queries

*/

select *
from NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
select SaleDate
from NashvilleHousing

select SaleDate, convert(Date,SaleDate)as SALEDATE
from NashvilleHousing

update NashvilleHousing
set SaleDate = convert(Date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDate = convert(Date,SaleDate)


select SaleDate, convert(Date,SaleDate)as SALEDATE
from NashvilleHousing


alter table NashvilleHousing
add SaleDateConverted1 Date;

update NashvilleHousing
set SaleDateConverted1 = convert(Date,SaleDate)
----we alter before updating.
-- If it doesn't Update properly




--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
select PropertyAddress, ParcelID
from NashvilleHousing

---the ParcelID and PropertyAddress seems to be the same, this imlpies that we populate the null PropertyAddress
---with their Equivalent ParcelID
select PropertyAddress,ParcelID
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID
---to eaisly idintify PropertyAddress needed to populate the nulls, we jion the table to its self 
---with their Equivalent ParcelID but not with same uniqueID.

select  a.UniqueID,a.ParcelID,a.Propertyaddress,b.ParcelID,B.propertyAddress
from NashvilleHousing a
join NashvilleHousing b
on a. ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID

select  a.UniqueID,a.ParcelID,a.Propertyaddress,b.ParcelID,B.propertyAddress
from NashvilleHousing a
join NashvilleHousing b
on a. ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

select  a.UniqueID,a.ParcelID,a.Propertyaddress,b.ParcelID,B.propertyAddress, isnull( a.PropertyAddress,b .PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a. ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null
---is means that the null a.PropertAddress cells be populated with its Equivalent b.PropertyAddress
----next we update the Table
update a
set PropertyAddress = isnull( a.PropertyAddress,b .PropertyAddress)
from  NashvilleHousing a
join NashvilleHousing b
on a. ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

---runing the below, we identify that there is no null cells again.

select  a.UniqueID,a.ParcelID,a.Propertyaddress,b.ParcelID,B.propertyAddress, isnull( a.PropertyAddress,b .PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a. ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

select *
from NashvilleHousing
where PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
select PropertyAddress
from NashvilleHousing

select PropertyAddress,substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address
,substring(PropertyAddress,charindex(',',PropertyAddress)+ 1, len(PropertyAddress)) as Address
from NashvilleHousing

---next we createb and add the two columbs to the table
alter table NashvilleHousing
add PropertySplitAddress nvarchar(225);

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)


alter table NashvilleHousing
add PropertySplitCity nvarchar(225);

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress,charindex(',',PropertyAddress)+ 1, len(PropertyAddress)) 

select *
from NashvilleHousing


select OwnerAddress
from NashvilleHousing

select
parsename(replace(ownerAddress,',','.'),3),
parsename(replace(ownerAddress,',','.'),2),
parsename(replace(ownerAddress,',','.'),1)
from NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAddress1 nvarchar(225);

update NashvilleHousing
set OwnerSplitAddress1 = parsename(replace(ownerAddress,',','.'),3)


alter table NashvilleHousing
add OwnerSplitState nvarchar(225);

update NashvilleHousing
set OwnerSplitState = parsename(replace(ownerAddress,',','.'),2)


alter table NashvilleHousing
add OwnerSplitCity1 nvarchar(225);

update NashvilleHousing
set OwnerSplitCity1 = parsename(replace(ownerAddress,',','.'),1)








--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant),count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsvacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldasVacant = 'N' then 'No'
else SoldAsVacant
end
from NashvilleHousing

----next we update it
update NashvilleHousing
set SoldAsVacant =
case when SoldAsVacant = 'Y' then 'Yes'
when SoldasVacant = 'N' then 'No'
else SoldAsVacant
end







-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
with RowNumCTE As
(
select *,row_number() over(
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
legalReference
order by UniqueID) row_num
from NashvilleHousing)

select *
from RowNumCTE
Where row_num > 1
Order by PropertyAddress


with RowNumCTE As
(
select *,row_number() over(
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
legalReference
order by UniqueID) row_num
from NashvilleHousing)

delete
from RowNumCTE
Where row_num > 1
---Order by PropertyAddress

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


select *
from with RowNumCTE As
(
select *,row_number() over(
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
legalReference
order by UniqueID) row_num
from NashvilleHousing)

select *
from RowNumCTE
Where row_num > 1
Order by PropertyAddress



alter table NashvilleHousing
drop column Propertyaddress,SaleDate,OwnerAddress,SaleDAteconverted,OwnerSplitCity,OwnerSplitAddress1









-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

