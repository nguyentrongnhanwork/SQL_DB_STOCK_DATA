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
### Các bảng chính
**Bảng Users:**
**Bảng User_devices:**
**...**
## 4. Triển khai cơ sở dữ liệu
Cơ sở dữ liệu được triển khai trên SQL Server. Các bước triển khai cơ bản
*Tạo cở sỡ dữ liệu*
- CREATE DATABASE StockManagement;
*Tạo các bảng với cấu trúc sau:*
CREATE TABLE <Tên bảng> (
    <Cột 1> <Kiểu dữ liệu> [RangBuoc],
    <Cột 2> <Kiểu dữ liệu> [RangBuoc],
    ....
    <Cột n> <Kiểu dữ liệu> [RangBuoc]
    CONSTRAINT <Tên khóa chính> PRIMARY KEY (Tên cột 1),
    CONSTRAINT <Tên khóa ngoại> FOREIGN KEY (Tên cột 2) REFERENCES <Tên bảng chứa khóa chính> (Tên cột chứa khóa chính)
);
## 5. Tạo dữ liệu giả lập với Python
Chúng ta sẽ sử dụng Python để tạo ra các dữ liệu giả lập cho cơ sở dữ liệu. Để làm điều này, chúng ta có thể sử dụng thư viện Faker để tạo thông tin giả về cổ phiếu và người dùng, và sử dụng pyodbc để kết nối với SQL Server.
**Cài đặt thư viện**
pip install faker pyodbc
**Tạo dữ liệu giả lập**
import pyodbc
from faker import Faker
import random
*# Kết nối với SQL Server*
conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};'
                      'SERVER=your_server;'
                      'DATABASE=StockManagement;'
                      'UID=your_username;'
                      'PWD=your_password')

cursor = conn.cursor()
## 6. Tạo Trigger, Procedures và Views
**Trigger: Giám sát khi có giao dịch bán ra**
**Stored Procedure: Tính toán chỉ số trung bình giá cổ phiếu**
**View: Xem các giao dịch chứng khoán**
## 7. Kết luận
Qua dự án này, ta đã xây dựng một cơ sở dữ liệu để phân tích và quản lý chứng khoán, sử dụng SQL Server để triển khai cơ sở dữ liệu, và sử dụng Python để tạo dữ liệu giả lập. Học cách sử dụng Trigger, Procedures và Views để đảm bảo tính toàn vẹn dữ liệu và cung cấp thông tin hữu ích cho người dùng.
## 8. Tài liệu thanm khảo
