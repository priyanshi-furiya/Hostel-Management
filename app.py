from datetime import datetime
import MySQLdb
import MySQLdb.cursors
from flask import Flask, render_template, json, request
import os
from langchain_google_genai import ChatGoogleGenerativeAI

app = Flask(__name__)

database = MySQLdb.connect(
    host="localhost",
    user="root",
    passwd="",
    db="management",
    cursorclass=MySQLdb.cursors.DictCursor,
)
cursor = database.cursor()


os.environ["GOOGLE_API_KEY"] = ""


@app.route("/")
def main():
    cursor.execute(
        "SELECT status, COUNT(complaint_id) AS count FROM complaints GROUP BY status;"
    )
    data = cursor.fetchall()
    formatted_data = [{"name": row["status"], "y": row["count"]}
                      for row in data]
    print(formatted_data)
    formatted_data1 = [[row["name"], row["y"]] for row in formatted_data]
    print(formatted_data1)
    chart2 = {
        "chart": {
            "type": "bar",
            "data": formatted_data1,
            "container": "container2",
        }
    }
    cursor.execute("select count(student_id)/48 as count from student;")
    data = cursor.fetchall()
    print(data)
    occupied_data = [
        {"name": "Occupied", "value": data[0]["count"]},
        {"name": "Vacancy", "value": 1 - data[0]["count"]},
    ]
    chart1 = {
        "chart": {
            "type": "pie",
            "data": occupied_data,
            "container": "container1",
        }
    }
    cursor.execute("SELECT sum(total_fees) from booking_details;")
    data = cursor.fetchall()
    data = data[0]["sum(total_fees)"]

    cursor.execute("SELECT sum(amount) from payment_details;")
    data1 = cursor.fetchall()
    data1 = data1[0]["sum(amount)"]

    data2 = data - data1

    occupied_datas = [
        {"name": "Collected", "value": data1},
        {"name": "Remaining", "value": data2},
    ]
    chart3 = {
        "chart3": {
            "type": "pie",
            "data": occupied_datas,
            "container": "container3",
        }
    }
    return render_template(
        "dashboard.html",
        title="Anychart Python template",
        chartData1=json.dumps(chart1),
        chartData2=json.dumps(chart2),
        formatted_data=json.dumps(formatted_data1),
        occupied_data=json.dumps(occupied_data),
        occupied_datas=json.dumps(occupied_datas),
        data=data,
        data1=data1,
        data2=data2,
        chart3=json.dumps(chart3),
    )


def generate_prompt():
    prompt = ""
    tables = [
        (
            "hostel_staff",
            "staff_id, fname, lname, contact_details, address, role, joining_date, gender",
        ),
        (
            "room_allocation",
            "allocation_id, allocation_date, capacity, room_no, staff_id",
        ),
        (
            "student",
            "student_id, student_name, age, date_of_birth, college, address, allocation_id",
        ),
        (
            "complaints",
            "complaint_id, status, description, complaint_date, staff_id, student_id",
        ),
        (
            "utility_consumption",
            "electricity_consumed, electricity_price, wifi_no, wifi_price, staff_id, student_id, allocation_id, months",
        ),
        (
            "student_dependents",
            "dependent_id, father_name, father_contact_number, father_posting, mother_name, mother_contact_number, student_id",
        ),
        (
            "booking_details",
            "booking_id, total_fees, security_deposit, tenure, student_id",
        ),
        (
            "payment_details",
            "payment_id, amount, mode_of_payment, date_of_payment, booking_id, student_id",
        ),
        (
            "visitors",
            "visitor_id, date, check_in_time, check_out_time, visitor_name, student_id",
        ),
        ("student_record", "date, check_in, check_out, student_id"),
        ("laundry", "laundry_id, timing, number_of_clothes, price, student_id, date"),
        ("library", "library_id, book_type, timing, capacity, student_id, date"),
        ("gym", "gym_id, timing, equipment, student_id, date"),
        ("mess", "mess_no, timing, menu, capacity, student_id, price, date"),
        ("staff_salary", "staff_id, date_salary, salary"),
    ]

    for table, attributes in tables:
        prompt += f"Table: {table}, Attributes: {attributes}\n"

    return prompt


print(generate_prompt())


def simplify_sql_query(query):
    query = query.strip()
    if query.startswith("```sql"):
        query = query[6:]
    if query.endswith("```"):
        query = query[:-3]
    query = query.strip()

    return query


