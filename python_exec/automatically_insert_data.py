import pyodbc
from datetime import datetime, timedelta
import random, time
from connect import get_cursor 

# Kiểm tra xem đã có 1000 bản ghi hay chưa
cursor, conn = get_cursor()
def insert_1000_records():
    cursor.execute('SELECT COUNT(*) FROM Quotes')
    row = cursor.fetchone()
    count = row[0]
    if count >= 1000:
        print('There were 1000 records')
        return
    
start_date = datetime(2022,1,1)
end_date = datetime(2024,12,31)
delta = end_date - start_date

# Thực hiện tạo 1000 bản ghi giả lập
for i in range(1000):
    stock_id = random.randint(1, 20)
    price = round(random.uniform(1,100), 2)
    change = round(random.uniform(-15, 15), 2)
    percent_change = round(change/price*100, 2)
    volume = random.randint(1000, 1000000)

    day = random.randint(1, delta.days)
    second = random.randint(0, 24*60*60)
    micro_second = random.randint(0, 1000000)
    time_stamp = start_date + timedelta(days=day, seconds=second, microseconds=micro_second)

    cursor.execute("""INSERT INTO Quotes (stock_id, price , change , percent_change , volume , time_stamp)
                   VALUES (?, ?, ?, ?, ?, ?)""", stock_id, price, change, percent_change, volume, time_stamp)
    if (i + 1) % 100 == 0: 
            conn.commit()

# Thực hiện thêm bản ghi giả lập sau mỗi 5s    
def insert_random_quotes():
    while True:
        stock_id = random.randint(1, 20)
        price = round(random.uniform(1,100), 2)
        change = round(random.uniform(-50, 50), 2)
        percent_change = round(random.uniform(-15, 15), 2)
        volume = random.randint(1000, 1000000)
        time_stamp = datetime.now()

        cursor.execute("""INSERT INTO Quotes (stock_id, price , change , percent_change , volume , time_stamp)
                   VALUES (?, ?, ?, ?, ?, ?)""", stock_id, price, change, percent_change, volume, time_stamp)
        conn.commit()
        time.sleep(5)

insert_1000_records()
insert_random_quotes()
cursor.close()
conn.close()
