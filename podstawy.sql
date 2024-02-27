select * from Products
where SupplierID = 4;

select * from Suppliers;
select * from Categories;

select * from Products
where Discontinued = 1;

select * from Products
where Discontinued = true; -- nie zadziała, bo ma być bit 0 lub 1

select * from Customers;

select * from Orders
where OrderID = 10250;

select * from [Order Details] -- [] bo spacja w nazwie. Może też być ""
where OrderID = 10250;

select ReportsTo, * -- wypisze ReportsTo 2 razy
from Employees;

select EmployeeID, FirstName, LastName,  Title
from Employees
where EmployeeID >= 5;

-- daty w formacie rok-miesiąc-dzień

--Wybierz nazwy i adresy wszystkich klientów mających siedziby w Londynie
select CompanyName, Address, City, Region, Country, PostalCode
from Customers
where city = 'London';

--Wybierz nazwy i adresy wszystkich klientów mających siedziby we Francji lub w Hiszpanii
select CompanyName, Address, City, Region, Country, PostalCode
from Customers
where Country = 'France' or Country = 'Spain'
order by Country;

--Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
select ProductName, UnitPrice
from Products
where UnitPrice between 20.00 and 30.00;

--Wybierz nazwy i ceny produktów z kategorii ‘meat’
select ProductName, UnitPrice
from Products
where CategoryID in (select CategoryID from Categories where CategoryName='Meat/Poultry');

--Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders’
select ProductName, UnitsInStock
from Products
where SupplierID in (select SupplierID from Suppliers where CompanyName = 'Tokyo Traders')
--lub
declare @id int;
set @id = (select SupplierID from Suppliers where CompanyName = 'Tokyo Traders')
select ProductName, UnitsInStock from Products where SupplierID = @id;

--Wybierz nazwy produktów których nie ma w magazynie
select ProductName, UnitsInStock
from Products
where UnitsInStock = 0;

-- 1. Find information about products sold in bottles. ('bottle')
select ProductName
from Products
where QuantityPerUnit like '%bottle%'

--2. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę z zakresu od B do L
select Title, LastName
from Employees
where LastName like '[B-L]%';

--alternatywnie
select Title, LastName
from Employees
where LEFT(LastName, 1) between 'b' and 'l';

--alternatywnie
select Title, LastName
from Employees
where LastName >= 'B' and LastName < 'M';

--Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę B lub L
select Title, LastName
from Employees
where LastName like 'B%' or LastName like 'L%';

/* Napisz instrukcję select tak aby wybrać numer zlecenia, datę zamówienia, numer
klienta dla wszystkich niezrealizowanych jeszcze zleceń, dla których krajem
odbiorcy jest Argentyna */

select OrderId, OrderDate, CustomerID
from Orders
where ShipCountry = 'Argentina' and (ShippedDate is NULL or ShippedDate > getdate());

-- select getdate();

/* Wybierz nazwy i kraje wszystkich klientów, wyniki posortuj według kraju, w ramach danego kraju nazwy firm posortuj alfabetycznie */

select CompanyName, Country
from Customers
order by country, CompanyName;

/* Wybierz informację o produktach (grupa, nazwa, cena), produkty posortuj wg grup a w grupach malejąco wg ceny */

select ProductName, CategoryID, UnitPrice
from Products
order by categoryId, UnitPrice desc;


-- Napisz polecenie, które oblicza wartość każdej pozycji zamówienia o numerze 10250
SELECT *, ROUND(UnitPrice * Quantity * (1 - Discount), 2)
FROM [Order Details]
WHERE OrderID = 10250;

SELECT *, cast(UnitPrice * Quantity * (1 - Discount) as decimal(10, 2))
FROM [Order Details]
WHERE ORderID = 10250;

/* Napisz polecenie które dla każdego dostawcy (supplier) pokaże pojedynczą kolumnę zawierającą nr telefonu i nr faksu w formacie
(numer telefonu i faksu mają być oddzielone przecinkiem) */

/* select Phone + ', ' + Fax as Telefon_i_fax
from Suppliers; W tej opcji pojawia się NULL, gdy chociaż jedno z nich jest NULL*/

select concat(Phone, ', ', Fax) as Telefon_i_fax
from Suppliers;

SELECT IIF(Fax IS NULL, Phone, CONCAT(Phone, ',', Fax)) AS formatted
FROM Suppliers;

select concat(Phone, ', ', IsNULL(fax, '-')) as Telefon_i_fax
from Suppliers;

SELECT CONCAT(Phone, ISNULL(',' + Fax, '')) AS formatted
FROM Suppliers
