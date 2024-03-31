use management;
select * from hostel_staff where joining_date between '2019-01-01' and '2021-01-01';

select count(*) from complaints where status = 'open';

select * 
from hostel_staff,complaints
where hostel_staff.staff_id = complaints.staff_id and status = 'open';

select * from student_record where student_id = 1;

select * from payment_details where student_id = 1;

select * 
from student , room_allocation 
where student.student_id = room_allocation.student_id and room_no = 102;

select * from student  where student_name like 'a%';

select distinct role from hostel_staff;

select * from student where age between 18 and 20;

select * from payment_details where mode_of_payment = 'online transfer';

select * from laundry where number_of_clothes > 10;

select menu from mess where timing = '12:30:00';

select * from hostel_staff where year(joining_date) = 2020;

select * from utility_consumption where electricity_consumed > 100 and electricity_consumed < 150;

SELECT s.student_id, s.student_name, r.room_no, r.capacity
FROM student s
JOIN room_allocation r ON s.student_id = r.student_id;

SELECT pd.payment_id, pd.amount, pd.date_of_payment, s.student_name
FROM payment_details pd
JOIN student s ON pd.student_id = s.student_id
WHERE pd.mode_of_payment = 'Online Transfer';

select * 
from student , room_allocation 
where student.student_id = room_allocation.student_id order by room_no desc;

select count(distinct room_no) from room_allocation;

select room_no , count(student_id)
from student natural join room_allocation 
group by room_no
order by room_no;

--
SELECT date, COUNT(*) AS visitor_count
FROM visitors
GROUP BY date
ORDER BY visitor_count DESC
LIMIT 5;

--
SELECT hs.staff_id, hs.fname, hs.lname, COUNT(c.complaint_id) AS total_complaints
FROM hostel_staff hs
JOIN complaints c ON hs.staff_id = c.staff_id
GROUP BY hs.staff_id
ORDER BY total_complaints DESC
LIMIT 1;

--
SELECT *
FROM student s
LEFT JOIN payment_details pd ON s.student_id = pd.student_id
WHERE pd.payment_id IS NULL;

--
SELECT hs.*
FROM hostel_staff hs
LEFT JOIN staff_salary ss ON hs.staff_id = ss.staff_id AND MONTH(ss.date_salary) = 1 AND YEAR(ss.date_salary) = 2024
WHERE ss.staff_id IS NULL;

--
SELECT l.student_id, s.student_name, SUM(l.price) AS total_revenue
FROM laundry l
JOIN student s ON l.student_id = s.student_id
GROUP BY l.student_id, s.student_name;

--
SELECT staff_id, fname, lname, joining_date
FROM hostel_staff
WHERE DATEDIFF(CURRENT_DATE, joining_date) = (
    SELECT MAX(DATEDIFF(CURRENT_DATE, joining_date))
    FROM hostel_staff
);

--
SELECT book_type, borrow_count
FROM (
    SELECT book_type, COUNT(*) AS borrow_count,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS book_rank
    FROM library
    GROUP BY book_type
) AS ranked_books
WHERE book_rank <= 3;

--
SELECT ra.room_no, 
       months AS month,
       AVG(uc.electricity_consumed) AS avg_electricity_consumption,
       AVG(uc.wifi_no) AS avg_wifi_usage
FROM room_allocation ra
JOIN utility_consumption uc ON ra.allocation_id = uc.allocation_id
WHERE uc.months IS NOT NULL
GROUP BY ra.room_no, months;

--
SELECT ra.room_no, 
       ra.capacity - COUNT(ra.student_id) AS remaining_capacity
FROM room_allocation ra
GROUP BY ra.room_no, ra.capacity
order by room_no;

--
SELECT s.student_id, s.student_name
FROM student s
WHERE EXISTS (
    SELECT 1
    FROM gym g
    WHERE g.student_id = s.student_id
)
AND EXISTS (
    SELECT 1
    FROM laundry l
    WHERE l.student_id = s.student_id
)
AND EXISTS (
    SELECT 1
    FROM library lb
    WHERE lb.student_id = s.student_id
)
AND EXISTS (
    SELECT 1
    FROM mess m
    WHERE m.student_id = s.student_id
);

SELECT *
FROM student_record
WHERE student_id = 2 AND date = '2024-01-03';

SELECT student_id, COUNT(*) AS books_borrowed
FROM library
GROUP BY student_id;

SELECT hs.*, ss.salary
FROM hostel_staff hs
JOIN staff_salary ss ON hs.staff_id = ss.staff_id
WHERE ss.date_salary = '2023-03-01';

SELECT student_id, COUNT(*) AS laundry_transactions
FROM laundry
GROUP BY student_id;

SELECT student_id, SUM(price) AS total_mess_expense
FROM mess
GROUP BY student_id;

SELECT student_id, COUNT(*) AS days_stayed
FROM student_record
GROUP BY student_id;

SELECT AVG(electricity_consumed) AS avg_electricity_consumption
FROM utility_consumption;