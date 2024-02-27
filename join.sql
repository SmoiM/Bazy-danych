Join
3.0 Join
-- ĆWICZENIE 1. 
-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy 
select ProductName, Products.UnitPrice, CompanyName, Address, City, Country
from Products
         inner join [Order Details] "[O D]" on Products.ProductID = "[O D]".ProductID
         inner join Suppliers S on S.SupplierID = Products.SupplierID
group by Products.ProductID, ProductName, Products.UnitPrice, CompanyName, Address, City, Country
having Products.UnitPrice between 20 and 30

-- 2. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders’ 
select ProductName, avg(UnitsInStock)
from Products
         inner join [Order Details] "[O D]" on Products.ProductID = "[O D]".ProductID
         inner join Suppliers S on S.SupplierID = Products.SupplierID
where S.CompanyName = 'Tokyo Traders'
group by Products.ProductID, ProductName

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak to pokaż ich dane adresowe 
select distinct C.CustomerID, Address, City, Country
from Customers as C
         left join Orders as O on C.CustomerID = O.CustomerID
where C.CustomerID not in (select distinct CustomerID
                           from Orders
                           where year(OrderDate) = 1997)

-- 4. Wybierz nazwy i numery telefonów dostawców, dostarczających produkty, których aktualnie nie ma w magazynie 
select CompanyName, Phone
from Suppliers
         inner join Products P on Suppliers.SupplierID = P.SupplierID
where UnitsInStock = 0


-- ĆWICZENIE 2. 
-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko i data urodzenia dziecka. 
select distinct m.member_no, firstname, lastname, birth_date
from juvenile
         inner join member m on m.member_no = juvenile.member_no

-- 2. Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek 
select distinct title
from title
         inner join copy c on title.title_no = c.title_no
where on_loan = 'Y'

-- 3. Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao Teh King’. Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką zapłacono karę 
select due_date, datediff(day, in_date, due_date) as numberOfDays, fine_paid
from loanhist
         inner join title t on loanhist.title_no = t.title_no
where loanhist.fine_paid is not null
  and title = 'Tao Teh King'

-- 4. Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych przez osobę o nazwisku: Stephen A. Graff 
select isbn
from reservation
         inner join member m on m.member_no = reservation.member_no
where concat(firstname, ' ', middleinitial, '. ', lastname) = 'Stephen A. Graff'


-- Ćwiczenie 3.
-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy, interesują nas tylko produkty z kategorii ‘Meat/Poultry’
select productId, ProductName, UnitPrice, Address, City, Country
from Products P
         inner join Suppliers S on S.SupplierID = P.SupplierID
         inner join Categories C on C.CategoryID = P.CategoryID
where UnitPrice between 20 and 30
  and CategoryName = 'Meat/Poultry'

-- 2. Wybierz nazwy i ceny produktów z kategorii ‘Confections’ dla każdego produktu podaj nazwę dostawcy.
select ProductName, UnitPrice, CompanyName
from Products
         inner join Categories C on C.CategoryID = Products.CategoryID
         inner join Suppliers S on S.SupplierID = Products.SupplierID
where CategoryName = 'Confections'

-- 3. Wybierz nazwy i numery telefonów klientów, którym w 1997 roku przesyłki dostarczała firma ‘United Package’
select distinct C.CompanyName, C.Phone
from Customers C
         inner join Orders O on C.CustomerID = O.CustomerID
         inner join Shippers S on S.ShipperID = O.ShipVia
where S.CompanyName = 'United Package'
  and year(ShippedDate) = 1997

-- 4. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii ‘Confections’
select C.CompanyName, C.Phone
from Customers C
         inner join Orders O on C.CustomerID = O.CustomerID
         inner join [Order Details] OD on O.OrderID = OD.OrderID
         inner join Products P on P.ProductID = OD.ProductID
         inner join Categories C2 on C2.CategoryID = P.CategoryID
where CategoryName = 'Confections'
group by C.CustomerID, C.CompanyName, C.Phone

-- Ćwiczenia
-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka i adres zamieszkania dziecka.
select firstname, lastname, birth_date, street, city, state
from member
         inner join juvenile j on member.member_no = j.member_no
         inner join adult a on a.member_no = j.adult_member_no

