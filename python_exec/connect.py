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