@app.route("/execute_query", methods=["POST"])
def execute_query():
    question = request.get_json()
    question = question["query"]
    data = generate_prompt()
    hardcoded_prompt = "Query should be based on the given schema only and return only the SQL query, dont give any text as output"
    input_text = (
        hardcoded_prompt + "\nContext:" + data + "\nUser question:\n" + question
    )
    llm = ChatGoogleGenerativeAI(model="gemini-pro")
    result = llm.invoke(input_text)
    query = result.content
    query = simplify_sql_query(query)
    query = query.replace("`", " ")
    print(query)
    try:
        cursor.execute(query)
        result = cursor.fetchall()
    except:
        return "Query failed"
    print(result)
    parsed_result = ""
    if len(result) == 0:
        return "No data found"
    else:
        for i in result:
            if i is not None:
                parsed_result = parsed_result + str(i) + "\n"
            elif parsed_result == "":
                parsed_result = " "
            else:
                return "No data found"
    print(parsed_result)
    return parsed_result


@app.route("/dashboard.student", methods=["GET", "POST"])
def student():
    if request.method == "POST":
        cursor.execute("select count(student_id) from student;")
        data = cursor.fetchall()
        data = data[0]["count(student_id)"]

        cursor.execute(
            "select count(student_id) from student where student_id not in (select student_id from booking_details natural join payment_details);"
        )
        data1 = cursor.fetchall()
        data1 = data1[0]["count(student_id)"]
        return render_template("dashboard_student.html", data=data, data1=data1)

    elif request.method == "GET":
        date = request.args.get("date")
        name = request.args.get("Name")
        if date:
            cursor.execute("select count(student_id) from student;")
            data = cursor.fetchall()
            data = data[0]["count(student_id)"]

            cursor.execute(
                "select count(student_id) from student where student_id not in (select student_id from booking_details natural join payment_details);"
            )
            data1 = cursor.fetchall()
            data1 = data1[0]["count(student_id)"]
            query = f"select visitor_id,visitor_name,student_name,room_no,check_in_time,check_out_time from visitors natural join student natural join room_allocation where date = '{date}';"
            cursor.execute(query)
            data3 = cursor.fetchall()
            data3 = [
                (
                    d["visitor_id"],
                    d["visitor_name"],
                    d["student_name"],
                    d["room_no"],
                    d["check_in_time"],
                    d["check_out_time"],
                )
                for d in data3
            ]
            print(data3)
            return render_template(
                "dashboard_student.html", data=data, data1=data1, data3=data3
            )
        elif name:
            query = f"select * from student natural join student_dependents where student_name like '{name}%';"
            cursor.execute(query)
            data2 = cursor.fetchall()
            data2 = [
                (
                    d["student_name"],
                    d["father_name"],
                    d["father_contact_number"],
                    d["mother_name"],
                    d["mother_contact_number"],
                )
                for d in data2
            ]
            print(data2)
            return render_template("dashboard_student.html", data2=data2)
        else:

            cursor.execute("select count(student_id) from student;")
            data = cursor.fetchall()
            data = data[0]["count(student_id)"]

            cursor.execute(
                "select count(student_id) from student where student_id not in (select student_id from booking_details natural join payment_details);"
            )
            data1 = cursor.fetchall()
            data1 = data1[0]["count(student_id)"]

            date = request.args.get("date")
            name = request.args.get("Name")
            cursor.execute(
                "select visitor_id,visitor_name,student_name,room_no,check_in_time,check_out_time from visitors natural join student natural join room_allocation order by date desc limit 5;"
            )
            data3 = cursor.fetchall()
            data3 = [
                (
                    d["visitor_id"],
                    d["visitor_name"],
                    d["student_name"],
                    d["room_no"],
                    d["check_in_time"],
                    d["check_out_time"],
                )
                for d in data3
            ]
            return render_template(
                "dashboard_student.html", data=data, data1=data1, data3=data3
            )
    else:
        cursor.execute("select count(student_id) from student;")
        data = cursor.fetchall()
        data = data[0]["count(student_id)"]

        cursor.execute(
            "select count(student_id) from student where student_id not in (select student_id from booking_details natural join payment_details);"
        )
        data1 = cursor.fetchall()
        data1 = data1[0]["count(student_id)"]
        cursor.execute(
            "select * from student natural join booking_details natural join payment_details order by date_of_payment limit 4;"
        )
        data2 = cursor.fetchall()
        data2 = [
            (
                d["student_id"],
                d["student_name"],
                d["total_fees"],
                d["amount"],
                d["date_of_payment"],
            )
            for d in data2
        ]

    return render_template(
        "dashboard_student.html", data=data, data1=data1, data2=data2
    )


