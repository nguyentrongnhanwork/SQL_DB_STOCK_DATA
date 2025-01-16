import random
from faker import Faker
from connect import get_cursor 
from datetime import datetime

fake = Faker()
user_ids = [i for i in range(1,11)]
stock_ids = [i for i in range(1,21)]

cursor, conn = get_cursor()
order_id = 0 
for i in range(500):
    user_id = random.choice(user_ids)
    stock_id = random.choice(stock_ids)
    order_type = random.choice(['Market', 'Limit', 'Stop'])
    action = random.choice(['Buy', 'Sell'])
    quantity = round(random.uniform(1, 1000),2)
    price = round(random.uniform(1, 100),2)
    status = random.choice(['Executed', 'Pending', 'Canceled'])
    order_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    cursor.execute("""
    INSERT INTO Orders (user_id, stock_id, order_type, action, quantity, price, status, order_time)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """, (user_id, stock_id, order_type, action, quantity, price, status, order_time))

# Commit các thay đổi vào cơ sở dữ liệu
conn.commit()

# Đóng kết nối sau khi xong
conn.close()