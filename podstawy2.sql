-- 1. Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
select OrderID, max(unitPrice)
from [Order details]
group by OrderId;

-- 2. Posortuj zamówienia wg maksymalnej ceny produktu
select OrderID, max(UnitPrice)
from [order details]
group by OrderID
order by max(unitPrice) desc;

-- 3. Podaj maksymalną i minimalną cenę zamawianego produktu dla każdegozamówienia
select OrderID, max(unitPrice) as max, min(unitPrice) as min
from [Order details]
group by OrderId;

-- 4. Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów(przewoźników)
select shipVia, count(orderID) as numberOfOrders
from Orders
group by shipVia;

-- 5. Który z spedytorów był najaktywniejszy w 1997 roku
select top 1 shipVia, count(shippedDate) as TotalOrders
from Orders
where year(shippedDate) = 1997
group by shipVia
order by TotalOrders desc;

--1. Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5

select orderID, count(ProductID) as productsNumber
from [Order Details]
group by orderID
having count(*) > 5

--2. Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień
--(wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień dla każdego z klientów)

select customerID, count(orderID) as ordersNumber, sum(freight) as totalFreight
from orders
where year(shippedDate) = 1998
group by customerID
having count(*) > 8
order by totalFreight desc;

--1. Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia
--w tablicy order details i zwraca wynik posortowany w malejącej kolejności(wg wartości sprzedaży).
select OrderID, cast(sum((UnitPrice * Quantity) * (1 - Discount)) as decimal (10, 2)) as cost
from [order details]
group by OrderID
order by cost desc;

--2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych 10 wierszy
select top 10 OrderID, cast(sum((UnitPrice * Quantity) * (1 - Discount)) as decimal (10, 2)) as cost
from [order details]
group by OrderID
order by cost desc;

-- Który klient najdłużej czekał na swoje zamówienie (od orderDate do ShippedDate)

select top 1 CustomerID, sum(datediff(second, orderDate, shippedDate)) as totalTime
from Orders
group by customerID
order by totalTime desc;

-- 1. Podaj liczbę zamówionych jednostek produktów dla produktów, dla których productid < 3

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby podawało liczbę zamówionych
-- jednostek produktu dla wszystkich produktów

-- 3. Podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których
-- łączna liczba zamawianych jednostek produktów jest > 250

-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
-- pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy

select ProductName, UnitPrice, suppliers.Address, Suppliers.City, Suppliers.Region, Suppliers.PostalCode
from Products
inner join Suppliers
    on Products.SupplierID = Suppliers.SupplierID
where UnitPrice between 20 and 30;

-- 2. Wybierz nazwy produktów oraz informacje o stanie magazynu dla produktów
-- dostarczanych przez firmę ‘Tokyo Traders’

select ProductName, UnitsInStock
from Products
join Suppliers
    on Products.SupplierID = Suppliers.SupplierID
where CompanyName = 'Tokyo Traders';

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak to pokaż ich dane adresowe

select Customers.CustomerID, Customers.CompanyName, Customers.City
from Customers 
left join Orders on  Customers.CustomerID = Orders.CustomerID
                                    and year(OrderDate) = 1997
where OrderID is null
order by OrderID;


select Customers.CustomerID, Customers.CompanyName, Customers.City
from Customers 
left join Orders on  Customers.CustomerID = Orders.CustomerID
                                    and year(OrderDate) = 1997
group by Customers.CustomerID, Customers.CompanyName, Customers.City
    having count(OrderID) = 0;

-- count(*) liczy wiersze
-- count(nazwa kolumny) liczy wystąpienia różne od nulla

select CustomerID, CompanyName, Address
from Customers C
where C.CustomerID not in (select CustomerID
                            from Orders
                                    where year(OrderDate) = 1997);

select c.CustomerID, c.CompanyName, c.City
from Customers c left join (select orderid, customerid
                                from Orders o
                                    where year(orderdate) = 1997) o97
    on c.CustomerID = o97.CustomerID
where orderid is null
order by orderid


-- 4. Wybierz nazwy i numery telefonów dostawców, dostarczających produkty,
-- których aktualnie nie ma w magazynie
select CompanyName, Phone
from Suppliers
    join Products
        on Products.SupplierID = Suppliers.SupplierID
where UnitsInStock = 0