@app.route("/complaints")
def complaints():
    cursor.execute(
        "SELECT status, COUNT(complaint_id) AS count FROM complaints GROUP BY status;"
    )
    data = cursor.fetchall()
    formatted_data = [{"name": row["status"], "y": row["count"]}
                      for row in data]
    print(formatted_data)
    formatted_data1 = [[row["name"], row["y"]] for row in formatted_data]
    print(formatted_data1)
    chart2 = {
        "chart": {
            "type": "bar",
            "data": formatted_data1,
            "container": "container2",
        }
    }

    cursor.execute(
        "select complaint_id,student_name,complaint_date,description from complaints natural join student where status = 'Open' order by complaint_date desc;"
    )
    data4 = cursor.fetchall()
    data4 = [
        (d["complaint_id"], d["student_name"],
         d["complaint_date"], d["description"])
        for d in data4
    ]

    cursor.execute(
        "select complaint_id,student_name,complaint_date,description from complaints natural join student where status = 'Closed'order by complaint_date desc;"
    )
    data3 = cursor.fetchall()
    data3 = [
        (d["complaint_id"], d["student_name"],
         d["complaint_date"], d["description"])
        for d in data3
    ]

    return render_template(
        "complaints.html",
        formatted_data=json.dumps(formatted_data1),
        chartData2=json.dumps(chart2),
        data4=data4,
        data3=data3,
    )


@app.route("/rooms", methods=["GET", "POST"])
def rooms():
    if request.method == "GET":
        room = request.args.get("room")
        if room:
            query = f"select student_id,student_name,room_no,date_of_birth,allocation_date from student natural join room_allocation where room_no = {room};"
            data = cursor.execute(query)
            data = cursor.fetchall()
            data = [
                (
                    d["student_id"],
                    d["student_name"],
                    d["room_no"],
                    d["date_of_birth"],
                    d["allocation_date"],
                )
                for d in data
            ]

            query1 = f"select count(student_id) from student natural join room_allocation where room_no = {room};"
            cursor.execute(query1)
            data1 = cursor.fetchall()
            data1 = data1[0]["count(student_id)"]

            query2 = f"select capacity from student natural join room_allocation where room_no = {room};"
            cursor.execute(query2)
            data2 = cursor.fetchall()
            data2 = data2[0]["capacity"]

            occupied_datas = [
                {"name": "Occupied", "value": data1},
                {"name": "Vacancy", "value": data2 - data1},
            ]
            chart3 = {
                "chart3": {
                    "type": "pie",
                    "data": occupied_datas,
                    "container": "container3",
                }
            }
            return render_template(
                "rooms.html",
                data=data,
                chart3=json.dumps(chart3),
                occupied_datas=json.dumps(occupied_datas),
            )
        else:
            query = "select student_id,student_name,room_no,date_of_birth,allocation_date from student natural join room_allocation;"
            cursor.execute(query)
            data = cursor.fetchall()
            data = [
                (
                    d["student_id"],
                    d["student_name"],
                    d["room_no"],
                    d["date_of_birth"],
                    d["allocation_date"],
                )
                for d in data
            ]
            return render_template("rooms.html")
    elif request.method == "POST":
        room = request.form["room"]
        query = f"select student_id,student_name,room_no,date_of_birth,allocation_date from student natural join room_allocation where room_no = {room};"
        cursor.execute(query)
        data = cursor.fetchall()
        data = [
            (
                d["student_id"],
                d["student_name"],
                d["room_no"],
                d["date_of_birth"],
                d["allocation_date"],
            )
            for d in data
        ]
        return render_template("rooms.html", data=data)


