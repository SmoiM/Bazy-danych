Podzapytania
--ĆWICZENIE 1.
-- 1. Wybierz nazwy i numery telefonów klientów, którym w 1997 roku przesyłki dostarczała firma United Package.
select distinct CustomerID, CompanyName, Phone
from Customers as C
where C.CustomerID in (select C2.CustomerID
                       from Customers as C2
                                inner join Orders as O on C2.CustomerID = O.CustomerID
                                inner join Shippers S on S.ShipperID = O.ShipVia
                       where S.CompanyName = 'United Package'
                         and year(O.ShippedDate) = 1997);

--------------------------------
select distinct CustomerID, CompanyName, Phone
from Customers as C
where C.CustomerID in (select O.CustomerID
                       from Orders as O
                                inner join Shippers S on S.ShipperID = O.ShipVia
                       where S.CompanyName = 'United Package'
                         and year(O.ShippedDate) = 1997);


-- 2. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii Confections.
select distinct CustomerID, CompanyName, Phone
from Customers
where CustomerID in (select CustomerID
                     from Orders as O
                              inner join [Order Details] as OD on O.OrderID = OD.OrderID
                              inner join Products as P on P.ProductID = OD.ProductID
                              inner join Categories C on P.CategoryID = C.CategoryID
                     where CategoryName = 'Confections');

-- 3. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii Confections.
select distinct CustomerID, CompanyName, Phone
from Customers
where CustomerID not in (select CustomerID
                         from Orders as O
                                  inner join [Order Details] as OD on O.OrderID = OD.OrderID
                                  inner join Products as P on P.ProductID = OD.ProductID
                                  inner join Categories as C on P.CategoryID = C.CategoryID
                         where CategoryName = 'Confections');

--ĆWICZENIE 2.
-- 1. Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek
select P.ProductID, ProductName, max(Quantity) as MaxQuantity
from Products as P
         inner join [Order Details] OD on P.ProductID = OD.ProductID
group by P.ProductID, ProductName;
-----------------------------------------------------------------------------
select ProductID,
       ProductName,
       (select max(quantity)
        from [Order Details] as OD
                 inner join Products as p_wew on p_wew.ProductID = OD.ProductID
        where p_wew.ProductID = p_zew.ProductID) as MaxQuantity
from Products as p_zew;

----------------------ZAPYTANIE KONTROLNE------------------------------------
select top 1 ProductName, quantity
from Products
         inner join [Order Details] "[O D]" on Products.ProductID = "[O D]".ProductID
where ProductName = 'Queso Manchego La Pastora'
order by Quantity desc;

-- 2. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktów
select ProductID, ProductName
from Products
where UnitPrice < (select avg(UnitPrice) from Products);

-- 3. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu danej kategorii
select ProductID,
       ProductName,
       CategoryID,
       UnitPrice,
       (select avg(UnitPrice)
        from products as p_wew
        where p_zew.CategoryID = p_wew.CategoryID) as AverageCategoryPrice
from Products as p_zew
where UnitPrice < (select avg(UnitPrice) from products as p_wew where p_zew.CategoryID = p_wew.CategoryID);

--ĆWICZENIE 3.
-- 1. Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich produktów oraz różnicę między ceną produktu a średnią ceną wszystkich produktów
select ProductID,
       ProductName,
       UnitPrice,
       (select avg(UnitPrice) from Products) as AverageProductPrice,
       UnitPrice - (select avg(UnitPrice) from Products) as PriceDifference
from Products;

-- 2. Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, średnią cenę wszystkich produktów danej kategorii oraz różnicę między ceną produktu a średnią ceną wszystkich produktów danej kategorii
select ProductID,
       ProductName,
       CategoryName,
       UnitPrice,
       (select avg(UnitPrice)
                    from products as p_wew
                    where P_zew.CategoryID = p_wew.CategoryID) as AverageCategoryPrice,
       UnitPrice - (select avg(UnitPrice)
                    from products as p_wew
                    where P_zew.CategoryID = p_wew.CategoryID) as PriceDifference
from Products as P_zew
         inner join Categories C on P_zew.CategoryID = C.CategoryID;

--ĆWICZENIE 4.
-- 1. Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij cenę za przesyłkę)
select sum(Quantity * UnitPrice * (1 - Discount))
           + (select Freight from Orders where OrderID = 10250) as TotalSum
from [Order Details]
where OrderID = 10250

-- 2. Podaj łączną wartość zamówień każdego zamówienia (uwzględnij cenę za przesyłkę)
select OrderID,
       cast(sum(Quantity * UnitPrice * (1 - Discount))
           + (select Freight from Orders as O_wew where OD_zew.OrderID = O_wew.OrderID) as decimal(10, 2)) as TotalSum