-- 2. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka, adres zamieszkania dziecka oraz imię i nazwisko rodzica.
select firstname, lastname, birth_date, street, city, state
from member
         inner join juvenile j on member.member_no = j.member_no
         inner join adult a on a.member_no = j.adult_member_no

-- 1. Napisz polecenie, które wyświetla pracowników oraz ich podwładnych (baza northwind)
select w.FirstName as EmployeeFirstName,
       w.LastName  as EmployeeLAstName,
       b.FirstName as BossFirstName,
       b.LastName  as BossLastName
from Employees w
         left join Employees b
                   on w.ReportsTo = b.EmployeeID;

-- 1.5. Napisz polecenie, które wyświetla pracowników, którzy mają podwładnych (baza northwind)
select distinct b.FirstName, b.LastName
from Employees w
         inner join Employees b
                    on w.ReportsTo = b.EmployeeID;

-- 2. Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych (baza northwind)
--PODZAPYTANIE
select w.FirstName, w.LastName
from Employees w
         left join Employees b
                   on w.ReportsTo = b.EmployeeID
where w.EmployeeID not in (select distinct b.EmployeeID
                           from Employees w
                                    inner join Employees b
                                               on w.ReportsTo = b.EmployeeID);
--------------------------------------------------
--JOIN
--Inne  podejście - dla każdego pracownika (emp) zwraca listę jego podwładnych (pod)
select emp.LastName, emp.FirstName, pod.EmployeeID
from employees emp
         left join employees as pod
                   on emp.EmployeeID = pod.ReportsTo
where pod.EmployeeID is null;
--------------------------------------------------
--EXCEPT
select FirstName, LastName
from Employees
except
select distinct boss.FirstName, boss.LastName
from Employees emp
         inner join Employees boss
                    on emp.ReportsTo = boss.EmployeeID;


-- 3. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci urodzone przed 1 stycznia 1996
select m.firstname, m.lastname, a.street, a.city, a.state, a.zip
from member m
         inner join adult a
                    on m.member_no = a.member_no
         inner join juvenile j
                    on a.member_no = j.adult_member_no
where j.birth_date < '1996-01-01'
  and firstname = 'Katie'
group by m.member_no, m.firstname, m.lastname, a.street, a.city, a.state, a.zip

-- Wypisuje to zadanie dodatkowo z dziećmi
SELECT m.firstname AS parent_first,
       m.lastname  AS parent_last,
       c.firstname AS child_first,
       c.lastname  AS child_last,
       j.birth_date,
       a.street,
       a.city,
       a.state,
       a.zip
FROM member m
         JOIN adult a ON m.member_no = a.member_no
         JOIN juvenile j ON a.member_no = j.adult_member_no
         JOIN member c ON j.member_no = c.member_no
WHERE j.birth_date < '1996-01-01';
3.1 Join - Ćwiczenie końcowe
-- ĆWICZENIE 1. 
-- 1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz nazwę klienta 
select O.OrderID, C.CompanyName, sum(Quantity) as SumOfProducts
from [Order Details] as OD
         inner join Orders as O on OD.OrderID = O.OrderID
         inner join Customers as C on O.CustomerID = C.CustomerID
group by O.OrderID, C.CompanyName;

-- 2. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których 
-- łączna liczbę zamówionych jednostek jest większa niż 250 
select O.OrderID, C.CompanyName, sum(Quantity) as SumOfProducts
from [Order Details] as OD
         inner join Orders as O on OD.OrderID = O.OrderID
         inner join Customers as C on O.CustomerID = C.CustomerID
group by O.OrderID, C.CompanyName
having sum(Quantity) > 250;

-- 3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę klienta 
select O.OrderID,
       CompanyName,
       cast(sum((UnitPrice * Quantity) * (1 - Discount)) as decimal(10, 2))
           as TotalSum
from [Order Details] as OD
         inner join Orders as O on OD.OrderID = O.OrderID
         inner join Customers as C on O.CustomerID = C.CustomerID
group by O.OrderID, CompanyName;

-- 4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których łączna liczba jednostek jest większa niż 250 
select O.OrderID, CompanyName, sum((UnitPrice * Quantity) * (1 - Discount)) as TotalSum
from [Order Details] as OD
         inner join Orders as O on OD.OrderID = O.OrderID
         inner join Customers as C on O.CustomerID = C.CustomerID
group by O.OrderID, CompanyName
having sum(Quantity) > 250;

