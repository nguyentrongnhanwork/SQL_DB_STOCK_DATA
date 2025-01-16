import random
from faker import Faker
from connect import get_cursor 

fake = Faker()
symbols = ['VFMVN30', 'E1VFVN30', 'VFMVAM', 'SSIAMF', 'VFM', 'VNAS30', 'ETFVN30', 'VNFUND', 'VGPETF', 'VN50', 
           'HOSEETF', 'ETFVN100', 'VASCETF', 'VIEETF', 'VSI30', 'VIGETF', 'VN30G', 'VIMF', 'VHN', 'VIXETF']

# Tạo set lưu trữ các giá trị đã được sử dụng
used_symbols = set()

# Lấy kết nối và cursor từ db_connect.py
cursor, conn = get_cursor()

# Tạo 500 bảng ghi giả cho bảng ETFs
for i in range(500):
    name = fake.company() + ' ETF'
    while True:
        symbol = random.choice(symbols) + str(random.randint(1, 100))
        if symbol not in used_symbols:
            used_symbols.add(symbol)
            break
    management_company = fake.company()
    inception_date = fake.date_between(start_date="-10y", end_date="today")

    # Thêm dữ liệu giả vào bảng ETFs
    cursor.execute("""
    INSERT INTO ETFs (name, symbol, management_company, inception_date)
    VALUES (?, ?, ?, ?)
    """, (name, symbol, management_company, inception_date))

# Commit các thay đổi vào cơ sở dữ liệu
conn.commit()

# Đóng kết nối sau khi xong
conn.close()