from [Order Details] as OD_zew
group by OrderID
-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak to pokaż ich dane adresowe
select distinct Customers.CustomerID, CompanyName, Address, City, PostalCode, Country
from Customers
         inner join Orders O on Customers.CustomerID = O.CustomerID
where Customers.CustomerID not in (select CustomerID from Orders where year(OrderDate) = 1997)
union
select Customers.CustomerID, CompanyName, Address, City, PostalCode, Country
from Customers
         left join Orders O on Customers.CustomerID = O.CustomerID
where OrderDate is null

-- 4. Podaj produkty kupowane przez więcej niż jednego klienta
select ProductID, ProductName
from Products
where ProductID in (select ProductID
                    from (select distinct P.productID, ProductName, CustomerID
                          from Products as P
                                   inner join [Order Details] OD on P.ProductID = OD.ProductID
                                   inner join Orders O on O.OrderID = OD.OrderID) as PR
                    group by ProductID, ProductName
                    having count(*) > 1)

--ĆWICZENIE 5. 
-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika(przy obliczaniu wartości zamówień uwzględnij cenę za przesyłkę) 

-- 2. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o  największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika 

-- 3. Ogranicz wynik z pkt 1 tylko do pracowników 
--      a) którzy mają podwładnych 
--      b) którzy nie mają podwładnych 
-- 4. Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać jeszcze datę ostatnio obsłużonego zamówienia 


select distinct EmBoss.EmployeeID,
                EmBoss.FirstName,
                EmBoss.LastName,
                --SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalValue 
from employees as EmBoss
         inner join Orders O on EmBoss.EmployeeID = O.EmployeeID
         inner join [Order Details] as OD on O.OrderID = OD.OrderID
         inner join Employees as EmEmp
                    on EmBoss.EmployeeID = EmEmp.ReportsTo
group by EmBoss.EmployeeID, EmBoss.FirstName, EmBoss.LastName

------------------------------------------------------------------------------- 

SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalValue
FROM Employees AS E
         JOIN (SELECT DISTINCT ReportsTo
               FROM Employees) AS K ON E.EmployeeID = K.ReportsTo
         LEFT JOIN Orders AS O
                   ON E.EmployeeID = O.EmployeeID
         JOIN [Order Details] AS OD
              ON O.OrderID = OD.OrderID
GROUP BY E.EmployeeID, E.FirstName, E.LastName

----------------------------------------------------

 
-- Podaj mi takie zamówienie, w których wszystkie pozycje były ze zniżką
 
 
-- Podaj mi takie zamówienie, w których żadna pozycja nie miała zniżki
select OrderID
from [Order Details]
group by OrderID
having max(Discount) = 0
except
select OrderID
from [Order Details]
group by OrderID
having sum(Discount) = 0


select OrderID
from [Order Details]
group by OrderID
having min(Discount) > 0
 
-- Podaj mi takie zamówienie, w których co najmniej jedna pozycja była ze zniżką


-- Podaj nazwy produktów które w marcu 1997 nie były kupowane przez klientów z Francji.
 -- Dla każdego takiego produktu podaj jego nazwę, nazwę kategorii, do której należy ten produkt oraz jego cenę.

-- Podaj nazwy produktów z kategorii confection, które w marcu 1997 nie były kupowane przez klientów z Francji.
 -- Dla każdego takiego produktu podaj jego nazwę, nazwę kategorii, do której należy ten produkt oraz jego cenę.
-- Wyświetl nazwy produktów, kupionych między '1997-02-01' i '1997-05-01' przez co najmniej 6 różnych klientów
-- Dla każdego dorosłego czytelnika podaj sumę kar zapłaconych za
 -- przetrzymywanie książek przez jego dzieci
 -- interesują nas czytelnicy, którzy mają dzieci



--podaj wartość sprzedaży w każdym roku
--interesują nas lata 1995-1999


-- 2) Pokaż nazwy produktów, które:
--      nie były z kategorii 'Beverages',
--      nie były kupowane w okresie od '1997.02.20' do '1997.02.25'.
-- Dla każdego takiego produktu podaj jego:
--      nazwę, nazwę dostawcy (supplier), oraz nazwę kategorii.
-- Zbiór wynikowy powinien zawierać:
--      nazwę produktu, nazwę dostawcy oraz nazwę kategorii.