-- 5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko pracownika obsługującego zamówienie 
select O.OrderID,
       C.CompanyName,
       concat(E.FirstName, ' ', E.LastName)         as Employee,
       sum((UnitPrice * Quantity) * (1 - Discount)) as TotalSum
from [Order Details] as OD
         inner join Orders as O on OD.OrderID = O.OrderID
         inner join Customers as C on O.CustomerID = C.CustomerID
         inner join Employees E on O.EmployeeID = E.EmployeeID
group by O.OrderID, C.CompanyName, E.FirstName, E.LastName
having sum(Quantity) > 250;



-- ĆWICZENIE 2. 
-- 1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez klientów jednostek towarów z tej kategorii 
select C.CategoryName, sum(OD.Quantity) as TotalNumberOfProducts
from Categories as C
         inner join Products P on C.CategoryID = P.CategoryID
         inner join [Order Details] as OD on P.ProductID = OD.ProductID
group by C.CategoryID, C.CategoryName
order by C.CategoryID;
-- dla  ładniejszego zapisu 

-- 2. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych przez klientów jednostek towarów z tej kategorii 
select C.CategoryName, cast(sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) as decimal(10, 2)) as TotalValue
from Categories as C
         inner join Products P on C.CategoryID = P.CategoryID
         inner join [Order Details] as OD on P.ProductID = OD.ProductID
group by C.CategoryID, C.CategoryName;

-- 3. Posortuj wyniki w zapytaniu z poprzedniego punktu wg: 
--      a) łącznej wartości zamówień 
select C.CategoryName, cast(sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) as decimal(10, 2)) as TotalValue
from Categories as C
         inner join Products P on C.CategoryID = P.CategoryID
         inner join [Order Details] as OD on P.ProductID = OD.ProductID
group by C.CategoryID, C.CategoryName
order by TotalValue;

--      b) łącznej liczby zamówionych przez klientów jednostek towarów 
select C.CategoryName, cast(sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) as decimal(10, 2)) as TotalValue
from Categories as C
         inner join Products P on C.CategoryID = P.CategoryID
         inner join [Order Details] as OD on P.ProductID = OD.ProductID
group by C.CategoryID, C.CategoryName
order by sum(OD.Quantity);

-- 4. Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę 
select OD.OrderID,
       Freight,
       cast(sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) + Freight as decimal(10, 2)) as CostWithFreight
from [Order Details] as OD
         inner join Orders O on O.OrderID = OD.OrderID
group by OD.OrderID, Freight
order by OrderID;

-- ĆWICZENIE 3. 
-- 1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997 r. 
select S.CompanyName, count(*) as TotalNumberOfShippedOrders
from Shippers as S
         inner join Orders O on S.ShipperID = O.ShipVia and year(O.ShippedDate) = 1997
group by S.ShipperID, S.CompanyName;

-- Podpunkt bardziej specyficzny z dokładnym przedziałem datowym i pokazuje wszystkich przewoźników nawet gdy nic nie przewieźli 


select S.CompanyName, count(O.OrderID) as TotalNumberOfShippedOrders
from Shippers as S
         left join Orders O on S.ShipperID = O.ShipVia and O.ShippedDate between '1997-03-01' and '1997-03-03'
group by S.ShipperID, S.CompanyName;


-- 2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę zamówień) w 1997r, podaj nazwę tego przewoźnika 
select top 1 S.CompanyName
from Shippers as S
         inner join Orders O on S.ShipperID = O.ShipVia and year(O.ShippedDate) = 1997
group by S.ShipperID, S.CompanyName
order by count(*) desc;

-- 3. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika 
select E.FirstName,
       E.LastName,
       cast(sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) as decimal(10, 2)) as TotalValueOfHandledOrders
from Employees as E
         inner join Orders O on E.EmployeeID = O.EmployeeID
         inner join [Order Details] OD on O.OrderID = OD.OrderID
group by E.EmployeeID, E.FirstName, E.LastName;

-- 4. Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i nazwisko takiego pracownika 
select top 1 E.FirstName, E.LastName, count(*) as TotalNumberOfServicedOrders
from Employees as E
         left join Orders O on E.EmployeeID = O.EmployeeID
where year(O.OrderDate) = 1997
group by E.EmployeeID, E.FirstName, E.LastName
order by count(*) desc;

