import random
from faker import Faker
from connect import get_cursor 

fake = Faker()
user_ids = [i for i in range(1,11)]
stock_ids = [i for i in range(1,21)]

cursor, conn = get_cursor()

for i in range(100):
    user_id = random.choice(user_ids)
    stock_id = random.choice(stock_ids)

    # Kiểm tra trùng lặp bằng SQL query
    cursor.execute("""
    SELECT COUNT(*)
    FROM Watchlists
    WHERE user_id = ? AND stock_id = ?
    """, (user_id, stock_id))

    count = cursor.fetchone()[0]

    # Thêm dữ liệu nếu không xuất hiện trùng lặp
    if count == 0:
        cursor.execute("""
        INSERT INTO Watchlists (user_id, stock_id)
        VALUES (?, ?)
        """, (user_id, stock_id))

# Commit các thay đổi vào cơ sở dữ liệu
conn.commit()

# Đóng kết nối sau khi xong
conn.close()