@app.route("/allocation", methods=["GET", "POST"])
def allocation():
    cursor.execute(
        "select room_no,count(*) from student natural join room_allocation group by room_no order by room_no;"
    )
    data = cursor.fetchall()
    formatted_data = [{"name": row["room_no"],
                       "y": row["count(*)"]} for row in data]
    print(formatted_data)
    formatted_data1 = [[row["name"], row["y"]] for row in formatted_data]
    print(formatted_data1)
    chart2 = {
        "chart": {
            "type": "bar",
            "data": formatted_data1,
            "container": "container2",
        }
    }

    return render_template(
        "allocation.html",
        formatted_data=json.dumps(formatted_data1),
        chartData2=json.dumps(chart2),
    )


@app.route("/attendance", methods=["GET", "POST"])
def attendance():
    date = datetime.now().date()
    query = f"SELECT student_name, check_in, check_out, room_no FROM student NATURAL JOIN student_record NATURAL JOIN room_allocation WHERE DATE = '{date}';"
    cursor.execute(query)
    data = cursor.fetchall()
    changed_data = [
        (d["student_name"], d["check_in"], d["check_out"], d["room_no"]) for d in data
    ]
    print(changed_data)
    return render_template("attendance.html", data=changed_data)


@app.route("/attendance.in", methods=["GET", "POST"])
def attendance_in():
    if request.method == "GET":
        date = request.args.get("date")
        time = request.args.get("time")

        if date and time:
            cursor.execute(
                "SELECT student_name, check_in, room_no FROM student NATURAL JOIN student_record NATURAL JOIN room_allocation WHERE DATE = %s AND TIME(check_in) <= %s ;",
                (date, time),
            )
        else:
            cursor.execute(
                "SELECT student_name, check_in, room_no FROM student NATURAL JOIN student_record NATURAL JOIN room_allocation order by date desc;"
            )

        data = cursor.fetchall()
        changed_data = [(d["student_name"], d["check_in"], d["room_no"])
                        for d in data]
        print(changed_data)
        return render_template("attendance_in.html", data=changed_data)


@app.route("/attendance.out")
def attendance_out():
    if request.method == "GET":
        date = request.args.get("date")
        time = request.args.get("time")

        if date and time:
            cursor.execute(
                "SELECT student_name, check_out, room_no FROM student NATURAL JOIN student_record NATURAL JOIN room_allocation WHERE DATE = %s AND TIME(check_in) <= %s ;",
                (date, time),
            )
        else:
            cursor.execute(
                "SELECT student_name, check_out, room_no FROM student NATURAL JOIN student_record NATURAL JOIN room_allocation order by date desc ;"
            )

        data = cursor.fetchall()
        changed_data = [(d["student_name"], d["check_out"],
                         d["room_no"]) for d in data]
        print(changed_data)
    return render_template("attendance_out.html", data=changed_data)


@app.route("/accounts")
def accounts():
    cursor.execute("SELECT sum(total_fees) from booking_details;")
    data = cursor.fetchall()
    data = data[0]["sum(total_fees)"]

    cursor.execute("SELECT sum(amount) from payment_details;")
    data1 = cursor.fetchall()
    data1 = data1[0]["sum(amount)"]

    cursor.execute("SELECT sum(amount) from payment_details;")
    data1 = cursor.fetchall()
    data1 = data1[0]["sum(amount)"]

    data2 = data - data1

    occupied_data = [
        {"name": "Collected", "value": data1},
        {"name": "Remaining", "value": data2},
    ]
    chart1 = {
        "chart": {
            "type": "pie",
            "data": occupied_data,
            "container": "container1",
        }
    }

    cursor.execute(
        "select student_name , date_of_payment from payment_details natural join student order by date_of_payment limit 5;"
    )
    data3 = cursor.fetchall()
    data3 = [(d["student_name"], d["date_of_payment"]) for d in data3]

    cursor.execute(
        "select fname,lname , date_salary from hostel_staff natural join staff_salary order by date_salary limit 5;;"
    )
    data4 = cursor.fetchall()
    data4 = [(d["fname"], d["lname"], d["date_salary"]) for d in data4]

    return render_template(
        "accounts.html",
        data=data,
        data1=data1,
        data2=data2,
        chartData1=json.dumps(chart1),
        occupied_data=json.dumps(occupied_data),
        data3=data3,
        data4=data4,
    )