-- 5. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika 
select distinct E.FirstName, E.LastName, OD.OrderID
from Employees as E
         inner join Orders as O on E.EmployeeID = O.EmployeeID
         inner join [Order Details] as OD on O.OrderID = OD.OrderID

select top 1 E.FirstName,
             E.LastName,
             cast(sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) as decimal(10, 2)) as ValueOfHandledOrders
from Employees as E
         left join Orders O on E.EmployeeID = O.EmployeeID
         inner join [Order Details] as OD on O.OrderID = OD.OrderID
where year(O.OrderDate) = 1997
group by E.EmployeeID, E.FirstName, E.LastName
order by ValueOfHandledOrders desc



--ĆWICZENIE 4.
-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika
select E.FirstName,
       E.LastName,
       cast(sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) as decimal(10, 2)) as ValueOfHandledOrders
from Employees as E
         inner join Orders as O on E.EmployeeID = O.EmployeeID
         inner join [Order Details] as OD on O.OrderID = OD.OrderID
group by E.EmployeeID, E.FirstName, E.LastName


-- Ogranicz wynik tylko do pracowników
-- a) którzy mają podwładnych
select distinct EmBoss.EmployeeID,
                EmBoss.FirstName,
                EmBoss.LastName, --SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS TotalValue 
from employees as EmBoss
         inner join Orders O on EmBoss.EmployeeID = O.EmployeeID
         inner join [Order Details] as OD on O.OrderID = OD.OrderID
         inner join Employees as EmEmp
                    on EmBoss.EmployeeID = EmEmp.ReportsTo
group by EmBoss.EmployeeID, EmBoss.FirstName, EmBoss.LastName


select FirstName, LastName, ReportsTo from Employees


-- Dla każdego klienta podaj liczbę zamówień z miesięcy 1997, 98
select C.CustomerID, C.CompanyName, month(O.OrderDate) as Month, year(O.OrderDate) as Year, count(O.OrderID) as NumberOfOrders
from Customers as C
left join Orders O on C.CustomerID = O.CustomerID and year(O.OrderDate) between 1997 and 1998
group by C.CustomerID, C.CompanyName, month(OrderDate), year(OrderDate)
order by C.CustomerID, C.CompanyName, Year, Month

-- Wybierz nazwy i numery telefonu klientów, którzy kupowali producty z kategorii 'Confections'
select distinct C.CustomerID, C.CompanyName, C.Phone
from Customers as C
         inner join Orders O on C.CustomerID = O.CustomerID
         inner join [Order Details] as OD on O.OrderID = OD.OrderID
         inner join Products as P on OD.ProductID = P.ProductID
         inner join Categories as Ca on Ca.CategoryID = P.CategoryID
where Ca.CategoryName = 'Confections'


-- Wybierz nazwy i numery telefonu klientów, którzy nie kupowali producty z kategorii 'Confections'
select distinct CustomerID, CompanyName, Phone
from Customers
where CustomerID not in (select C.CustomerID
                         from Customers as C
                                  inner join Orders O on C.CustomerID = O.CustomerID
                                  inner join [Order Details] as OD on O.OrderID = OD.OrderID
                                  inner join Products as P on OD.ProductID = P.ProductID
                                  inner join Categories as Ca on Ca.CategoryID = P.CategoryID
                         where Ca.CategoryName = 'Confections')

-- Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produków z kategorii ‘Confections’

select CompanyName, Phone
from Customers C
where C.CustomerID not in (select CustomerID
from Orders O
inner join [Order Details] [O D] on O.OrderID = [O D].OrderID
inner join Products P on P.ProductID = [O D].ProductID
inner join Categories C2 on C2.CategoryID = P.CategoryID
where C2.CategoryName = 'Confections')

-- Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produków z kategorii ‘Confections’
SELECT Customers.CompanyName, Customers.Phone
FROM Customers
         LEFT OUTER JOIN Orders O on Customers.CustomerID = O.CustomerID
         LEFT OUTER JOIN [Order Details] "[O D]" on O.OrderID = "[O D]".OrderID
         LEFT OUTER JOIN Products P on P.ProductID = "[O D]".ProductID
         LEFT OUTER JOIN Categories C on C.CategoryID = P.CategoryID AND (C.CategoryName = 'Confections')
GROUP BY Customers.CustomerID, Customers.CompanyName, Customers.Phone
HAVING COUNT(C.CategoryID) = 0
