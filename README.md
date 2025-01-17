# SQL_DB_STOCK_DATA
*Author: Nguyen Trong Nhan*
## Giới thiệu
Dự án nhằm xây dựng một cơ sở dữ liệu để phân tích và quản lý chứng khoán. Cơ sở dữ liệu sẽ cung cấp thông tin quan trọng liên quan đến các giao dịch chứng khoán, dữ liệu cổ phiếu, chứng quyền, chứng chỉ quỹ của công ty niêm yết giúp người dùng quản lý và đưa ra các quyết định đầu tư hợp lý.
Trong quá trình thực hiện, ta sẽ:
- **Xác định các yêu cầu của ứng dụng**: Làm rõ các chức năng thông tin mà ứng dụng cần cung cấp.
- **Thiết kế mô hình dữ liệu**: Xác định cá bảng, mối quan hệ và cấu trúc dữ liệu phù hợp.
- **Sử dụng SQL Server**: Cài đặt và triển khai cơ sở dữ liệu.
- **Sử dụng Python**: Tạo dữ liệu giả lập, sinh dữ liệu mẫu cho cơ sở dữ liệu.
- **Tạo Trigger, Procedures và Views**: Đảm bảo tính toàn vẹn dữ liệu cũng như cung cấp báo cáo, thông tin hữu ích người dùng.
- **Kết Nối Và Đưa Lên Docker**: Đưa hệ thống cơ sở dữ liệu vào một container Docker để dễ dàng triển khai và sử dụng.
## 1. Mục tiêu
Với **SQL_DB_STOCK_DATA**, ta có thể:
- Xây dựng cơ sở dữ liệu cho hệ thống quản lý chứng khoán.
- Đảm bảo tính toàn vẹn của dữ liệu và cung cấp báo cáo về thông tin cổ phiếu, chứng quyền, chứng chỉ quỹ, các chỉ số thị trường, danh mục đầu tư, thông tin các giao dịch.
- Sử dụng SQL Server để triển khai và Python để tạo dữ liệu giả lập.
- Sử dụng Trigger, Procedures và Views để tự động hóa các tác vụ và cung cấp thông tin trực quan cho người dùng.
## 2. Điều kiện tiên quyết
### Quản lý thông tin cổ phiếu:
- Mã chứng khoán, tên công ty, ngành nghề, lĩnh vực, giá mở cửa, giá đóng cửa, khối lượng giao dịch,v.v.
### Quản lý giao dịch:
- Lưu trữ thông tin về các giao dịch mua/ bán chứng khoán của người dùng
- Thông tin về thời gian, số lượng, giá trị của từng giao dịch
### Phân tích thị trường:
- Các chỉ số thị trường, biến động giá, mức tăng giảm của các cổ phiếu
- Các thông tin về thị trường
### Quản lý người dùng:
- Tạo và quản lý hông tin tài khoản người dùng (tên, email, mật khẩu tài khoản)
## 3. Thiết kế mô hình dữ liệu
### Cấu trúc các bảng chính
**- Bảng Users:** user_id PRIMARY KEY, user_name, hashed_password, email, phone_number, full_name, date_of_birth, country  
**- Bảng User_devices:** id PRIMARY KEY, user_id FOREIGN KEY REFERENCES Users(user_id), device_id  
**- Bảng Stocks:** stock_id PRIMARY KEY, symbol, company_name, market_cap sector, industry, stock_type, rank, reason  
**- Bảng Quotes:** quote_id PRIMARY KEY, stock_id FOREIGN KEY REFERENCES Stocks(stock_id), price, change percent_change, volume, time_stamp  
**- Bảng Market_Index:** index_id PRIMARY KEY IDENTITY, index_name, symbol  
**- Bảng Index_Constituents:** index_id FOREIGN KEY REFERENCES Market_Index(index_id), stock_id FOREIGN KEY REFERENCES Stocks(stock_id)  
**- Bảng Derivatives:** derivative_id, name, underlying_asset_id FOREIGN KEY REFERENCES Stocks(stock_id), contract_size, expiration_date, strike_price, last_price, change, percent_change, open_price, high_price, low_price, volume, open_interest, time_stamp  
**- Bảng Covered_Warrants:** warrant_id PRIMARY KEY, name, underlying_asset_id FOREIGN KEY REFERENCES Stocks(stock_id), issue_date, expiration_day, strike_price, warrant_type  
**- Bảng ETFs:** etf_id INT PRIMARY KEY, name, symbol, management_company, inception_date  
**- Bảng ETF_quotes:** quote_id INT PRIMARY KEY, etf_id FOREIGN KEY REFERENCES ETFs(etf_id), price, change, percent_change, volume, time_stamp  
**- Bảng ETF_holding:** etf_id FOREIGN KEY REFERENCES ETFs(etf_id), stock_id FOREIGN KEY REFERENCES Stocks(stock_id), shares_held, weight  
**- Bảng Watchlists:** user_id FOREIGN KEY REFERENCES Users(user_id), stock_id FOREIGN KEY REFERENCES Stocks(stock_id)  
**- Bảng Orders:** order_id PRIMARY KEY, user_id FOREIGN KEY REFERENCES Users(user_id), stock_id FOREIGN KEY REFERENCES Stocks(stock_id), order_type, action, quantity, price, status, order_time  
**- Bảng Portfolios:** user_id FOREIGN KEY REFERENCES Users(user_id), stock_id FOREIGN KEY REFERENCES Stocks(stock_id), quantity, purchase_price, purchase_date  
**- Bảng Notifications:** notification_id PRIMARY KEY, user_id FOREIGN KEY REFERENCES Users(user_id), notification_type, content, has_been_read, create_at  
**- Bảng Educational_Resources:** resource_id PRIMARY KEY, title, content, category, date_published  
**- Bảng Linked_bank_accounts:** account_id PRIMARY KEY, user_id FOREIGN KEY REFERENCES Users(user_id), bank_name, account_number, account_type  
**- Bảng Transactions:** transaction_id PRIMARY KEY, user_id FOREIGN KEY REFERENCES Users(user_id), linked_account_id FOREIGN KEY REFERENCES Linked_bank_accounts(account_id), transaction_type, amount, transaction_date  
## 4. Cài đặt và triển khai cơ sở dữ liệu
**Cài đặt các thư viện Python cần thiết:**
```python
pip install pandas pyodbc
```
**Sử dụng Python để kết nối với SQL Server**
## Cấu trúc kết nối SQL Server với Python sử dụng pyodbc
Để kết nối đến SQL Server từ Python, bạn cần cung cấp các thông tin sau:
1. **server**: Địa chỉ và cổng của máy chủ SQL Server (Ví dụ: 'localhost, 1444').
2. **database**: Tên của cơ sở dữ liệu mà bạn muốn kết nối (Ví dụ: 'STOCK_DATA').
3. **username**: Tên tài khoản để đăng nhập vào SQL Server (Ví dụ: 'sa').
4. **password**: Mật khẩu tương ứng với tài khoản đăng nhập (Ví dụ: 'StrongPassword!2025').  
Chú ý rằng các giá trị này có thể thay đổi tùy theo cấu hình của bạn.  
**Ví dụ:**
*Kết nối với SQL Server*
```python
import pyodbc
# Thông tin kết nối
server = 'localhost, 1444'  
database = 'STOCK_DATA' 
username = 'sa'
password = 'StrongPassword!2025'

# Kết nối đến SQL Server trong Docker container
conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};'
                      f'SERVER={server};'
                      f'DATABASE={database};'
                      f'UID={username};'
                      f'PWD={password};')

# Tạo cursor để thực thi các câu lệnh SQL
cursor = conn.cursor()
# Đảm bảo rằng kết nối được trả về
def get_cursor():
    return cursor, conn
```
**Cơ sở dữ liệu được triển khai trên SQL Server. Các bước triển khai:**  
*Tạo cở sỡ dữ liệu*  
```sql
CREATE DATABASE StockManagement;
```
*Ví dụ:*
```sql
CREATE DATABASE STOCK_DATA;
```
*Tạo các bảng với cấu trúc sau:*
```sql
CREATE TABLE <Tên bảng> (
    <Cột 1> <Kiểu dữ liệu> [RangBuoc],
    <Cột 2> <Kiểu dữ liệu> [RangBuoc],
    ....
    <Cột n> <Kiểu dữ liệu> [RangBuoc]
    CONSTRAINT <Tên khóa chính> PRIMARY KEY (Tên cột 1),
    CONSTRAINT <Tên khóa ngoại> FOREIGN KEY (Tên cột 2) REFERENCES <Tên bảng chứa khóa chính> (Tên cột chứa khóa chính)
);
```
*Ví dụ:*
```sql
CREATE TABLE Users(
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    user_name NVARCHAR (100) UNIQUE NOT NULL,
    hashed_password NVARCHAR (200) NOT NULL, -- Mật khẩu đã được mã hóa
    email NVARCHAR (200) UNIQUE NOT NULL,
    phone_number NVARCHAR (20) NOT NULL,
    full_name NVARCHAR (300) NOT NULL,
    date_of_birth DATE, 
    country NVARCHAR (200)
);
```
## 5. Tạo dữ liệu giả lập với Python
Chúng ta sẽ sử dụng Python để tạo ra các dữ liệu giả lập cho cơ sở dữ liệu. Để làm điều này, chúng ta có thể sử dụng thư viện Faker để tạo thông tin giả về cổ phiếu và người dùng, và sử dụng pyodbc để kết nối với SQL Server.  
**Cài đặt thư viện**
```python
pip install faker pyodbc
```
**Tạo dữ liệu giả lập**  
*Ví dụ:* Tạo dữ liệu giả lập để tạo ra các thông tin về ETF
```python
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
```
## 6. Tạo Trigger, Procedures và Views
**Trigger: Giám sát khi có giao dịch bán ra**
```sql
CREATE TRIGGER trg_after_insert_orders
ON Orders
AFTER INSERT
AS
BEGIN
    -- 1. Cập nhật hoặc thêm dữ liệu vào bảng Portfolios
    -- Nếu stock_id đã tồn tại trong bảng Portfolios cho user_id, ta sẽ cập nhật quantity.
    -- Nếu chưa tồn tại, ta sẽ thêm dòng mới cho user_id và stock_id này.
    MERGE INTO Portfolios AS target
    USING inserted AS source
    ON target.user_id = source.user_id AND target.stock_id = source.stock_id
    WHEN MATCHED THEN
        UPDATE SET target.quantity = target.quantity + source.quantity
    WHEN NOT MATCHED THEN
        INSERT (user_id, stock_id, quantity, purchase_price, purchase_date)
        VALUES (source.user_id, source.stock_id, source.quantity, source.price, GETDATE());

    -- 2. Thêm dữ liệu vào bảng Notifications
    INSERT INTO Notifications (user_id, notification_type, content, has_been_read, create_at)
    SELECT user_id, 
           'New Order', 
           CONCAT('A new order has been placed for stock ', stock_id, '. Quantity: ', quantity),
           0, 
           GETDATE()
    FROM inserted;

    -- 3. Thêm dữ liệu vào bảng Transactions
    -- Tạo giao dịch cho đơn hàng đã được thêm vào
    INSERT INTO Transactions (user_id, linked_account_id, transaction_type, amount, transaction_date)
    SELECT user_id,
           -- Giả sử linked_account_id là 1 (cần thay đổi nếu có logic xác định linked_account_id)
           1 AS linked_account_id, 
           CASE 
               WHEN action = 'Buy' THEN 'Debit' 
               WHEN action = 'Sell' THEN 'Credit' 
           END AS transaction_type,
           quantity * price AS amount,
           GETDATE()
    FROM inserted;
END;
```
**Stored Procedure: Tạo Procedure quản lý thông tin khách hàng**
```sql
CREATE PROCEDURE Register_User
    @username NVARCHAR(100),
    @password NVARCHAR(200),
    @email NVARCHAR(200),
    @phone NVARCHAR(20),
    @full_name NVARCHAR(300),
    @date_of_birth DATE,
    @country NVARCHAR(200)
AS
BEGIN
    -- Kiểm tra thông tin trùng lặp
     IF EXISTS (SELECT 1 FROM Users WHERE user_name = @username)
    BEGIN
        PRINT 'Username already exists!';
        RETURN;
    END
    -- Thêm thông tin khách hàng mới nếu không xảy ra trùng lặp
    INSERT INTO Users(user_name, hashed_password, email, phone_number, full_name, date_of_birth, country)
    VALUES(@username, HASHBYTES('SHA2_256', @password), @email, @phone, @full_name, @date_of_birth, @country);
END;
```
**View: Xem các giao dịch chứng khoán và các sản phẩm phái sinh**  
*Chứng khoán*
```sql
CREATE VIEW View_stocks AS
SELECT 
    s.stock_id,
    s.symbol,
    s.company_name,
    s.market_cap,
    s.sector,
    s.industry,
    s.stock_type,
    i.index_id,
    m.symbol AS index_symbol,
    m.index_name
FROM Stocks AS s
INNER JOIN Index_Constituents AS i ON i.stock_id = s.stock_id
INNER JOIN Market_Index AS m ON m.index_id = i.index_id;
```
*Sản phẩm phái sinh*
```sql
CREATE VIEW View_derivatives AS
SELECT 
    s.stock_id,
    s.symbol,
    s.company_name,
    d.derivative_id,
    d.name,
    d.contract_size,
    d.expiration_date,
    d.underlying_asset_id,
    d.volume,
    d.time_stamp
FROM Derivatives AS d 
INNER JOIN Stocks AS s on s.stock_id = d.underlying_asset_id
```
## 7. Kết nối và đưa lên Docker
Cài đặt Docker nếu chưa có: [Docker Downloads]  
Tạo file Dokcker Compose chứa các thông tin kết nối.  
Ví dụ Docker Compose: [https://github.com/nguyentrongnhanwork/SQL_DB_STOCK_DATA/blob/main/docker-compose.yml]  
Xây dựng và chạy container (Windows PowerShell):  
```
docker ps
docker-compose up -d
docker start <id hoặc tên container>
```
Mã Python kết nối: [https://github.com/nguyentrongnhanwork/SQL_DB_STOCK_DATA/blob/main/python_exec/connect.py]
## 8. Kết luận
Qua dự án này, ta đã xây dựng một cơ sở dữ liệu để phân tích và quản lý chứng khoán, sử dụng SQL Server để triển khai cơ sở dữ liệu, và sử dụng Python để tạo dữ liệu giả lập. Học cách sử dụng Trigger, Procedures và Views để đảm bảo tính toàn vẹn dữ liệu và cung cấp thông tin hữu ích cho người dùng.
## 9. Tài liệu thanm khảo