select distinct ProductName, S.CompanyName, CategoryName
from Products P
         inner join Categories C on C.CategoryID = P.CategoryID
         inner join Suppliers S on S.SupplierID = P.SupplierID
         inner join [Order Details] OD on P.ProductID = OD.ProductID
         inner join Orders O on O.OrderID = OD.OrderID
where CategoryName != 'Beverages'
  and P.ProductID not in (select P.ProductID
                          from Products P
                                   inner join [Order Details] OD on P.ProductID = OD.ProductID
                                   inner join Orders O on O.OrderID = OD.OrderID
                          where OrderDate between '1997.02.20' and '1997.02.25')


-- 3) Podaj liczbę̨ zamówień oraz wartość zamówień (uwzględnij opłatę za przesyłkę) obsłużonych przez każdego pracownika w lutym 1997.
-- Za datę obsłużenia zamówienia należy uznać datę jego złożenia (orderdate).
-- Jeśli pracownik nie obsłużył w tym okresie żadnego zamówienia, to też powinien pojawić się na liście
--      (liczba obsłużonych zamówień oraz ich wartość jest w takim przypadku równa 0).
-- Zbiór wynikowy powinien zawierać:
--      imię i nazwisko pracownika, liczbę obsłużonych, wartość obsłużonych zamówień


select distinct FirstName,
                LastName,
                count(distinct O.OrderID)                                                     as NumberOfOrders,
                isnull(cast(sum(UnitPrice * Quantity * (1 - Discount)) as decimal(10, 2)), 0) as TotalValueWithoutFreight
from Employees E
         left join Orders O on E.EmployeeID = O.EmployeeID and OrderDate between '1997-02-01' and '1997-02-28'
         left join [Order Details] OD on O.OrderID = OD.OrderID
group by E.EmployeeID, FirstName, LastName;

--ISNULL
--CAST


-- 2) Wyświetl wszystkich pracowników, którzy nie mają podwładnych. Dla każdego z takich  pracowników podaj wartość obsłużonych przez niego zamówień w 1997r (sama wartość zamówień bez opłaty za przesyłkę)
select distinct e.FirstName,
                e.LastName,
                cast(sum(UnitPrice * Quantity * (1 - Discount)) as decimal(10, 2))
from Employees as E
         inner join Orders O on E.EmployeeID = O.EmployeeID
         inner join [Order Details] OD on O.OrderID = OD.OrderID
         left join Employees as boss
                   on E.EmployeeID = boss.ReportsTo
where boss.LastName is null
  and year(O.OrderDate) = 1997
group by e.EmployeeID, e.FirstName, e.LastName


-- 3) Wyświetl nr zamówień złożonych w marcu 1997, które nie zawierały produktów z kategorii confections

select OrderID
from Orders
where year(OrderDate) = 1997
  and OrderID not in (select orderid
                      from [Order Details] OD
                               inner join Products P on P.ProductID = OD.ProductID
                               inner join Categories C on C.CategoryID = P.CategoryID
                      where CategoryName = 'Confections')

-- 1) Podaj listę dzieci będących członkami biblioteki, które w dniu '2001-12-14' zwróciły do biblioteki książkę o tytule 'Walking'
select firstname, lastname, title
from member m
         inner join juvenile j on m.member_no = j.member_no
         inner join loan l on m.member_no = l.member_no
         inner join title t on t.title_no = l.title_no
         inner join copy c on l.isbn = c.isbn and l.copy_no = c.copy_no
         inner join loanhist l2 on c.isbn = l2.isbn and c.copy_no = l2.copy_no
where cast(in_date as date) = '2001-12-14'
  and title = 'Walking'

select firstname, lastname, title
from member m
         inner join juvenile j on m.member_no = j.member_no
         inner join loan l on m.member_no = l.member_no
         inner join title t on t.title_no = l.title_no
         inner join copy c on l.isbn = c.isbn and l.copy_no = c.copy_no
         inner join loanhist l2 on c.isbn = l2.isbn and c.copy_no = l2.copy_no
where year(in_date) = 2001
  and month(in_date) = 12
  and day(in_date) = 14
  and title = 'Walking'



-- 1) Podaj listę dzieci będących członkami biblioteki, dla każdego z tych dzieci podaj:
-- Imię, nazwisko, imię rodzica (opiekuna), nazwisko rodzica (opiekuna)

select distinct child.firstname, child.lastname, parent.member_no, parent.firstname, parent.lastname
from member as parent
         inner join adult a on parent.member_no = a.member_no
         inner join juvenile j on a.member_no = j.adult_member_no
         inner join member child on j.member_no = child.member_no
order by parent.member_no
