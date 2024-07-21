-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM((o.quantity) * (p.price)), 2) AS tot_revenue
FROM
    order_details o
        JOIN
    pizzas p ON p.pizza_id = o.pizza_id;
    
    
    -- Identify the highest-priced pizza
    select pi.price, p.name
    from pizza_types p join pizzas pi on pi.pizza_type_id=p.pizza_type_id
    order by pi.price desc limit 1 ;
    
    -- Identify the most common pizza size ordered
    select  pizzas.size, count(order_details.order_details_id) as order_count 
    from pizzas join order_details on pizzas.pizza_id=order_details.pizza_id
    group by pizzas.size order by order_count desc ;
    
    -- List the top 5 most ordered pizza types along with their quantities.
    select pizza_types.name, 
    sum(order_details.quantity) as quantity 
	from pizza_types join pizzas 
    on pizza_types.pizza_type_id = pizzas.pizza_type_id
	join order_details 
    on order_details.pizza_id=pizzas.pizza_id
    group by pizza_types.name order by quantity desc limit 5
    ;
    
    -- Join the necessary tables to find the total quantity of each pizza category ordered.
    select pizza_types.category as pizza_category , sum(order_details.quantity) as quantity 
    from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
    join order_details
    on order_details.pizza_id= pizzas.pizza_id 
    group by pizza_category order by quantity desc ;
    
    -- Determine the distribution of orders by hour of the day
    select hour(time), count(order_id) from orders
    group by hour(time);
    
    -- Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name)
from pizza_types 
group by category ;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg(quant),0) as average from 
(select sum(o_d.quantity) as quant, o.date
from orders o join order_details o_d on o.order_id = o_d.order_id
group by o.date) as order_quant ;

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name, sum(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category , round((sum(order_details.quantity*pizzas.price))/817860*100,2) as revenue
from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;

-- Analyze the cumulative revenue generated over time.
select date,sum(revenue) over(order by date) as cumu_revenue 
from
(select orders.date, sum(order_details.quantity*pizzas.price) as revenue
from order_details join pizzas on order_details.pizza_id=pizzas.pizza_id
join orders 
on orders.order_id=order_details.order_id
group by orders.date) as sales ;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, revenue 
from 
(
select category, name, revenue, rank() over(partition by category order by revenue desc) as rn 
from
(select pizza_types.category, pizza_types.name, sum(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas on pizza_types.pizza_type_id =pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category, pizza_types.name ) as a ) as b
where rn<=3; 









 