@app.route("/accounts.credits")
def accounts_credit():
    cursor.execute("SELECT sum(total_fees) from booking_details;")
    data = cursor.fetchall()
    data = data[0]["sum(total_fees)"]

    cursor.execute("SELECT sum(amount) from payment_details;")
    data1 = cursor.fetchall()
    data1 = data1[0]["sum(amount)"]

    cursor.execute("SELECT sum(amount) from payment_details;")
    data1 = cursor.fetchall()
    data1 = data1[0]["sum(amount)"]

    data2 = data - data1

    occupied_data = [
        {"name": "Collected", "value": data1},
        {"name": "Remaining", "value": data2},
    ]
    chart1 = {
        "chart": {
            "type": "pie",
            "data": occupied_data,
            "container": "container1",
        }
    }
    cursor.execute(
        "select * from payment_details natural join student order by date_of_payment desc limit 5;"
    )
    data3 = cursor.fetchall()
    data3 = [
        (
            d["payment_id"],
            d["mode_of_payment"],
            d["date_of_payment"],
            d["student_name"],
            d["amount"],
        )
        for d in data3
    ]
    return render_template(
        "accounts_credits.html",
        data=data,
        data1=data1,
        data2=data2,
        chartData1=json.dumps(chart1),
        occupied_data=json.dumps(occupied_data),
        data3=data3,
    )


@app.route("/accounts.debit")
def accounts_debit():
    cursor.execute("SELECT sum(total_fees) from booking_details;")
    data = cursor.fetchall()
    data = data[0]["sum(total_fees)"]

    cursor.execute("SELECT sum(amount) from payment_details;")
    data1 = cursor.fetchall()
    data1 = data1[0]["sum(amount)"]

    cursor.execute("SELECT sum(amount) from payment_details;")
    data1 = cursor.fetchall()
    data1 = data1[0]["sum(amount)"]

    data2 = data - data1

    occupied_data = [
        {"name": "Collected", "value": data1},
        {"name": "Remaining", "value": data2},
    ]
    chart1 = {
        "chart": {
            "type": "pie",
            "data": occupied_data,
            "container": "container1",
        }
    }
    cursor.execute(
        "select * from hostel_staff natural join staff_salary order by date_salary desc limit 5;"
    )
    data4 = cursor.fetchall()
    data4 = [
        (
            d["fname"],
            d["lname"],
            d["role"],
            d["salary"],
            d["date_salary"],
        )
        for d in data4
    ]
    return render_template(
        "accounts_debit.html",
        data=data,
        data1=data1,
        data2=data2,
        chartData1=json.dumps(chart1),
        occupied_data=json.dumps(occupied_data),
        data4=data4,
    )


@app.route("/credits")
def credits():
    cursor.execute(
        "select student_id,payment_id,mode_of_payment,date_of_payment,student_name,room_no,amount from payment_details natural join student natural join room_allocation order by date_of_payment desc;"
    )
    data4 = cursor.fetchall()
    data4 = [
        (
            d["student_id"],
            d["payment_id"],
            d["mode_of_payment"],
            d["date_of_payment"],
            d["student_name"],
            d["room_no"],
            d["amount"],
        )
        for d in data4
    ]
    return render_template("credits_expand.html", data4=data4)


@app.route("/debit")
def debit():
    cursor.execute(
        "select staff_id,fname,lname,role,salary,date_salary from hostel_staff natural join staff_salary order by date_salary desc;"
    )
    data4 = cursor.fetchall()
    data4 = [
        (
            d["staff_id"],
            d["fname"],
            d["lname"],
            d["role"],
            d["salary"],
            d["date_salary"],
        )
        for d in data4
    ]
    return render_template("debit_expand.html", data4=data4)


