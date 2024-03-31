create database management;
use management;
show tables;
create table hostel_staff (
    staff_id varchar(5) primary key,
    fname text not null,
    lname text not null,
    contact_details text not null,
    address text not null,
    role text not null,
    joining_date date not null,
    gender text check (gender in ('m', 'f', 'o'))
);
desc hostel_staff;

create table student (
    student_id integer primary key not null auto_increment,
    student_name text not null,
    age integer not null,
    date_of_birth date not null,
    college text not null,
    address text not null
);
desc student;

create table room_allocation (
    allocation_id integer primary key auto_increment,
    allocation_date date not null,
    capacity integer not null,
    room_no varchar(10) not null,
    staff_id varchar(5),
    student_id integer,
    foreign key (staff_id) references hostel_staff(staff_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE,
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc room_allocation;
create table complaints (
    complaint_id integer primary key auto_increment,
    status varchar(20) not null,
    description text not null,
    complaint_date date not null,
    staff_id varchar(5),
    student_id integer,
    foreign key (staff_id) references hostel_staff(staff_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE,
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc complaints;

create table utility_consumption (
    electricity_consumed decimal not null,
    electricity_price float not null,
    wifi_no int not null,
    wifi_price decimal not null,
    staff_id varchar(5),
    student_id integer,
    allocation_id integer,
    months varchar(15),
    foreign key (staff_id) references hostel_staff(staff_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE,
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE,
    foreign key (allocation_id) references room_allocation(allocation_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc utility_consumption;

create table student_dependents (
    dependent_id integer primary key auto_increment,
    father_name text not null,
    father_contact_number text not null,
    father_posting text,
    mother_name text not null,
    mother_contact_number text not null,
    student_id integer,
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc student_dependents;

create table booking_details (
    booking_id varchar(10) primary key,
    total_fees decimal not null,
    security_deposit decimal not null,
    tenure integer not null,
    booking_date date,
    student_id integer,
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc booking_details;

create table payment_details (
    payment_id varchar(10),
    amount decimal not null,
    mode_of_payment text not null,
    date_of_payment date not null,
    booking_id varchar(10),
    student_id integer,
    primary key (payment_id , student_id),
    foreign key (booking_id) references booking_details(booking_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE,
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc payment_details;

create table visitors (
    visitor_id integer auto_increment,
    date date not null ,
    check_in_time time not null,
    check_out_time time,
    visitor_name text not null,
    student_id integer,
    primary key(visitor_id,date),
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc visitors;

create table student_record (
    date date not null,
    check_in time not null,
    check_out time,
    student_id integer,
    primary key (date, student_id),
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc student_record;

create table laundry (
	laundry_id INTEGER PRIMARY KEY auto_increment,
    timing time not null,
    number_of_clothes integer not null,
    price int generated always as
	(number_of_clothes*7) stored,
    student_id integer,
    date date,
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc laundry;
create table library (
	library_id integer primary key auto_increment,
    book_type varchar(50) not null,
    timing time not null,
    capacity integer not null,
    student_id integer,
    date date,
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc library;

create table gym (
	gym_id integer primary key auto_increment,
    timing time not null,
    equipment varchar(50) not null,
    student_id integer,
    date date,
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc gym;

create table mess (
	mess_no integer auto_increment ,
    timing time not null,
    menu varchar(255) not null,
    capacity integer not null,
    student_id integer,
    price int not null,
    date date,
    primary key(mess_no , student_id),
    foreign key (student_id) references student(student_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc mess;

CREATE TABLE staff_salary (
    staff_id varchar(5),
    date_salary DATE,
    salary DECIMAL(10, 2),
    PRIMARY KEY (staff_id, date_salary),
    FOREIGN KEY (staff_id) REFERENCES hostel_staff(staff_id)
    ON UPDATE CASCADE
	ON DELETE CASCADE
);
desc staff_salary;    
INSERT INTO hostel_staff (staff_id, fname, lname, contact_details, address, role, joining_date, gender)
VALUES
    ('S0001', 'Rahul', 'Sharma', '9876543210', '12, Vikas Nagar, New Delhi', 'Warden', '2020-05-01', 'm'),
    ('S0002', 'Priya', 'Gupta', '8765432109', '35, Sector 18, Noida', 'Receptionist', '2021-07-15', 'f'),
    ('S0003', 'Anil', 'Kumar', '7654321098', '27/A, Laxmi Nagar, Mumbai', 'Security Guard', '2019-03-01', 'm'),
    ('S0004', 'Neha', 'Kapoor', '6543210987', '14, Saket, New Delhi', 'Accountant', '2022-09-01', 'f'),
    ('S0005', 'Rajesh', 'Singh', '5432109876', '8, Mahatma Gandhi Road, Bangalore', 'Maintenance Staff', '2018-11-01', 'm'),
    ('S0006', 'Anita', 'Prasad', '4321098765', '76, Anna Nagar, Chennai', 'Warden', '2020-02-15', 'f'),
    ('S0007', 'Vivek', 'Mehta', '3210987654', '19, Sector 12, Faridabad', 'Security Guard', '2021-06-01', 'm'),
    ('S0008', 'Riya', 'Verma', '2109876543', '5/B, Indira Nagar, Lucknow', 'Receptionist', '2023-01-01', 'f'),
    ('S0009', 'Amit', 'Chopra', '1098765432', '32, Sector 17, Gurgaon', 'Maintenance Staff', '2019-08-01', 'm'),
    ('S0010', 'Pooja', 'Saxena', '9765432109', '67, Defence Colony, New Delhi', 'Accountant', '2021-03-15', 'f'),
    ('S0011', 'Sanjay', 'Rao', '8654321098', '22, Bandra West, Mumbai', 'Warden', '2020-07-01', 'm'),
    ('S0012', 'Rani', 'Malhotra', '7543210987', '41, Sector 27, Noida', 'Receptionist', '2022-04-01', 'f'),
    ('S0013', 'Vikram', 'Sharma', '6432109876', '11, Sarojini Nagar, New Delhi', 'Security Guard', '2018-09-15', 'm'),
    ('S0014', 'Sania', 'Khan', '5321098765', '28, Koramangala, Bangalore', 'Maintenance Staff', '2021-11-01', 'f'),
    ('S0015', 'Rohit', 'Patel', '4210987654', '62, Sector 15, Faridabad', 'Accountant', '2020-01-01', 'm'),
    ('S0016', 'Ishita', 'Agarwal', '3109876543', '9, Indiranagar, Lucknow', 'Warden', '2022-06-01', 'f'),
    ('S0017', 'Arjun', 'Reddy', '2098765432', '17, Banjara Hills, Hyderabad', 'Security Guard', '2019-12-01', 'm'),
    ('S0018', 'Nisha', 'Kulkarni', '1987654321', '53, Shivaji Nagar, Pune', 'Receptionist', '2021-09-01', 'f'),
    ('S0019', 'Suresh', 'Lal', '9876543210', '39, Sector 19, Gurgaon', 'Maintenance Staff', '2020-03-15', 'm'),
    ('S0020', 'Reena', 'Desai', '8765432109', '24, Juhu, Mumbai', 'Accountant', '2022-08-01', 'f'),
    ('S0021', 'Vishal', 'Malhotra', '7654321098', '16, Rajouri Garden, New Delhi', 'Warden', '2019-05-01', 'm'),
    ('S0022', 'Divya', 'Jain', '6543210987', '43, Sector 34, Noida', 'Receptionist', '2023-02-01', 'f'),
    ('S0023', 'Ravi', 'Chawla', '5432109876', '58, Sector 7, Faridabad', 'Security Guard', '2021-01-15', 'm'),
    ('S0024', 'Shruti', 'Mishra', '4321098765', '31, Indira Nagar, Lucknow', 'Maintenance Staff', '2020-09-01', 'f'),
    ('S0025', 'Dheeraj', 'Srinivasan', '3210987654', '6, Anna Nagar, Chennai', 'Accountant', '2022-03-01', 'm'),
    ('S0026', 'Meera', 'Yadav', '2109876543', '49, Sector 29, Gurgaon', 'Warden', '2018-07-01', 'f'),
    ('S0027', 'Nitin', 'Sharma', '1098765432', '21, Sector 14, Faridabad', 'Security Guard', '2021-04-15', 'm'),
    ('S0028', 'Kavita', 'Patel', '9765432109', '37, Koramangala, Bangalore', 'Receptionist', '2020-11-01', 'f'),
    ('S0029', 'Satish', 'Rai', '8654321098', '63, Sector 18, Noida', 'Maintenance Staff', '2019-06-01', 'm'),
    ('S0030', 'Anjali', 'Sinha', '7543210987', '15, Banjara Hills, Hyderabad', 'Accountant', '2022-12-01', 'f');
select * from hostel_staff;
INSERT INTO student (student_name, age, date_of_birth, college, address) VALUES
('Aarush Sharma', 20, '2003-06-15', 'University of Mumbai', 'DAH Hostel'),
('Ananya Singh', 19, '2004-11-02', 'NMIMS University', 'DAH Hostel'),
('Arjun Patel', 21, '2002-09-28', 'Tata Institute of Social Sciences', 'DAH Hostel'),
('Diya Gupta', 18, '2005-03-10', 'K.J. Somaiya College of Engineering', 'DAH Hostel'),
('Ishaan Chopra', 22, '2001-07-20', 'Narsee Monjee Institute of Management Studies', 'DAH Hostel'),
('Kavya Desai', 20, '2003-12-05', 'Mithibai College', 'DAH Hostel'),
('Kiaan Mehta', 19, '2004-08-12', 'Sardar Patel College of Engineering', 'DAH Hostel'),
('Myra Kapoor', 21, '2002-02-25', 'H.R. College of Commerce and Economics', 'DAH Hostel'),
('Neel Malhotra', 20, '2003-10-18', 'Jai Hind College', 'DAH Hostel'),
('Priya Jain', 19, '2004-06-30', 'Vivekananda Education Society Institute of Technology', 'DAH Hostel'),
('Rishab Agarwal', 22, '2001-04-08', 'Jamnalal Bajaj Institute of Management Studies', 'DAH Hostel'),
('Samyukta Verma', 20, '2003-01-14', 'Ramnarain Ruia Autonomous College', 'DAH Hostel'),
('Shaurya Yadav', 21, '2002-11-22', 'Sardar Patel Institute of Technology', 'DAH Hostel'),
('Shreya Bhati', 19, '2004-07-05', 'IIT Bombay', 'DAH Hostel'),
('Tanish Sinha', 20, '2003-03-27', 'D.J. Sanghvi College of Engineering', 'DAH Hostel'),
('Vani Reddy', 18, '2005-09-18', 'Sophia College for Women', 'DAH Hostel'),
('Yash Kulkarni', 21, '2002-05-12', 'Narsee Monjee Institute of Management Studies', 'DAH Hostel'),
('Zara Khan', 20, '2003-08-02', 'K.C. College', 'DAH Hostel'),
('Aditya Lal', 19, '2004-12-19', 'Xavier Institute of Engineering', 'DAH Hostel'),
('Aryan Desai', 22, '2001-02-08', 'Sir J.J. College of Architecture', 'DAH Hostel'),
('Ishita Malhotra', 20, '2003-06-25', 'Ramnarain Ruia Autonomous College', 'DAH Hostel'),
('Kabir Jain', 21, '2002-10-31', 'University of Mumbai', 'DAH Hostel'),
('Leela Chawla', 19, '2004-04-16', 'NMIMS University', 'DAH Hostel'),
('Nisha Mishra', 20, '2003-07-09', 'Tata Institute of Social Sciences', 'DAH Hostel'),
('Rohan Srinivasan', 18, '2005-01-03', 'K.J. Somaiya College of Engineering', 'DAH Hostel'),
('Saanvi Yadav', 21, '2002-11-28', 'Narsee Monjee Institute of Management Studies', 'DAH Hostel'),
('Swara Sharma', 20, '2003-05-20', 'Mithibai College', 'DAH Hostel'),
('Vansh Patel', 19, '2004-09-07', 'Sardar Patel College of Engineering', 'DAH Hostel'),
('Yash Rai', 22, '2001-06-13', 'H.R. College of Commerce and Economics', 'DAH Hostel'),
('Zoya Sinha', 20, '2003-02-01', 'Jai Hind College', 'DAH Hostel');
select * from student;
INSERT INTO room_allocation (allocation_date, capacity, room_no, staff_id,student_id) VALUES
('2023-03-15', 4, '101', 'S0001',1),
('2022-08-20', 4, '202', 'S0002',2),
('2021-11-05', 4, '101', 'S0001',3),
('2023-01-10', 4, '102', 'S0004',4),
('2022-06-25', 4, '301', 'S0005',5),
('2023-04-01', 4, '202', 'S0002',6),
('2021-09-18', 4, '103', 'S0001',7),
('2022-12-31', 4, '102', 'S0004',8),
('2023-02-14', 4, '203', 'S0009',9),
('2022-07-07', 4, '202', 'S0002',10),
('2021-05-22', 4, '103', 'S0001',11),
('2023-03-01', 4, '102', 'S0004',12),
('2022-10-08', 4, '303', 'S0005',13),
('2021-04-30', 4, '202', 'S0002',14),
('2023-01-20', 4, '104', 'S0001',15),
('2022-09-12', 4, '104', 'S0004',16),
('2021-07-04', 4, '201', 'S0009',17),
('2022-11-27', 4, '203', 'S0002',18),
('2023-02-05', 4, '103', 'S0001',19),
('2021-12-18', 4, '303', 'S0020',20),
('2022-03-11', 4, '102', 'S0001',21),
('2023-04-15', 4, '204', 'S0004',22),
('2021-06-29', 4, '201', 'S0009',23),
('2022-08-13', 4, '301', 'S0002',24),
('2023-03-25', 4, '204', 'S0001',25),
('2021-10-02', 4, '302', 'S0020',26),
('2022-05-09', 4, '303', 'S0001',27),
('2023-01-28', 4, '302', 'S0020',28),
('2022-07-16', 4, '201', 'S0009',29),
('2021-03-06', 4, '304', 'S0004',30);
select * from room_allocation;

INSERT INTO complaints (status, description, staff_id, student_id, complaint_date)
VALUES
('Open', 'Leaking tap in room 101', 'S0001', 1, '2024-02-19'),
('Closed', 'Noisy neighbors in room 202', 'S0002', 2, '2024-01-17'),
('Open', 'Broken window in room 305', 'S0003', 3, '2024-02-21'),
('Closed', 'Clogged sink in room 408', 'S0001', 4, '2024-01-14'),
('Open', 'Faulty air conditioning in room 512', 'S0005', 5, '2024-02-20'),
('Open', 'Pest issue in room 615', 'S0006', 6, '2024-01-16'),
('Closed', 'Damaged furniture in room 719', 'S0007', 7, '2024-02-22'),
('Closed', 'Electrical issue in room 823', 'S0001', 8, '2024-02-15'),
('Open', 'Plumbing problem in room 927', 'S0009', 9, '2024-02-18'),
('Closed', 'Dirty room in room 1031', 'S0002', 10, '2024-01-13'),
('Open', 'Heating issue in room 1135', 'S0011', 11, '2024-02-23'),
('Closed', 'Internet connectivity issue in room 1239', 'S0012', 12, '2024-02-12'),
('Open', 'Broken lock in room 1343', 'S0001', 13, '2024-01-19'),
('Closed', 'Poor lighting in room 1447', 'S0014', 14, '2024-02-17'),
('Open', 'Pest control required in room 1551', 'S0015', 15, '2024-02-21'),
('Closed', 'Damaged closet in room 1655', 'S0005', 16, '2024-02-14'),
('Closed', 'Faulty smoke detector in room 1759', 'S0017', 17, '2024-02-20'),
('Closed', 'Blocked drainage in room 1863', 'S0018', 18, '2024-01-16'),
('Closed', 'Damaged bed in room 1967', 'S0001', 19, '2024-01-22'),
('Closed', 'Noise complaint in room 2071', 'S0020', 20, '2024-02-15'),
('Open', 'Leaking ceiling in room 2175', 'S0021', 21, '2024-02-18'),
('Closed', 'Broken mirror in room 2279', 'S0002', 22, '2024-02-13'),
('Open', 'Faulty water heater in room 2383', 'S0023', 23, '2024-01-23'),
('Closed', 'Dirty bathroom in room 2487', 'S0024', 24, '2024-02-12'),
('Open', 'Pest issue in room 2591', 'S0005', 25, '2024-02-19'),
('Closed', 'Damaged door in room 2695', 'S0026', 26, '2024-01-17'),
('Open', 'Electrical short circuit in room 2799', 'S0001', 27, '2024-02-21'),
('Closed', 'Broken window latch in room 2903', 'S0028', 28, '2024-02-14'),
('Open', 'Heating issue in room 3007', 'S0029', 29, '2024-02-20'),
('Closed', 'Clogged sink in room 3111', 'S0030', 30, '2024-01-16');
select * from complaints;
ALTER TABLE utility_consumption
MODIFY COLUMN electricity_consumed DECIMAL(10, 2) NOT NULL;

INSERT INTO utility_consumption (electricity_consumed, electricity_price, wifi_no, wifi_price, staff_id, student_id, allocation_id, months)
VALUES
(120.50, 6.75, 12345, 500.00, 'S0001', 1, 1, 'January'),
(180.20, 6.75, 23456, 600.00, 'S0002', 2, 2, 'January'),
(110.80, 6.75, 34567, 500.00, 'S0001', 3, 3, 'January'),
(140.30, 6.75, 45678, 550.00, 'S0004', 4, 4, 'January'),
(210.60, 6.75, 56789, 650.00, 'S0005', 5, 5, 'January'),
(190.40, 6.75, 67890, 600.00, 'S0002', 6, 6, 'January'),
(130.20, 6.75, 78901, 550.00, 'S0001', 7, 7, 'January'),
(160.70, 6.75, 89012, 575.00, 'S0004', 8, 8, 'January'),
(180.50, 6.75, 90123, 625.00, 'S0009', 9, 9, 'January'),
(170.30, 6.75, 01234, 600.00, 'S0002', 10, 10, 'January'),
(125.80, 6.75, 12345, 550.00, 'S0001', 11, 11, 'January'),
(145.60, 6.75, 23456, 575.00, 'S0004', 12, 12, 'January'),
(205.20, 6.75, 34567, 650.00, 'S0005', 13, 13, 'January'),
(165.90, 6.75, 45678, 600.00, 'S0002', 14, 14, 'January'),
(135.40, 6.75, 56789, 575.00, 'S0001', 15, 15, 'January'),
(150.80, 6.75, 67890, 550.00, 'S0004', 16, 16, 'January'),
(195.60, 6.75, 78901, 625.00, 'S0009', 17, 17, 'January'),
(175.30, 6.75, 89012, 600.00, 'S0002', 18, 18, 'January'),
(140.70, 6.75, 90123, 550.00, 'S0001', 19, 19, 'February'),
(185.40, 6.75, 01234, 625.00, 'S0020', 20, 20, 'February'),
(130.60, 6.75, 12345, 575.00, 'S0001', 21, 21, 'February'),
(155.20, 6.75, 23456, 600.00, 'S0004', 22, 22, 'February'),
(170.80, 6.75, 34567, 625.00, 'S0009', 23, 23, 'February'),
(160.50, 6.75, 45678, 575.00, 'S0002', 24, 24, 'February'),
(145.30, 6.75, 56789, 550.00, 'S0001', 25, 25, 'February'),
(190.60, 6.75, 67890, 650.00, 'S0020', 26, 26, 'February'),
(135.20, 6.75, 78901, 600.00, 'S0001', 27, 27, 'February'),
(180.70, 6.75, 89012, 625.00, 'S0020', 28, 28, 'February'),
(165.40, 6.75, 90123, 600.00, 'S0009', 29, 29, 'February'),
(150.90, 6.75, 01234, 575.00, 'S0004', 30, 30, 'February'),
(125.60, 6.75, 12345, 550.00, 'S0001', 1, 1, 'February'), 
(115.80, 6.75, 23456, 525.00, 'S0001', 1, 1, 'February'), 
(190.40, 6.75, 34567, 600.00, 'S0002', 2, 2, 'February'), 
(175.20, 6.75, 45678, 575.00, 'S0002', 2, 2, 'February');
select * from utility_consumption;

INSERT INTO student_dependents (father_name, father_contact_number, father_posting, mother_name, mother_contact_number, student_id)
VALUES
('Raj Sharma', '9876543210', 'Manager', 'Priya Sharma', '9812345678', 1),
('Anil Singh', '8765432109', 'Engineer', 'Neha Singh', '8901234567', 2),
('Rahul Patel', '7654321098', 'Businessman', 'Nisha Patel', '7890123456', 3),
('Vikram Gupta', '6543210987', 'Professor', 'Pooja Gupta', '6789012345', 4),
('Sanjay Chopra', '5432109876', 'Doctor', 'Rani Chopra', '5678901234', 5),
('Naveen Desai', '4321098765', 'Accountant', 'Reena Desai', '4567890123', 6),
('Amit Mehta', '3210987654', 'Software Engineer', 'Ishita Mehta', '3456789012', 7),
('Vinay Kapoor', '2109876543', 'Marketing Manager', 'Supriya Kapoor', '2345678901', 8),
('Ravi Malhotra', '1098765432', 'Banker', 'Seema Malhotra', '1234567890', 9),
('Deepak Jain', '9012345678', 'Civil Engineer', 'Divya Jain', '9876543210', 10),
('Nikhil Agarwal', '8901234567', 'Entrepreneur', 'Neha Agarwal', '8765432109', 11),
('Rohit Verma', '7890123456', 'IT Professional', 'Anjali Verma', '7654321098', 12),
('Anuj Yadav', '6789012345', 'Teacher', 'Priya Yadav', '6543210987', 13),
('Harish Bhati', '5678901234', 'Sales Manager', 'Geeta Bhati', '5432109876', 14),
('Rohan Sinha', '4567890123', 'Lawyer', 'Sunita Sinha', '4321098765', 15),
('Vikas Reddy', '3456789012', 'Consultant', 'Swati Reddy', '3210987654', 16),
('Arjun Kulkarni', '2345678901', 'Architect', 'Sanjana Kulkarni', '2109876543', 17),
('Aditya Khan', '1234567890', 'Marketing Executive', 'Shruti Khan', '1098765432', 18),
('Ramesh Lal', '9765432109', 'Business Analyst', 'Gayatri Lal', '9876543210', 19),
('Sunil Desai', '8654321098', 'HR Manager', 'Meera Desai', '8765432109', 20),
('Shyam Malhotra', '7543210987', 'Operations Manager', 'Kritika Malhotra', '7654321098', 21),
('Pratik Jain', '6432109876', 'Finance Executive', 'Shikha Jain', '6543210987', 22),
('Vishal Chawla', '5321098765', 'Network Administrator', 'Deepika Chawla', '5432109876', 23),
('Rajesh Mishra', '4210987654', 'Project Manager', 'Nandini Mishra', '4321098765', 24),
('Sanjay Srinivasan', '3109876543', 'Software Developer', 'Puja Srinivasan', '3210987654', 25),
('Rakesh Yadav', '2098765432', 'Marketing Analyst', 'Amrita Yadav', '2109876543', 26),
('Ashok Sharma', '1987654321', 'Quality Assurance', 'Richa Sharma', '1098765432', 27),
('Rajiv Patel', '9876543210', 'Production Manager', 'Nisha Patel', '9765432109', 28),
('Mohan Rai', '8765432109', 'Sales Executive', 'Asha Rai', '8654321098', 29),
('Praveen Sinha', '7654321098', 'Data Analyst', 'Anu Sinha', '7543210987', 30);

select * from student_dependents;

INSERT INTO booking_details (booking_id, total_fees, security_deposit, tenure, student_id, booking_date)
VALUES
('BK001', 50000.00, 5000.00, 12, 1, '2022-05-01'),
('BK002', 45000.00, 4500.00, 10, 2, '2022-07-15'),
('BK003', 55000.00, 6000.00, 14, 3, '2022-09-20'),
('BK004', 48000.00, 5500.00, 11, 4, '2022-11-05'),
('BK005', 60000.00, 7000.00, 16, 5, '2023-01-10'),
('BK006', 52000.00, 6500.00, 13, 6, '2023-02-22'),
('BK007', 47000.00, 5000.00, 10, 7, '2023-04-01'),
('BK008', 58000.00, 6500.00, 15, 8, '2023-05-15'),
('BK009', 53000.00, 5500.00, 12, 9, '2022-06-01'),
('BK010', 49000.00, 5000.00, 11, 10, '2022-08-10'),
('BK011', 62000.00, 7000.00, 17, 11, '2022-10-20'),
('BK012', 56000.00, 6000.00, 14, 12, '2022-12-05'),
('BK013', 51000.00, 5500.00, 12, 13, '2023-02-01'),
('BK014', 54000.00, 6000.00, 13, 14, '2023-03-15'),
('BK015', 48000.00, 5000.00, 11, 15, '2023-05-01'),
('BK016', 57000.00, 6500.00, 15, 16, '2022-06-15'),
('BK017', 60000.00, 7000.00, 16, 17, '2022-09-01'),
('BK018', 52000.00, 6000.00, 13, 18, '2022-11-20'),
('BK019', 55000.00, 6500.00, 14, 19, '2023-01-15'),
('BK020', 49000.00, 5500.00, 11, 20, '2023-03-01'),
('BK021', 58000.00, 6000.00, 15, 21, '2022-07-01'),
('BK022', 53000.00, 5500.00, 12, 22, '2022-10-10'),
('BK023', 61000.00, 7000.00, 17, 23, '2022-12-20'),
('BK024', 50000.00, 5000.00, 12, 24, '2023-02-15'),
('BK025', 56000.00, 6500.00, 14, 25, '2023-04-01'),
('BK026', 59000.00, 6000.00, 16, 26, '2022-06-01'),
('BK027', 51000.00, 5500.00, 12, 27, '2022-08-15'),
('BK028', 54000.00, 6500.00, 13, 28, '2022-11-01'),
('BK029', 57000.00, 6000.00, 15, 29, '2023-01-20'),
('BK030', 48000.00, 5000.00, 11, 30, '2023-03-10');
select * from booking_details;

INSERT INTO payment_details (payment_id, amount, mode_of_payment, date_of_payment, booking_id, student_id)
VALUES
('P001', 20000.00, 'Online Transfer', '2023-11-15', 'BK001', 1),
('P002', 18000.00, 'Cash', '2023-12-01', 'BK001', 1),
('P003', 19000.00, 'Online Transfer', '2023-11-10', 'BK002', 2),
('P004', 15000.00, 'Cash', '2023-12-15', 'BK002', 2),
('P005', 30000.00, 'Online Transfer', '2023-11-20', 'BK003', 3),
('P006', 20000.00, 'Cash', '2024-01-01', 'BK003', 3),
('P007', 22000.00, 'Online Transfer', '2023-11-25', 'BK004', 4),
('P008', 18000.00, 'Cash', '2024-01-28', 'BK004', 4),
('P009', 35000.00, 'Online Transfer', '2023-11-30', 'BK005', 5),
('P010', 22000.00, 'Cash', '2024-02-15', 'BK005', 5),
('P011', 28000.00, 'Online Transfer', '2023-12-05', 'BK006', 6),
('P012', 19000.00, 'Cash', '2024-02-20', 'BK006', 6),
('P013', 20000.00, 'Online Transfer', '2023-12-10', 'BK007', 7),
('P014', 18000.00, 'Cash', '2024-02-25', 'BK007', 7),
('P015', 32000.00, 'Online Transfer', '2023-12-15', 'BK008', 8),
('P016', 22000.00, 'Cash', '2024-03-01', 'BK008', 8),
('P017', 25000.00, 'Online Transfer', '2023-12-20', 'BK009', 9),
('P018', 20000.00, 'Cash', '2024-03-05', 'BK009', 9),
('P019', 22000.00, 'Online Transfer', '2023-12-25', 'BK010', 10),
('P020', 18000.00, 'Cash', '2024-03-10', 'BK010', 10),
('P021', 35000.00, 'Online Transfer', '2023-12-01', 'BK011', 11),
('P022', 25000.00, 'Cash', '2024-03-15', 'BK011', 11),
('P023', 30000.00, 'Online Transfer', '2023-12-05', 'BK012', 12),
('P024', 20000.00, 'Cash', '2024-03-20', 'BK012', 12),
('P025', 23000.00, 'Online Transfer', '2023-12-10', 'BK013', 13),
('P026', 19000.00, 'Cash', '2024-03-25', 'BK013', 13),
('P027', 28000.00, 'Online Transfer', '2023-12-15', 'BK014', 14),
('P028', 22000.00, 'Cash', '2024-02-21', 'BK014', 14),
('P029', 20000.00, 'Online Transfer', '2023-12-20', 'BK015', 15),
('P030', 18000.00, 'Cash', '2024-01-05', 'BK015', 15);
select * from payment_details;

INSERT INTO visitors (date, check_in_time, check_out_time, visitor_name, student_id)
VALUES
('2024-01-15', '10:00:00', '13:00:00', 'Raj Sharma', 1),
('2024-01-20', '14:30:00', '17:45:00', 'Priya Gupta', 1),
('2024-01-10', '11:15:00', '14:30:00', 'Anil Singh', 1),
('2024-01-22', '09:00:00', '12:15:00', 'Neha Kapoor', 2),
('2024-02-05', '16:00:00', '18:30:00', 'Sanjay Chopra', 3),
('2024-02-18', '13:45:00', '16:15:00', 'Rani Desai', 3),
('2024-01-28', '11:30:00', '14:45:00', 'Amit Mehta', 4),
('2024-02-12', '10:15:00', '13:00:00', 'Supriya Kapoor', 5),
('2024-02-25', '15:00:00', '17:30:00', 'Seema Malhotra', 5),
('2024-01-08', '13:15:00', '16:45:00', 'Divya Jain', 6),
('2024-02-18', '09:30:00', '12:45:00', 'Neha Agarwal', 7),
('2024-02-06', '14:00:00', '17:15:00', 'Anjali Verma', 7),
('2024-01-15', '11:45:00', '15:00:00', 'Priya Yadav', 8),
('2024-02-27', '16:30:00', '19:00:00', 'Geeta Bhati', 9),
('2024-02-13', '10:45:00', '14:15:00', 'Sunita Sinha', 9),
('2024-01-20', '14:15:00', '17:30:00', 'Swati Reddy', 10),
('2024-02-10', '11:00:00', '13:45:00', 'Sanjana Kulkarni', 11),
('2024-02-28', '15:30:00', '18:45:00', 'Shruti Khan', 11),
('2024-01-05', '09:45:00', '12:30:00', 'Gayatri Lal', 12),
('2024-02-22', '13:00:00', '16:15:00', 'Meera Desai', 13),
('2024-02-03', '10:30:00', '13:45:00', 'Kritika Malhotra', 13),
('2024-01-12', '15:45:00', '18:00:00', 'Shikha Jain', 14),
('2024-02-25', '11:15:00', '14:30:00', 'Deepika Chawla', 15),
('2024-02-19', '09:00:00', '12:15:00', 'Nandini Mishra', 15),
('2024-01-27', '14:00:00', '17:30:00', 'Puja Srinivasan', 16),
('2024-02-08', '10:45:00', '13:30:00', 'Amrita Yadav', 17),
('2024-02-22', '16:15:00', '19:00:00', 'Richa Sharma', 17),
('2024-01-10', '13:30:00', '16:45:00', 'Nisha Patel', 18),
('2024-02-15', '09:15:00', '12:00:00', 'Asha Rai', 19),
('2024-02-27', '11:30:00', '15:00:00', 'Anu Sinha', 19);
select * from visitors;

INSERT INTO student_record (date, check_in, check_out, student_id)
VALUES
('2024-01-01', '18:30:00', '09:45:00', 1),
('2024-01-02', '19:00:00', '10:15:00', 1),
('2024-01-03', '18:45:00', '08:30:00', 2),
('2024-01-04', '19:15:00', '10:45:00', 2),
('2024-01-05', '20:00:00', '07:00:00', 3),
('2024-01-06', '21:30:00', '11:00:00', 3),
('2024-01-07', '18:15:00', '08:15:00', 4),
('2024-01-08', '19:45:00', '09:30:00', 4),
('2024-01-09', '18:30:00', '09:45:00', 5),
('2024-01-10', '19:00:00', '10:15:00', 5),
('2024-01-11', '18:45:00', '08:30:00', 6),
('2024-01-12', '19:15:00', '10:45:00', 6),
('2024-01-13', '20:00:00', '07:00:00', 7),
('2024-01-14', '21:30:00', '11:00:00', 7),
('2024-01-15', '18:15:00', '08:15:00', 8),
('2024-01-16', '19:45:00', '09:30:00', 8),
('2024-01-17', '18:30:00', '09:45:00', 9),
('2024-01-18', '19:00:00', '10:15:00', 9),
('2024-01-19', '18:45:00', '08:30:00', 10),
('2024-01-20', '19:15:00', '10:45:00', 10),
('2024-01-21', '20:00:00', '07:00:00', 11),
('2024-01-22', '21:30:00', '11:00:00', 11),
('2024-01-23', '18:15:00', '08:15:00', 12),
('2024-01-24', '19:45:00', '09:30:00', 12),
('2024-01-25', '18:30:00', '09:45:00', 13),
('2024-01-26', '19:00:00', '10:15:00', 13),
('2024-01-27', '18:45:00', '08:30:00', 14),
('2024-01-28', '19:15:00', '10:45:00', 14),
('2024-01-29', '20:00:00', '07:00:00', 15),
('2024-01-30', '21:30:00', '11:00:00', 15),
('2024-02-01', '18:15:00', '08:15:00', 1),
('2024-02-02', '19:45:00', '09:30:00', 1);
select * from student_record;

INSERT INTO laundry (timing, number_of_clothes, student_id, date)
VALUES
('10:00:00', 5, 1, '2024-02-24'),
('11:30:00', 8, 2, '2024-02-24'),
('13:45:00', 3, 3, '2024-02-26'),
('15:20:00', 12, 4, '2024-02-26'),
('16:10:00', 6, 5, '2024-02-28'),
('09:25:00', 9, 6, '2024-02-29'),
('11:50:00', 4, 7, '2024-03-01'),
('14:15:00', 7, 8, '2024-03-02'),
('17:35:00', 10, 9, '2024-03-03'),
('18:00:00', 6, 10, '2024-03-03'),
('10:45:00', 8, 11, '2024-03-05'),
('12:20:00', 5, 12, '2024-03-06'),
('14:00:00', 11, 13, '2024-03-07'),
('16:30:00', 7, 14, '2024-03-08'),
('18:15:00', 3, 15, '2024-03-06'),
('09:10:00', 6, 16, '2024-03-10'),
('11:40:00', 9, 17, '2024-03-09'),
('13:25:00', 4, 11, '2024-03-12'),
('15:50:00', 8, 3, '2024-03-14'),
('17:00:00', 12, 12, '2024-03-16'),
('10:15:00', 7, 2, '2024-03-15'),
('12:45:00', 6, 12, '2024-03-16'),
('14:30:00', 10, 12, '2024-03-17'),
('16:55:00', 5, 14, '2024-03-17'),
('18:20:00', 8, 5, '2024-03-17'),
('09:40:00', 7, 16, '2024-03-17'),
('11:10:00', 6, 7, '2024-03-22'),
('13:35:00', 9, 18, '2024-03-22'),
('15:15:00', 4, 29, '2024-03-23'),
('17:45:00', 11, 30, '2024-03-24');
select * from laundry;
INSERT INTO library (book_type, timing, capacity, student_id, date)
VALUES
('Fiction', '09:00:00', 50, 1, '2024-02-24'),
('Non-Fiction', '10:30:00', 50, 2, '2024-02-24'),
('Reference', '11:45:00', 50, 3, '2024-02-26'),
('Biography', '13:15:00', 50, 4, '2024-02-26'),
('Science', '14:30:00', 50, 5, '2024-02-28'),
('History', '16:00:00', 50, 6, '2024-02-29'),
('Fiction', '17:30:00', 50, 7, '2024-03-02'),
('Non-Fiction', '09:15:00', 50, 8, '2024-03-02'),
('Reference', '10:45:00', 50, 9, '2024-03-04'),
('Biography', '12:30:00', 50, 10, '2024-03-06'),
('Science', '14:00:00', 50, 11, '2024-03-06'),
('History', '15:45:00', 50, 12, '2024-03-08'),
('Fiction', '17:15:00', 50, 13, '2024-03-08'),
('Non-Fiction', '09:45:00', 50, 14, '2024-03-09'),
('Reference', '11:00:00', 50, 15, '2024-03-11'),
('Biography', '13:00:00', 50, 16, '2024-03-11'),
('Science', '14:45:00', 50, 17, '2024-03-12'),
('History', '16:30:00', 50, 18, '2024-03-13'),
('Fiction', '18:00:00', 50, 19, '2024-03-14'),
('Non-Fiction', '09:30:00', 50, 20, '2024-03-15'),
('Reference', '11:15:00', 50, 21, '2024-03-15'),
('Biography', '13:30:00', 50, 22, '2024-03-17'),
('Science', '15:15:00', 50, 23, '2024-03-17'),
('History', '17:00:00', 50, 24, '2024-03-17'),
('Fiction', '18:30:00', 50, 25, '2024-03-17'),
('Non-Fiction', '10:00:00', 50, 26, '2024-03-21'),
('Reference', '12:00:00', 50, 27, '2024-03-21'),
('Biography', '14:15:00', 50, 28, '2024-03-25'),
('Science', '16:15:00', 50, 29, '2024-03-24'),
('History', '18:15:00', 50, 30, '2024-03-23'),
('Fiction', '09:45:00', 50, 1, '2024-03-26');

select * from library;
INSERT INTO gym (timing, equipment, student_id, date)
VALUES
('09:00:00', 'Treadmill', 1, '2024-02-24'),
('10:00:00', 'Weights', 2, '2024-02-25'),
('11:00:00', 'Elliptical', 3, '2024-02-26'),
('12:00:00', 'Exercise Bike', 4, '2024-02-27'),
('13:00:00', 'Rowing Machine', 5, '2024-02-28'),
('14:00:00', 'Yoga Mat', 6, '2024-02-29'),
('15:00:00', 'Kettlebells', 7, '2024-03-01'),
('16:00:00', 'Resistance Bands', 8, '2024-03-02'),
('17:00:00', 'Step Platform', 9, '2024-03-03'),
('18:00:00', 'Stability Ball',10, '2024-03-04'),
('19:00:00', 'Medicine Ball', 11, '2024-03-05'),
('20:00:00', 'Treadmill', 12, '2024-03-06'),
('21:00:00', 'Weights', 13, '2024-03-07'),
('22:00:00', 'Elliptical', 14, '2024-03-08'),
('23:00:00', 'Exercise Bike', 15, '2024-03-09'),
('00:00:00', 'Rowing Machine', 7, '2024-03-10'),
('01:00:00', 'Yoga Mat', 9, '2024-03-11'),
('02:00:00', 'Kettlebells', 11, '2024-03-12'),
('03:00:00', 'Resistance Bands', 13, '2024-03-13'),
('04:00:00', 'Step Platform', 15, '2024-03-14'),
('05:00:00', 'Stability Ball', 2, '2024-03-15'),
('06:00:00', 'Medicine Ball', 4, '2024-03-16'),
('07:00:00', 'Treadmill', 6, '2024-03-17'),
('08:00:00', 'Weights', 8, '2024-03-18'),
('09:00:00', 'Elliptical', 10, '2024-03-19'),
('10:00:00', 'Exercise Bike', 12, '2024-03-20'),
('11:00:00', 'Rowing Machine', 14, '2024-03-21'),
('12:00:00', 'Yoga Mat', 1, '2024-03-22'),
('13:00:00', 'Kettlebells', 3, '2024-03-23'),
('14:00:00', 'Resistance Bands', 5, '2024-03-24'),
('15:00:00', 'Step Platform', 7, '2024-03-25');

select * from gym;
INSERT INTO mess (timing, menu, capacity, student_id, price, date)
VALUES
('08:00:00', 'Breakfast', 50, 1, 50, '2024-02-24'),
('12:00:00', 'Lunch', 100, 2, 80, '2024-02-22'),
('18:00:00', 'Dinner', 75, 3, 70, '2024-02-21'),
('08:30:00', 'Breakfast', 60, 11, 50, '2024-02-22'),
('13:00:00', 'Lunch', 90, 12, 75, '2024-02-24'),
('17:30:00', 'Dinner', 100, 13, 80, '2024-02-26'),
('07:00:00', 'Breakfast', 40, 17, 45, '2024-02-25'),
('12:00:00', 'Lunch', 90, 18, 75, '2024-02-24'), 
('18:30:00', 'Dinner', 85, 16, 75, '2024-02-23'),
('09:00:00', 'Breakfast', 55, 21, 50, '2024-02-26'),
('12:30:00', 'Lunch', 80, 20, 70, '2024-02-20'), 
('17:00:00', 'Dinner', 90, 19, 80, '2024-02-27'), 
('08:30:00', 'Breakfast', 45, 27, 50, '2024-02-28'),
('12:00:00', 'Lunch', 100, 2, 80, '2024-02-22'),
('19:00:00', 'Dinner', 100, 26, 85, '2024-02-21'),
('08:00:00', 'Breakfast', 50, 1, 50, '2024-03-24'),
('12:00:00', 'Lunch', 100, 3, 80, '2024-03-25'), 
('18:00:00', 'Dinner', 75, 3, 70, '2024-03-21');
select * from mess;
INSERT INTO staff_salary (staff_id, date_salary, salary) VALUES
('S0001', '2023-03-01', 5000.50),
('S0002', '2023-04-15', 6200.75),
('S0003', '2023-02-28', 4800.00),
('S0004', '2023-05-20', 7500.25),
('S0005', '2023-01-01', 6000.00),
('S0001', '2023-03-10', 5300.80),
('S0003', '2023-06-30', 5100.00),
('S0006', '2023-07-05', 6800.40),
('S0007', '2023-02-15', 7300.00),
('S0008', '2023-04-25', 4900.70),
('S0002', '2023-09-01', 5200.00),
('S0010', '2023-06-10', 6400.15),
('S0011', '2023-03-20', 5700.90),
('S0012', '2023-08-01', 5500.00),
('S0005', '2023-05-05', 7000.60),
('S0008', '2023-10-15', 6400.00),
('S0009', '2023-11-30', 5300.50),
('S0021', '2023-07-20', 6100.25),
('S0023', '2023-09-10', 7800.00),
('S0024', '2023-04-05', 5000.00),
('S0025', '2024-01-01', 5400.00),
('S0016', '2024-01-15', 6600.80),
('S0017', '2024-01-10', 5900.00),
('S0018', '2024-02-01', 5700.50),
('S0026', '2024-01-05', 7200.75),
('S0027', '2024-01-20', 5100.00),
('S0028', '2024-01-15', 6500.25),
('S0013', '2024-01-01', 7300.00),
('S0029', '2024-01-25', 5800.80),
('S0030', '2024-01-01', 6600.00);
select * from staff_salary;
DELIMITER //

CREATE PROCEDURE InsertNewStudent(
    IN p_student_name TEXT,
    IN p_age INT,
    IN p_date_of_birth DATE,
    IN p_college TEXT,
    IN p_address TEXT,
    IN p_father_name TEXT,
    IN p_father_contact_number TEXT,
    IN p_father_posting TEXT,
    IN p_mother_name TEXT,
    IN p_mother_contact_number TEXT
)
BEGIN
    DECLARE student_id INT;

    -- Insert new student details
    INSERT INTO student (student_name, age, date_of_birth, college, address)
    VALUES (p_student_name, p_age, p_date_of_birth, p_college, p_address);
    
    -- Get the auto-generated student_id
    SET student_id = LAST_INSERT_ID();
    
    -- Insert dependent details
    INSERT INTO student_dependents (father_name, father_contact_number, father_posting, mother_name, mother_contact_number, student_id)
    VALUES (p_father_name, p_father_contact_number, p_father_posting, p_mother_name, p_mother_contact_number, student_id);
    
END//

DELIMITER ;
CALL InsertNewStudent('John Doe', 20, '2004-05-10', 'XYZ University', '123 Main St', 'John Doe Sr.', '1234567890', 'Manager', 'Jane Doe', '9876543210');
select * from student natural join student_dependents;

DELIMITER //

CREATE PROCEDURE InsertHostelStaff (
    IN p_staff_id VARCHAR(5),
    IN p_fname TEXT,
    IN p_lname TEXT,
    IN p_contact_details TEXT,
    IN p_address TEXT,
    IN p_role TEXT,
    IN p_joining_date DATE,
    IN p_gender TEXT
)
BEGIN
    INSERT INTO hostel_staff (staff_id, fname, lname, contact_details, address, role, joining_date, gender)
    VALUES (p_staff_id, p_fname, p_lname, p_contact_details, p_address, p_role, p_joining_date, p_gender);
END//

DELIMITER ;
CALL InsertHostelStaff('S0031', 'John', 'Doe', '123-456-7890', '456 Main St', 'Warden', '2024-03-31', 'm');
select * from hostel_staff;

DELIMITER //

CREATE PROCEDURE AllocateRoomForStudent (
    IN p_student_id INT,
    IN p_allocation_date DATE,
    IN p_capacity INT,
    IN p_room_no VARCHAR(10),
    IN p_staff_id VARCHAR(5)
)
BEGIN
    INSERT INTO room_allocation (allocation_date, capacity, room_no, staff_id, student_id)
    VALUES (p_allocation_date, p_capacity, p_room_no, p_staff_id, p_student_id);
END//

DELIMITER ;
CALL AllocateRoomForStudent(LAST_INSERT_ID(), '2024-04-01', 4, '101', 'S0031');
select * from room_allocation;

DELIMITER //
CREATE TRIGGER update_complaint_status
AFTER UPDATE ON complaints
FOR EACH ROW
BEGIN
    IF NEW.status = 'resolved' THEN
        UPDATE complaints
        SET complaint_date = NOW()
        WHERE complaint_id = NEW.complaint_id;
    END IF;
END;
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_room_allocation_capacity_on_deallocation
AFTER DELETE ON room_allocation
FOR EACH ROW
BEGIN
    UPDATE room_allocation
    SET capacity = capacity + 1
    WHERE allocation_id = OLD.allocation_id;
END;
DELIMITER ;