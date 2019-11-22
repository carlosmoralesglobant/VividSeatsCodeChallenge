USE VividSeatsChallenge
GO

--Scenario 1
SELECT e.EventName, 
       FORMAT(e.EventDate, 'dddd, MMMM, yyyy hh:mm tt') EventDate,
       et.EventType,
       l.LocationName Venue,
       t.Section, 
       t.Row, 
       t.Quantity, 
       t.UnitPrice
FROM dbo.Tickets t
     INNER JOIN dbo.Events e on t.EventID = e.EventID
     INNER JOIN dbo.EventTypeCatalog et on e.EventTypeID = et.EventTypeID
     INNER JOIN dbo.Locations l on e.EventID = l.EventID
ORDER BY e.EventName, t.Section, t.Row;

--Scenario 2
--Note: Since there is no distinction on what a customer from another site can see, the query is pretty similar to the previous one
SELECT e.EventName, 
       FORMAT(e.EventDate, 'dddd, MMMM, yyyy hh:mm tt') EventDate,
       t.Section, 
       t.Row, 
       t.Quantity, 
       t.UnitPrice
FROM dbo.Tickets t
     INNER JOIN dbo.Events e on t.EventID = e.EventID
WHERE e.EventName = 'Oprah Winfrey'
ORDER BY e.EventName, t.Section, t.Row;

--Scenario 3
SELECT e.EventName, 
       FORMAT(e.EventDate, 'dddd, MMMM, yyyy hh:mm tt') EventDate,
       t.Section, 
       t.Row, 
       t.Quantity, 
       t.UnitPrice,
       t.Quantity*t.UnitPrice TotalPrice, 
       LocationName Venue, 
       l.City, 
       l.State, 
       cc.CountryName Country
FROM dbo.Tickets t
     INNER JOIN dbo.Events e on t.EventID = e.EventID
     INNER JOIN dbo.Locations l on t.EventId = l.EventID
     INNER JOIN dbo.CountryCatalog cc on l.CountryCode = cc.CountryCode
WHERE l.City = 'Glendale'
and t.UnitPrice between 10 and 60
ORDER BY e.EventName, t.Section, t.Row;

--Scenario 4
SELECT c.FullName CustomerName, 
       c.Email CustomerEmail,
       FORMAT(o.OrderDate,'mm/dd/yyyy') OrderDate, 
       e.EventName, FORMAT(e.EventDate, 'dddd, MMMM, yyyy hh:mm tt') as EventDate, 
       t.Section, 
       t.Row, 
       t.Quantity, 
       t.UnitPrice,
       t.Quantity*t.UnitPrice TotalPrice, 
       osc.StatusName Status
FROM dbo.Orders o
     INNER JOIN dbo.Customers c on o.CustomerID = c.CustomerID
     INNER JOIN dbo.Tickets t on o.TicketID = t.TicketID
     INNER JOIN dbo.Events e on t.EventId = e.EventID
     INNER JOIN dbo.OrderStatusCatalog osc on o.StatusID = osc.StatusID;

--Some interesting queries:

--The Lowest and Highest Price per Event
SELECT e.EventName, 
       FORMAT(e.EventDate, 'dddd, MMMM, yyyy hh:mm tt') EventDate,
       et.EventType,
       MIN(t.UnitPrice) LowestPrice,
       MAX(t.UnitPrice) HighestPrice
FROM dbo.Tickets t
     INNER JOIN dbo.Events e on t.EventID = e.EventID
     INNER JOIN dbo.EventTypeCatalog et on e.EventTypeID = et.EventTypeID
     INNER JOIN dbo.Locations l on e.EventID = l.EventID
GROUP BY e.EventName, 
       e.EventDate,
       et.EventType
ORDER BY e.EventName

--Customers per User Referal
SELECT ur.UserReferal,
       count(*) Quantity
FROM dbo.Customers c
     INNER JOIN dbo.UserReferals ur on c.UserReferalID = ur.UserReferalID
GROUP BY ur.UserReferal;

--Amount of Customers per City
SELECT a.City,
       count(*) Quantity
FROM dbo.Customers c
     INNER JOIN dbo.Addresses a on c.CustomerID = a.CustomerID
GROUP BY a.City
HAVING count(*) > 20
ORDER BY 2 DESC;

--Top 3 Events in Term of Quantity of tickets
SELECT e.EventName, 
       et.EventType,
       count(*) QuantityTickets
FROM dbo.Tickets t
     INNER JOIN dbo.Events e on t.EventID = e.EventID
     INNER JOIN dbo.EventTypeCatalog et on e.EventTypeID = et.EventTypeID
     INNER JOIN dbo.Locations l on e.EventID = l.EventID
GROUP BY e.EventName,
         et.EventType
ORDER BY 3 DESC;