@app.route("/amenities", methods=["GET", "POST"])
def mess():
    if request.method == "GET":
        date1 = request.args.get("date1")
        date2 = request.args.get("date2")
        month = request.args.get("month")
        if date1 and date2:
            query = "select menu, sum(price) from mess group by menu;"
            cursor.execute(query)
            data = cursor.fetchall()
            data = [(d["menu"], d["sum(price)"]) for d in data]
            query1 = f"select sum(price) from mess where date > '{date1}'and date < '{date2}';"
            cursor.execute(query1)
            data1 = cursor.fetchall()
            print(data1)
            data1 = data1[0]["sum(price)"]
            query2 = f"select menu, sum(price) from mess where date > '{date1}'and date < '{date2}' group by menu;"
            cursor.execute(query2)
            data2 = cursor.fetchall()
            print(data2)
            data2 = [(d["menu"], d["sum(price)"]) for d in data2]
            return render_template(
                "amenities.html", data=data, data1=data1, data2=data2
            )
        elif month:
            query = "select menu, sum(price) from mess group by menu;"
            cursor.execute(query)
            data3 = cursor.fetchall()
            data3 = [(d["menu"], d["sum(price)"]) for d in data3]
            query1 = f"select sum(price) from mess where month(date) = '{month}';"
            cursor.execute(query1)
            data4 = cursor.fetchall()
            try:
                data4 = data4[0]["sum(price)"]
            except:
                data4 = 0
            print(data4)
            query2 = f"select menu, sum(price) from mess where month(date) = '{month}' group by menu;"
            cursor.execute(query2)
            data5 = cursor.fetchall()
            print(data5)
            data5 = [(d["menu"], d["sum(price)"]) for d in data5]
            formatted_list = [(category, float(cost))
                              for category, cost in data5]
            return render_template(
                "amenities.html", data3=data3, data4=data4, data5=data5
            )
        else:
            query = "select menu, sum(price) from mess group by menu;"
            cursor.execute(query)
            data = cursor.fetchall()
            data = [(d["menu"], d["sum(price)"]) for d in data]
            cursor.execute("select sum(price) from mess;")
            data1 = cursor.fetchall()
            data1 = data1[0]["sum(price)"]
            cursor.execute("select menu, sum(price) from mess group by menu;")
            data2 = cursor.fetchall()
            data2 = [(d["menu"], d["sum(price)"]) for d in data2]
            return render_template(
                "amenities.html", data=data, data1=data1, data2=data2
            )
    else:
        query = "select menu, sum(price) from mess group by menu;"
        cursor.execute(query)
        data = cursor.fetchall()
        data = [(d["menu"], d["sum(price)"]) for d in data]

    return render_template("amenities.html", data=data)


@app.route("/amenities.laundry")
def laundry():
    if request.method == "GET":
        date1 = request.args.get("date1")
        date2 = request.args.get("date2")
        month = request.args.get("month")
        if date1 and date2:
            query1 = f"select sum(number_of_clothes) from laundry where date > '{date1}'and date < '{date2}';"
            cursor.execute(query1)
            data1 = cursor.fetchall()
            print(data1)
            data1 = data1[0]["sum(number_of_clothes)"]
            query2 = f"select student_id, sum(number_of_clothes) from laundry where date > '{date1}'and date < '{date2}' group by student_id;"
            cursor.execute(query2)
            data2 = cursor.fetchall()
            print(data2)
            data2 = [(d["student_id"], d["sum(number_of_clothes)"])
                     for d in data2]
            return render_template("amenities_laundry.html", data1=data1, data2=data2)
        elif month:
            query1 = f"select sum(number_of_clothes) from laundry where month(date) = '{month}';"
            cursor.execute(query1)
            data4 = cursor.fetchall()
            try:
                data4 = data4[0]["sum(number_of_clothes)"]
            except:
                data4 = 0
            print(data4)
            query2 = f"select student_id, sum(number_of_clothes) from laundry where month(date) = '{month}' group by student_id;"
            cursor.execute(query2)
            data5 = cursor.fetchall()
            print(data5)
            data5 = [(d["student_id"], d["sum(number_of_clothes)"])
                     for d in data5]
            return render_template("amenities_laundry.html", data4=data4, data5=data5)
        else:
            cursor.execute("select sum(number_of_clothes) from laundry;")
            data1 = cursor.fetchall()
            data1 = data1[0]["sum(number_of_clothes)"]
            cursor.execute(
                "select student_id, sum(number_of_clothes) from laundry group by student_id;"
            )
            data2 = cursor.fetchall()
            data2 = [(d["student_id"], d["sum(number_of_clothes)"])
                     for d in data2]
            return render_template("amenities_laundry.html", data1=data1, data2=data2)


