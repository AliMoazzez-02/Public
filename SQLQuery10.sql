;with T
as
(
select c.CustomerID , c.CompanyName , o.OrderDate
	  ,lead(o.OrderDate) over (order by c.CustomerID) as NextOrder
	  ,lag(o.OrderDate) over (order by c.CustomerID) as PreOrder
      ,DATEDIFF(Day,OrderDate,lead(o.OrderDate) over (order by c.CustomerID)) as deff	 
	  ,(select sum(od.Quantity*od.UnitPrice) From [Order Details] od where od.OrderID=o.OrderID) as FirstAmount	  
from Customers c inner join Orders o on c.CustomerID = o.CustomerID
)
select * ,(select Sum(od.UnitPrice*od.Quantity)  from [Order Details] od inner join orders o on od.OrderID = o.OrderID
           where T.CustomerID = o.CustomerID and o.OrderDate=T.NextOrder) 
from T
where deff = 1
order by 1, 3
