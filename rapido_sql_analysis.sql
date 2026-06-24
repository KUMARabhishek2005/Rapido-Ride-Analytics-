use rapido;

#1. Retrieve all successful bookings:
SELECT * FROM rapido_ride WHERE `Booking Status` = 'Success';

#2. Find the average ride distance for each vehicle type:
select `Vehicle Type`, avg(`Ride Distance (km)`)  as Avg_Distance_km from rapido_ride where `Booking Status`='Success' group by `Vehicle Type` order by Avg_Distance_km desc;

#3. Get the total number of cancelled rides by customers:
select count(`Cancelled by Customer`) as cancelled_by_customer from rapido_ride where `Cancelled by Customer`='yes';

#4. List the top 5 customers who booked the highest number of rides:
select `Customer ID`,count(*) as total_ride from rapido_ride where `Booking Status`='Success' group by `Customer ID` order by total_ride desc limit 5;

#5. Get the number of rides cancelled by drivers due to personal and car-related issues:
SELECT DISTINCT `Cancellation Reason (Driver)`, COUNT(*) FROM rapido_ride WHERE `Booking Status` = 'Cancelled by Driver' AND `Cancellation Reason (Driver)`= 'Personal & Car related issues' GROUP BY `Cancellation Reason (Driver)`;

#6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
select max(`Driver Rating`)as maxi ,min(`Driver Rating`) as mini from rapido_ride where `Vehicle Type`='Prime Sedan' and `Booking Status`='Success';

#7. Retrieve all rides where payment was made above 500 rupees:
select *from rapido_ride where  `Booking Value (INR)`>500;

#8. Find the average customer rating per vehicle type:
select `Vehicle Type`,round(avg(`Customer Rating`),2) as avg_cust_rating from rapido_ride where `Booking Status`='Success' and `Customer Rating` is not null  group by `Vehicle Type` order by  avg_cust_rating desc;

#9. Calculate the total booking value of rides completed successfully:
select round(sum(`Booking Value (INR)`),2) as total_booking_value from rapido_ride where `Booking Status`='Success';

#10. List all incomplete rides along with the reason:
select Date,Time,`Booking ID`,`Customer ID`,`Vehicle Type`,`Driver Rating`,`Customer Rating`,`Pickup Location`,`Drop Location`  from rapido_ride  where `Booking Status` = 'Incomplete Ride' order by Date,Time;

#Q11. Average ride distance per vehicle type (successful rides only).
select `Vehicle Type`,round(avg(`Ride Distance (km)`),2) as avg_ride_dis from rapido_ride where `Booking Status`='Success'  group by `Vehicle Type`;

#Q12. Top 5 pickup locations with most ride requests.
select `Pickup Location`,count(*) as ride_request from rapido_ride where `Booking Status`='success'group by `Pickup Location` order by ride_request desc limit 5;

#Q13. Cancellation rate % for customers and drivers separately.
select  round(sum(case when `Booking Status`= 'Cancelled by Customer' then 1 else 0 end)*100/count(*),2) as cancelled_cust_rate, round(sum(case when `Booking Status`= 'Cancelled by Driver' then 1 else 0 end)*100/count(*),2) as cancelled_driv_rate from rapido_ride;

#Q14. Customers who took more than 3 successful rides.
select `Customer ID`,count(*) as total_ride from rapido_ride where `Booking Status`= 'Success'  group by `Customer ID`having count(*)>3 order by  total_ride desc;

#Q15. Rides where VTAT is greater than 10 minutes.
select `Booking ID`,`Customer ID`,`Vehicle Type`,`Avg VTAT (mins)`,`Avg CTAT (mins)` from rapido_ride where `Booking Status`='Success' AND `Avg VTAT (mins)`>10 order by`Avg VTAT (mins)` desc;

#Q16. Most common cancellation reason given by customers.
select `Cancellation Reason (Customer)`,count(*) as common_reason from rapido_ride where `Booking Status`='Cancelled by Customer' group by `Cancellation Reason (Customer)` order by common_reason limit 1;

#Q17.Day-wise total rides and revenue for the month.
select Date, count(*) as total,
sum(case when `Booking Status`='Success' then 1 else 0 end ) as successful_ride,
round(sum(`Booking Value (INR)`),2) as revenue
from rapido_ride
group by Date
order by Date;

#Q18.Pickup-drop pairs appearing more than 10 times
select `Pickup Location`,`Drop Location`,count(*) as pair_count from rapido_ride where `Booking Status`= 'Success' group by `Pickup Location`,`Drop Location` having count(*)>40 order by pair_count desc;

#Q19. Rank vehicle types by total revenue using window functions
select `Vehicle Type` ,total_revenue,rank() over ( order by total_revenue) as revenue_rank from (
select `Vehicle Type`,round( sum(`Booking Value (INR)`),2) as total_revenue from rapido_ride where `Booking Status`='Success' group by `Vehicle Type` 
)  as t
order by revenue_rank ;

#Q20. Customers who cancelled more than they completed top 5.
select `Customer ID`,
sum( case when `Booking Status`='Success' then 0 else 1 end) as complete,
sum( case when `Booking Status`='Cancelled by Customer' then 0 else 1 end) as cancelled
 from rapido_ride group by `Customer ID`
 having cancelled>complete
 order by cancelled desc limit 5;
 
 #21.Hour of the day with the most bookings.
 select hour(Time) as hour_day,count(*) as total_ride from rapido_ride group by hour(time) order by total_ride desc limit 5;
 