@app.route("/amenities.gym", methods=["GET", "POST"])
def gym():
    if request.method == "GET":
        date = request.args.get("date")
        if date:
            query = f"select student_name, college, equipment, timing from gym natural join student where date = '{date}';"
            cursor.execute(query)
            data = cursor.fetchall()
            data = [
                (d["student_name"], d["college"], d["equipment"], d["timing"])
                for d in data
            ]

            query2 = f"select equipment,count(equipment) as count from gym where date = '{date}' group by equipment ;"
            cursor.execute(query2)
            data1 = cursor.fetchall()
            formatted_data = [
                {"name": row["equipment"], "y": row["count"]} for row in data1
            ]
            print(formatted_data)
            formatted_data1 = [[row["name"], row["y"]]
                               for row in formatted_data]
            print(formatted_data1)
            chart2 = {
                "chart": {
                    "type": "bar",
                    "data": formatted_data1,
                    "container": "container2",
                }
            }

            return render_template(
                "amenities_gym.html",
                data=data,
                formatted_data=json.dumps(formatted_data1),
                chartData2=json.dumps(chart2),
            )
        else:
            cursor.execute(
                "select student_name, college,equipment, timing from gym natural join student order by date desc;"
            )
            data = cursor.fetchall()
            data = [
                (d["student_name"], d["college"], d["equipment"], d["timing"])
                for d in data
            ]

            cursor.execute(
                "select equipment,count(equipment) as count from gym group by equipment;"
            )
            data1 = cursor.fetchall()
            formatted_data = [
                {"name": row["equipment"], "y": row["count"]} for row in data1
            ]
            print(formatted_data)
            formatted_data1 = [[row["name"], row["y"]]
                               for row in formatted_data]
            print(formatted_data1)
            chart2 = {
                "chart": {
                    "type": "bar",
                    "data": formatted_data1,
                    "container": "container2",
                }
            }
            return render_template(
                "amenities_gym.html",
                data=data,
                formatted_data=json.dumps(formatted_data1),
                chartData2=json.dumps(chart2),
            )
    elif request.method == "POST":
        return render_template("amenities_gym.html")

    else:
        cursor.execute(
            "select student_name, college, equipment, timing from gym natural join student order by date desc;"
        )
        data = cursor.fetchall()
        data = [
            (d["student_name"], d["college"], d["equipment"], d["timing"]) for d in data
        ]
        return render_template("amenities_gym.html", data=data)


@app.route("/amenities.library", methods=["GET", "POST"])
def library():
    if request.method == "GET":
        date = request.args.get("date")
        if date:
            query = f"select student_name, college, book_type, timing from library natural join student where date = '{date}';"
            cursor.execute(query)
            data = cursor.fetchall()
            data = [
                (d["student_name"], d["college"], d["book_type"], d["timing"])
                for d in data
            ]

            query2 = f"select book_type,count(book_type) as count from library where date = '{date}' group by book_type ;"
            cursor.execute(query2)
            data1 = cursor.fetchall()
            formatted_data = [
                {"name": row["book_type"], "y": row["count"]} for row in data1
            ]
            print(formatted_data)
            formatted_data1 = [[row["name"], row["y"]]
                               for row in formatted_data]
            print(formatted_data1)
            chart2 = {
                "chart": {
                    "type": "bar",
                    "data": formatted_data1,
                    "container": "container2",
                }
            }

            return render_template(
                "library.html",
                data=data,
                formatted_data=json.dumps(formatted_data1),
                chartData2=json.dumps(chart2),
            )
        else:
            cursor.execute(
                "select student_name, college, book_type, timing from library natural join student order by date desc;"
            )
            data = cursor.fetchall()
            data = [
                (d["student_name"], d["college"], d["book_type"], d["timing"])
                for d in data
            ]

            cursor.execute(
                "select book_type,count(book_type) as count from library group by book_type;"
            )
            data1 = cursor.fetchall()
            formatted_data = [
                {"name": row["book_type"], "y": row["count"]} for row in data1
            ]
            print(formatted_data)
            formatted_data1 = [[row["name"], row["y"]]
                               for row in formatted_data]
            print(formatted_data1)
            chart2 = {
                "chart": {
                    "type": "bar",
                    "data": formatted_data1,
                    "container": "container2",
                }
            }
            return render_template(
                "library.html",
                data=data,
                formatted_data=json.dumps(formatted_data1),
                chartData2=json.dumps(chart2),
            )
    elif request.method == "POST":
        return render_template("library.html")

    else:
        cursor.execute(
            "select student_name, college, book_type, timing from library natural join student order by date desc;"
        )
        data = cursor.fetchall()
        data = [
            (d["student_name"], d["college"], d["book_type"], d["timing"]) for d in data
        ]
        return render_template("library.html", data=data)


if __name__ == "__main__":
    app.run(debug=True)
