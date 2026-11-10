select
	customerid,
	count(distinct invoiceno) as total_orders,
	sum(quantity * unitprice) as total_spents
from supermarketsales
where customerid is not null
group by customerid
order by total_spents desc
limit 5;
