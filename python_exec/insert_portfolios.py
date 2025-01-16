import random
from faker import Faker
from connect import get_cursor 
from datetime import datetime

fake = Faker()
user_ids = [i for i in range(1,11)]
stock_ids = [i for i in range(1,21)]

cursor, conn = get_cursor()

for i in range(200):
    user_id = random.choice(user_ids)
    stock_id = random.choice(stock_ids)
    quantity = random.randint(1,1000)
    purchase_price = round(random.uniform(1, 100),4)
    purchase_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    cursor.execute("""
    INSERT INTO Portfolios (user_id, stock_id, quantity, purchase_price, purchase_date)
    VALUES (?, ?, ?, ?, ?)
    """, (user_id, stock_id, quantity, purchase_price, purchase_date))

# Commit các thay đổi vào cơ sở dữ liệu
conn.commit()

# Đóng kết nối sau khi xong
conn.close()