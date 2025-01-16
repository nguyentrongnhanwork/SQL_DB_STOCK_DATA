import random
from faker import Faker
from connect import get_cursor 

fake = Faker()
etf_ids = [i for i in range(1,501)]
stock_ids = [i for i in range(1,21)]

cursor, conn = get_cursor() 

for i in range(500):
    etf_id = random.choice(etf_ids)
    stock_id = random.choice(stock_ids)
    shares_held = round(random.uniform(1000, 100000), 4)
    weight = round(random.uniform(0.01, 0.5), 4)

    cursor.execute("""
    INSERT INTO etf_holding (etf_id, stock_id, shares_held, weight)
    VALUES (?, ?, ?, ?)
    """, (etf_id, stock_id, shares_held, weight))

# Commit các thay đổi vào cơ sở dữ liệu
conn.commit()

# Đóng kết nối sau khi xong
conn.close()