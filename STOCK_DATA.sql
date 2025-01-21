USE master;
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'STOCK_DATA')
CREATE DATABASE STOCK_DATA;

USE STOCK_DATA;
-- Tạo bảng Users (thông tin người dùng)
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
-- Tạo bảng User_devices (Danh sách các thiết bị)
CREATE TABLE User_devices(
    id INT PRIMARY KEY IDENTITY,
    user_id INT NOT NULL,
    device_id NVARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) 
);
-- Tạo bảng Stocks (Thông tin cổ phiếu)
CREATE TABLE Stocks(
    stock_id INT PRIMARY KEY IDENTITY(1,1),
    symbol NVARCHAR(10) UNIQUE NOT NULL, -- Mã cổ phiếu
    company_name NVARCHAR(200) UNIQUE NOT NULL, -- Tên công ty
    market_cap DECIMAL(18,2), -- Vốn hóa
    sector NVARCHAR(200), -- Ngành
    industry NVARCHAR(200), -- Lĩnh vực
    stock_type NVARCHAR(200), --Loại cổ phiếu (Cổ phiếu thường, cổ phiếu ưu đãi, quỹ đầu tư)
    rank INT DEFAULT 0, -- Xếp hạng
    reason NVARCHAR (200) -- Lý do được niêm yết
);
-- Tạo bảng Quotes (Trạng thái thông tin cổ phiếu)
CREATE TABLE Quotes(
    quote_id INT PRIMARY KEY IDENTITY(1,1),
    stock_id INT FOREIGN KEY REFERENCES Stocks(stock_id),
    price DECIMAL(15,2) NOT NULL, -- Giá 
    change DECIMAL(15,2) NOT NULL, -- Thay đổi giá
    percent_change DECIMAL(8,2) NOT NULL, -- % thay đổi giá
    volume DECIMAL (10,0), -- Khối lượng giao dịch
    time_stamp DATETIME NOT NULL -- Thời gian giao dịch
);
-- Tạo bảng Market_Index (Các chỉ số thị trường)
CREATE TABLE Market_Index(
    index_id INT PRIMARY KEY IDENTITY, 
    index_name NVARCHAR(200) NOT NULL, -- Tên chỉ số
    symbol NVARCHAR(50) UNIQUE NOT NULL -- Mã chỉ số
);
-- Tạo bảng Index_Constituents - Lưu trữ thông tin các cổ phiếu và các chỉ số thị trường 
CREATE TABLE Index_Constituents(
    index_id INT FOREIGN KEY REFERENCES Market_Index(index_id), --Mỗi bản ghi trong bảng này chỉ ra một chỉ số thị trường mà các cổ phiếu cụ thể thuộc về
    stock_id INT FOREIGN KEY REFERENCES Stocks(stock_id) --Mỗi bản ghi trong bảng này liên kết một cổ phiếu cụ thể với một chỉ số thị trường cụ thể
);
-- Tạo bảng Derivatives (Thông tin chứng khoán phái sinh)
CREATE TABLE Derivatives(
    derivative_id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(255) NOT NULL, -- Tên loại chứng khoán phái sinh
    underlying_asset_id INT FOREIGN KEY REFERENCES Stocks(stock_id), --id tài sản mà CKPS dựa trên
    contract_size INT, --Kích thước hợp đồng
    expiration_date DATE, --Ngày đáo hạn
    strike_price DECIMAL(18,2), --Giá thực hiện ngay thời điểm mua
    last_price DECIMAL(18,2) NOT NULL,
    change DECIMAL(18,2) NOT NULL,
    percent_change DECIMAL(18,2) NOT NULL,
    open_price DECIMAL(18,2) NOT NULL,
    high_price DECIMAL(18,2) NOT NULL,
    low_price DECIMAL(18,2) NOT NULL,
    volume DECIMAL(10,0) NOT NULL,
    open_interest INT NOT NULL,
    time_stamp DATETIME NOT NULL
);
-- Tạo bảng Coverd Warrants (Chứng quyền có bảo đảm)
CREATE TABLE Covered_Warrants(
    warrant_id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(255) NOT NULL, -- Tên chứng quyền có bảo đảm
    underlying_asset_id INT FOREIGN KEY REFERENCES Stocks(stock_id),-- id tài sản mà chứng quyền dựa trên
    issue_date DATE, -- Ngày phát hành chứng quyền có bảo đảm
    expiration_day DATE, -- Ngày đáo hạn
    strike_price DECIMAL(18,2), -- Giá thực hiện tại thời điểm mua
    warrant_type NVARCHAR(50) -- Loại chứng quyền
);
--Tạo bảng ETFs (Các quỹ đầu tư chứng khoán)
CREATE TABLE ETFs(
    etf_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(200) NOT NULL, -- Tên quỹ ETF
    symbol NVARCHAR(50) UNIQUE not null, -- Mã quỹ ETF
    management_company NVARCHAR(255), -- Tên công ty quản lý quỹ
    inception_date DATE --Ngày thành lập quỹ
);
CREATE TABLE ETF_quotes( -- Thông tin giao dịch của quỹ trong một ngày
    quote_id INT PRIMARY KEY IDENTITY(1,1),
    etf_id INT FOREIGN KEY REFERENCES ETFs(etf_id),
    price DECIMAL(18,2) NOT NULL,
    change DECIMAL(18,2) NOT NULL,
    percent_change DECIMAL(10,2) NOT NULL,
    volume DECIMAL(15,0) NOT NULL,
    time_stamp DATETIME NOT NULL
);
CREATE TABLE ETF_holding( -- Thông tin tài sản nắm giữ của các quỹ ETF
    etf_id INT FOREIGN KEY REFERENCES ETFs(etf_id), --id quỹ đầu tư nắm giữ một cổ phiếu nào đó
    stock_id INT FOREIGN KEY REFERENCES Stocks(stock_id), --id cổ phiếu mà quỹ đang nắm giữ
    shares_held DECIMAL(18,0), --Số lượng cổ phiếu đang nắm giữ
    weight DECIMAL(18,4) --Trọng số cổ phiếu trong tổng danh mục đầu tư của quỹ
);
-- Tạo bảng Watchlists(Danh sách theo dõi)
CREATE TABLE Watchlists(
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    stock_id INT FOREIGN KEY REFERENCES Stocks(stock_id)
);
-- Tạo ràng buộc để đảm bảo mỗi cặp user_id và stock_id không bị trùng lặp
ALTER TABLE Watchlists
ADD CONSTRAINT unique_user_stock UNIQUE (user_id, stock_id);

--Tạo bảng đặt lệnh
CREATE TABLE Orders(
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    stock_id INT FOREIGN KEY REFERENCES Stocks(stock_id),
    order_type NVARCHAR(30), -- Loại lệnh được thực hiện (Limit, Market, Stop )
    action NVARCHAR(10), --Hành động(mua, bán)
    quantity INT, -- Khối lượng giao dịch
    price DECIMAL(18,4), -- Giá
    status NVARCHAR(20), --Trạng thái giao dịch (Executed, Pending, Canceled)
    order_time DATETIME, --Ngày thực hiện
);
--Tạo bảng Portfolios(Danh mục đầu tư)
CREATE TABLE Portfolios(
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    stock_id INT FOREIGN KEY REFERENCES Stocks(stock_id),
    quantity INT,
    purchase_price DECIMAL(18,4), -- Giá giao dịch
    purchase_date DATETIME -- Ngày giao dịch
);
--Tạo bảng Notifications(Các thông báo)
CREATE TABLE Notifications(
    notification_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    notification_type NVARCHAR(50),
    content TEXT NOT NULL,
    has_been_read BIT DEFAULT 0, --Trạng thái thông báo (1: đã đọc, 0: chưa đọc)
    create_at DATETIME
);
--Tạo bảng Educational Resources (Nguồn tài liệu)
CREATE TABLE Educational_Resources(
    resource_id INT PRIMARY KEY IDENTITY(1,1),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    category NVARCHAR(100),
    date_published DATETIME
);
--Tạo bảng linked_bank_accounts(Tài khoản ngân hàng liên kết)
CREATE TABLE Linked_bank_accounts(
    account_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    bank_name NVARCHAR(200) NOT NULL, -- Tên ngân hàng
    account_number NVARCHAR(50) NOT NULL, -- Số tài khoản ngân hàng
    account_type NVARCHAR(50) -- Loại tài khoản (Saving, Checking)
);
--Tạo bảng Transactions(Các giao dịch)
CREATE TABLE Transactions(
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    linked_account_id INT FOREIGN KEY REFERENCES Linked_bank_accounts(account_id), -- id tài khoản liên kết
    transaction_type NVARCHAR (50), -- Loại giao dịch (Debit, Credit)
    amount DECIMAL(18,2), -- Khối lượng giao dịch
    transaction_date DATETIME -- Ngày thực hiện
);
GO;

-- Kiểm tra thông tin các bảng trong cơ sở dữ liệu
SELECT * 
FROM information_schema.tables 
WHERE table_type = 'BASE TABLE';
GO;

/*LƯU Ý: TẤT CẢ CÁC THÔNG TIN VÀ SỐ LIỆU CHỈ PHỤC VỤ CHO MỤC ĐÍCH HỌC TẬP, KHÔNG ÁP DỤNG VÀO THỰC TẾ NẾU THÔNG TIN KHÔNG CHÍNH XÁC*/

--Tạo Procedure(Thủ tục) Register User nhằm tái sử dụng mã trong những lần thêm thông tin khách hàng sau
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
--DROP PROCEDURE Register_User

-- Thêm các bản ghi vào bảng User sử dụng Procedure
EXEC Register_User 'trongnhan', 'password_1', N'trongnhan@example.com', N'0123456789', N'Nguyễn Trọng Nhân', '2002-04-17', N'Việt Nam';
EXEC Register_User 'thanhcong', 'password_2', N'thanhcong@example.com', N'0234567891', N'Trần Thành Công', '2002-05-16', N'Việt Nam';
EXEC Register_User 'vanvi', 'password_3', N'vanvi@example.com', N'0345678912', N'Hứa Văn Vĩ', '2001-02-23', N'Việt Nam';
EXEC Register_User 'myhoa', 'password_4', N'myhoa@example.com', N'0456789123', N'Trương Mỹ Hoa', '2000-11-25', N'Việt Nam';
EXEC Register_User 'thuytien', 'password_5', N'thuytien@example.com', N'0567891234', N'Nguyễn Thùy Tiên', '2000-12-05', N'Việt Nam';
EXEC Register_User 'haidang', 'password_6', N'haidang@example.com', N'0678912345', N'Lê Hải Đăng', '1999-04-21', N'Việt Nam';
EXEC Register_User 'quoctuan', 'password_7', N'quoctuan@example.com', N'0789123456', N'Trương Quốc Tuấn', '2002-08-07', N'Việt Nam';
EXEC Register_User 'mylinh', 'password_8', N'mylinh@example.com', N'0891234567', N'Trương Mỹ Linh', '2002-04-24', N'Việt Nam';
EXEC Register_User 'dinhtrong', 'password_9', N'dinhtrong@example.com', N'0912345678', N'Trần Đình Trọng', '2001-04-07', N'Việt Nam';
EXEC Register_User 'hoangduc', 'password_10', N'hoangduc@example.com', N'0135792468', N'Nguyễn Hoàng Đức', '2000-09-27', N'Việt Nam';
GO;

-- Tạo thủ tục xác minh tài khoản (Checkin_Login)
CREATE PROCEDURE Checkin_Login
    @email NVARCHAR(200),
    @password NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Hashed_Password VARBINARY(32)
    SET @Hashed_Password = HASHBYTES('SHA2_256', @Password);
    BEGIN
        SELECT * FROM Users WHERE email IN (
            SELECT email FROM Users WHERE email = @Email AND hashed_password = @Hashed_Password);
    END
END;
-- Ví dụ:
EXEC Checkin_Login 'hoangduc@example.com', 'password_10';
GO;

--Thêm dữ liệu vào bảng Stocks
INSERT INTO Stocks (symbol, company_name, market_cap, sector, industry, stock_type, rank, reason)
VALUES
('VHM', 'Vinhomes JSC', 350000000000.00, 'Real Estate', 'Residential Development', 'Common Stock', 1, N'Leading real estate developer in Vietnam'),
('VIC', 'Vingroup JSC', 300000000000.00, 'Conglomerate', 'Diversified Business', 'Common Stock', 2, N'One of the largest private enterprises in Vietnam'),
('MWG', 'Mobile World Investment Corporation', 120000000000.00, 'Consumer Discretionary', 'Retail', 'Common Stock', 3, N'Largest electronics retail chain in Vietnam'),
('FPT', 'FPT Corporation', 150000000000.00, 'Technology', 'Software & IT Services', 'Common Stock', 4, N'Leading technology services provider in Vietnam'),
('VCB', 'Vietcombank', 100000000000.00, 'Financials', 'Banking', 'Common Stock', 5, N'Top commercial bank in Vietnam'),
('SSI', 'SSI Securities Corporation', 45000000000.00, 'Financials', 'Securities', 'Common Stock', 6, N'Leading securities company in Vietnam'),
('BVH', 'Bao Viet Holdings', 55000000000.00, 'Financials', 'Insurance', 'Common Stock', 7, N'Leading insurance and financial service provider'),
('PNJ', 'Phu Nhuan Jewelry Joint Stock Company', 45000000000.00, 'Consumer Discretionary', 'Jewelry', 'Common Stock', 8, N'Top jewelry retailer in Vietnam'),
('HAG', 'Hoang Anh Gia Lai Group', 35000000000.00, 'Agriculture', 'Agriculture & Real Estate', 'Common Stock', 9, N'Diversified agriculture and real estate conglomerate'),
('GVR', 'Vietnam Rubber Group', 20000000000.00, 'Materials', 'Rubber & Timber', 'Common Stock', 10, N'Leading rubber and timber producer in Vietnam'),
('VFMVN30', 'VFMVN30 ETF', 100000000000, 'Financials', 'ETF', 'ETF', 1, N'ETF tracks the VN30 index, helping consultants access large stocks on the HOSE exchange'),
('E1VFVN30', 'E1VFVN30 ETF', 50000000000, 'Financials', 'ETF', 'ETF', 2, N'ETF tracks the VN30 index, helping consultants access large stocks on the HOSE exchange'),
('VNAS30', 'VNAS30 ETF', 300000000000, 'Financials', 'ETF', 'ETF', 3, 'Focused on the top 30 stocks of Vietnam stock market'),
('HOSE ETF', 'HOSE ETF', 200000000000, 'Financials', 'ETF', 'ETF', 4, 'ETF that tracks HOSE Index performance'),
('VGPETF', 'VGP ETF', 250000000000, 'Real Estate', 'ETF', 'ETF', 5, 'Invests in top Vietnamese real estate stocks'),
('VFFUND', 'VF Fund', 400000000000, 'Financials', 'Mutual Fund', 'Fund', 2, 'Fund investing in blue-chip stocks in Vietnam'),
('VNFF', 'Vina Fund', 350000000000, 'Financials', 'Mutual Fund', 'Fund', 3, 'Invests in both growth and value stocks'),
('BFFUND', 'BIDV Fund', 450000000000, 'Financials', 'Mutual Fund', 'Fund', 4, 'Diversified fund with a focus on Vietnam banking sector'),
('HFFUND', 'HDBank Fund', 300000000000, 'Financials', 'Mutual Fund', 'Fund', 5, 'Invests in top financial institutions in Vietnam'),
('VFMVAM', 'VFMVAM Equity Fund', 30000000000, 'Financials', 'Mutual Fund', 'Mutual Fund', 3, N'Open fund of VFMVAM invests in large and potential stocks in Vietnam');
SELECT * FROM Stocks

--Thêm dữ liệu vào bảng Quotes
INSERT INTO Quotes (stock_id, price, change, percent_change, volume, time_stamp)
VALUES
(1, 120.50, -1.75, -1.43, 15000, '2025-01-07 09:00:00'),
(2, 250.30, 5.10, 2.08, 20000, '2025-01-07 09:05:00'),
(3, 105.75, -0.25, -0.24, 12000, '2025-01-07 09:10:00'),
(4, 350.00, 7.20, 2.10, 17000, '2025-01-07 09:15:00'),
(5, 110.60, -2.30, -2.03, 22000, '2025-01-07 09:20:00'),
(6, 80.90, 1.10, 1.37, 13000, '2025-01-07 09:25:00'),
(7, 125.80, -3.60, -2.80, 15000, '2025-01-07 09:30:00'),
(8, 145.50, 4.00, 2.83, 18000, '2025-01-07 09:35:00'),
(9, 95.20, -0.50, -0.52, 14000, '2025-01-07 09:40:00'),
(10, 70.60, -1.20, -1.67, 12000, '2025-01-07 09:45:00'),
(11, 155.30, 3.00, 1.97, 20000, '2025-01-07 09:50:00'),
(12, 100.80, 1.50, 1.51, 15000, '2025-01-07 09:55:00'),
(13, 195.10, -0.80, -0.41, 17000, '2025-01-07 10:00:00'),
(14, 110.40, 2.00, 1.83, 20000, '2025-01-07 10:05:00'),
(15, 120.90, -0.40, -0.33, 16000, '2025-01-07 10:10:00'),
(16, 130.50, 2.00, 1.56, 19000, '2025-01-07 10:15:00'),
(17, 115.20, -1.10, -0.95, 18000, '2025-01-07 10:20:00'),
(18, 140.30, 4.60, 3.39, 21000, '2025-01-07 10:25:00'),
(19, 65.90, -2.50, -1.54, 18000, '2025-01-07 10:30:00'),
(20, 95.90, -2.00, -2.04, 22000, '2025-01-07 10:35:00');
SELECT * FROM Quotes

--Thêm dữ liệu vào bảng Market_Index
INSERT INTO Market_Index (index_name, symbol)
VALUES
(N'VN-Index', 'VNINDEX'),
(N'HNX-Index', 'HNXINDEX'),
(N'Upcom-Index', 'UPCOMINDEX'),
(N'S&P 500', 'SP500'),
(N'Dow Jones Industrial Average', 'DJIA'),
(N'Nasdaq Composite', 'NASDAQ'),
(N'FTSE 100', 'FTSE100'),
(N'Nikkei 225', 'NIKKEI225'),
(N'Hang Seng Index', 'HSI'),
(N'DAX 30', 'DAX30'),
(N'CAC 40', 'CAC40'),
(N'IBEX 35', 'IBEX35'),
(N'S&P/ASX 200', 'SPASX200'),
(N'MSCI World', 'MSCIWORLD'),
(N'Bovespa', 'BOVESPA');
SELECT * FROM Market_Index

--Thêm dữ liệu vào bảng Index_Constituents
INSERT INTO Index_Constituents (index_id, stock_id)
VALUES
(1, 1), 
(1, 2), 
(1, 3),
(2, 4),
(2, 5),
(2, 6), 
(3, 7), 
(3, 8), 
(4, 9),
(4, 10), 
(5, 11), 
(5, 12), 
(6, 13),
(6, 14), 
(7, 15), 
(8, 16), 
(8, 17), 
(9, 18),  
(10, 19),
(10, 20);
GO;

--Tạo view_stocks
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
GO;
--SELECT*FROM View_stocks AS v 

--Thực hiện một vài câu lệnh cơ bản từ View_stocks
SELECT v.company_name, v.index_symbol, COUNT(v.company_name) AS total_companies
FROM View_stocks AS v 
GROUP BY v.company_name, v.index_symbol
ORDER BY v.company_name

SELECT v.company_name, v.index_symbol, FORMAT(v.market_cap, '#,###')
FROM View_stocks AS v 
WHERE v.market_cap > 50000000000
ORDER BY v.market_cap DESC

--Thêm dữ liệu cho bảng Derivatives
INSERT INTO Derivatives (name, underlying_asset_id, contract_size, expiration_date, strike_price, last_price, change, percent_change, open_price, high_price, low_price, volume, open_interest, time_stamp)
VALUES
(N'VHM Futures', 1, 100, '2025-03-01', 120.50, 119.20, -1.30, -1.08, 120.00, 122.50, 118.00, 15000, 5000, '2025-01-07 09:00:00'),
(N'VIC Futures', 2, 100, '2025-03-01', 250.00, 245.30, -4.70, -1.88, 248.00, 252.00, 244.00, 20000, 4000, '2025-01-07 09:05:00'),
(N'MWG Futures', 3, 100, '2025-04-01', 105.00, 106.50, 1.50, 1.43, 104.50, 107.00, 102.00, 12000, 6000, '2025-01-07 09:10:00'),
(N'FPT Futures', 4, 100, '2025-05-01', 350.00, 348.80, -1.20, -0.34, 349.00, 353.00, 347.00, 17000, 5500, '2025-01-07 09:15:00'),
(N'VCB Futures', 5, 100, '2025-06-01', 110.00, 112.20, 2.20, 2.02, 111.00, 113.00, 110.00, 22000, 7000, '2025-01-07 09:20:00'),
(N'SSI Futures', 6, 100, '2025-03-01', 80.00, 81.30, 1.30, 1.61, 80.50, 82.00, 79.00, 13000, 4500, '2025-01-07 09:25:00'),
(N'BVH Futures', 7, 100, '2025-04-01', 125.00, 124.00, -1.00, -0.80, 123.50, 126.00, 122.00, 15000, 4200, '2025-01-07 09:30:00'),
(N'PNJ Futures', 8, 100, '2025-05-01', 145.00, 144.80, -0.20, -0.14, 144.00, 146.00, 143.00, 18000, 4800, '2025-01-07 09:35:00'),
(N'HAG Futures', 9, 100, '2025-06-01', 95.00, 96.50, 1.50, 1.58, 95.00, 97.00, 94.00, 14000, 5300, '2025-01-07 09:40:00'),
(N'GVR Futures', 10, 100, '2025-07-01', 70.00, 69.00, -1.00, -1.43, 70.50, 71.00, 68.00, 12000, 3900, '2025-01-07 09:45:00'),
(N'VFMVN30 Futures', 11, 100, '2025-03-01', 155.00, 156.50, 1.50, 0.97, 155.00, 157.00, 154.00, 20000, 6200, '2025-01-07 09:50:00'),
(N'E1VFVN30 Futures', 12, 100, '2025-04-01', 100.00, 101.50, 1.50, 1.50, 100.50, 102.00, 99.00, 15000, 5600, '2025-01-07 09:55:00'),
(N'VFMVAM Futures', 13, 100, '2025-05-01', 300.00, 305.00, 5.00, 1.67, 303.00, 306.00, 302.00, 18000, 6700, '2025-01-07 10:00:00'),
(N'SSIAMF Futures', 14, 100, '2025-06-01', 270.00, 265.50, -4.50, -1.67, 267.00, 268.00, 265.00, 20000, 7300, '2025-01-07 10:05:00'),
(N'VHM Options', 1, 50, '2025-03-01', 121.00, 120.50, -0.50, -0.41, 120.00, 122.50, 118.50, 15000, 4000, '2025-01-07 10:10:00'),
(N'VIC Options', 2, 50, '2025-04-01', 251.00, 249.00, -2.00, -0.80, 250.00, 253.00, 248.00, 18000, 4200, '2025-01-07 10:15:00'),
(N'MWG Options', 3, 50, '2025-05-01', 106.00, 105.00, -1.00, -0.94, 105.50, 107.00, 104.00, 12000, 3500, '2025-01-07 10:20:00'),
(N'FPT Options', 4, 50, '2025-06-01', 349.00, 347.50, -1.50, -0.43, 348.00, 350.00, 346.00, 17000, 4600, '2025-01-07 10:25:00');
SELECT * FROM Derivatives
GO;

--Tạo View_derivatives
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
GO;

--Thêm dữ liệu vào bảng Covered_Warrants
INSERT INTO Covered_Warrants (name, underlying_asset_id, issue_date, expiration_day, strike_price, warrant_type)
VALUES
(N'VHM Covered Warrant', 1, '2025-01-01', '2025-06-01', 125.00, 'Call'),
(N'VIC Covered Warrant', 2, '2025-01-01', '2025-06-01', 260.00, 'Call'),
(N'MWG Covered Warrant', 3, '2025-02-01', '2025-07-01', 110.00, 'Call'),
(N'FPT Covered Warrant', 4, '2025-02-01', '2025-07-01', 355.00, 'Put'),
(N'VCB Covered Warrant', 5, '2025-03-01', '2025-08-01', 115.00, 'Call'),
(N'SSI Covered Warrant', 6, '2025-03-01', '2025-08-01', 85.00, 'Put'),
(N'BVH Covered Warrant', 7, '2025-04-01', '2025-09-01', 130.00, 'Call'),
(N'PNJ Covered Warrant', 8, '2025-04-01', '2025-09-01', 150.00, 'Put'),
(N'HAG Covered Warrant', 9, '2025-05-01', '2025-10-01', 95.00, 'Call'),
(N'GVR Covered Warrant', 10, '2025-05-01', '2025-10-01', 75.00, 'Put'),
(N'VFMVN30 Covered Warrant', 11, '2025-06-01', '2025-11-01', 160.00, 'Call'),
(N'E1VFVN30 Covered Warrant', 12, '2025-06-01', '2025-11-01', 105.00, 'Put'),
(N'VFMVAM Covered Warrant', 13, '2025-07-01', '2025-12-01', 310.00, 'Call'),
(N'SSIAMF Covered Warrant', 14, '2025-07-01', '2025-12-01', 275.00, 'Put'),
(N'VHM Warrant B', 1, '2025-01-15', '2025-06-15', 130.00, 'Call'),
(N'VIC Warrant B', 2, '2025-01-15', '2025-06-15', 265.00, 'Put'),
(N'MWG Warrant B', 3, '2025-02-15', '2025-07-15', 115.00, 'Call'),
(N'FPT Warrant B', 4, '2025-02-15', '2025-07-15', 350.00, 'Put'),
(N'VCB Warrant B', 5, '2025-03-15', '2025-08-15', 118.00, 'Call'),
(N'SSI Warrant B', 6, '2025-03-15', '2025-08-15', 90.00, 'Put');
SELECT * FROM Covered_Warrants
GO;

--Thêm dữ liệu cho bảng ETFs, ETF_holding, Watchlist, Orders và Portfolio bằng Code Python
SELECT * FROM ETFs

SELECT * FROM ETF_holding

SELECT * FROM Watchlists

SELECT * FROM Orders

SELECT * FROM Portfolios
GO;

-- Thêm dữ liệu vào bảng Educational Resources
INSERT INTO Educational_Resources (title, content, category, date_published)
VALUES
('Introduction to Stock Market', 'This resource introduces the basics of the stock market, including key terms and how the market operates.', 'Stock Market', '2025-01-01 09:00:00'),
('Fundamentals of Investing', 'A guide to the principles of investing, including risk management, diversification, and portfolio building.', 'Investing', '2025-01-02 10:00:00'),
('Technical Analysis for Beginners', 'Learn the basics of technical analysis, including chart patterns, indicators, and trading strategies.', 'Technical Analysis', '2025-01-03 11:00:00'),
('Understanding Bonds and Fixed Income', 'An introduction to bonds, their types, and how they work as a fixed-income investment.', 'Bonds', '2025-01-04 12:00:00'),
('Introduction to Mutual Funds', 'A resource to understand mutual funds, how they work, and their role in a diversified investment portfolio.', 'Mutual Funds', '2025-01-05 13:00:00'),
('How to Read Financial Statements', 'Learn how to interpret financial statements to assess a company`s financial health and make informed investment decisions.', 'Finance', '2025-01-06 14:00:00'),
('Options Trading Basics', 'A beginner`s guide to options trading, including calls, puts, and the risks involved.', 'Options Trading', '2025-01-07 15:00:00'),
('Investment Strategies for Long-Term Success', 'Explore various long-term investment strategies for building wealth over time, including dividend investing and index funds.', 'Investing', '2025-01-08 16:00:00'),
('Introduction to Real Estate Investment', 'A guide to investing in real estate, including rental properties and REITs (Real Estate Investment Trusts).', 'Real Estate', '2025-01-09 17:00:00'),
('Risk Management in Investing', 'Understand how to assess and manage risk in your investment portfolio to protect your capital.', 'Risk Management', '2025-01-10 18:00:00'),
('The Psychology of Investing', 'Learn about the psychological factors that affect investment decisions and how to overcome emotional biases.', 'Behavioral Finance', '2025-01-11 19:00:00'),
('Value Investing Principles', 'A deep dive into the principles of value investing, focusing on evaluating stocks based on their intrinsic value.', 'Value Investing', '2025-01-12 20:00:00'),
('Understanding Exchange-Traded Funds (ETFs)', 'An introduction to ETFs, their benefits, and how to use them in your investment strategy.', 'ETFs', '2025-01-13 21:00:00'),
('Cryptocurrency Investing for Beginners', 'Explore the world of cryptocurrency investing, including Bitcoin, Ethereum, and blockchain technology.', 'Cryptocurrency', '2025-01-14 22:00:00'),
('How to Build a Diversified Portfolio', 'Learn how to build a well-diversified portfolio that balances risk and reward.', 'Investing', '2025-01-15 23:00:00'),
('Day Trading Strategies', 'A resource for understanding day trading strategies, including short-term trading and timing the market.', 'Day Trading', '2025-01-16 00:00:00'),
('The Role of Dividends in Investing', 'Learn how dividend-paying stocks can generate passive income and contribute to long-term wealth.', 'Dividend Investing', '2025-01-17 01:00:00'),
('How to Value Stocks Using Discounted Cash Flow (DCF)', 'A guide to valuing stocks using the DCF method, including understanding cash flows and discount rates.', 'Stock Valuation', '2025-01-18 02:00:00'),
('Introduction to Forex Trading', 'An overview of the foreign exchange market (Forex), including how currency trading works.', 'Forex Trading', '2025-01-19 03:00:00'),
('Understanding the Economic Indicators', 'Learn about key economic indicators like GDP, inflation, and unemployment rates that impact the financial markets.', 'Economics', '2025-01-20 04:00:00');
SELECT * FROM Educational_Resources
GO;

-- Thêm dữ liệu vào bảng Linked_bank_accounts
INSERT INTO Linked_bank_accounts (user_id, bank_name, account_number, account_type)
VALUES
(1, 'Vietcombank', '1234567890', 'Savings'),
(1, 'BIDV', '0987654321', 'Checking'),
(2, 'Techcombank', '1122334455', 'Savings'),
(2, 'VietinBank', '6677889900', 'Checking'),
(3, 'Sacombank', '5566778899', 'Savings'),
(3, 'ACB', '9988776655', 'Checking'),
(4, 'MB Bank', '2233445566', 'Savings'),
(4, 'VPBank', '7788990011', 'Checking'),
(5, 'Shinhan Bank', '4455667788', 'Savings'),
(5, 'Eximbank', '8899001122', 'Checking'),
(6, 'Techcombank', '1234567891', 'Savings'),
(6, 'Vietcombank', '0987654322', 'Checking'),
(7, 'VietinBank', '1122334456', 'Savings'),
(7, 'BIDV', '6677889901', 'Checking'),
(8, 'ACB', '5566778900', 'Savings'),
(8, 'Sacombank', '9988776656', 'Checking'),
(9, 'VPBank', '2233445567', 'Savings'),
(9, 'MB Bank', '7788990012', 'Checking'),
(10, 'Shinhan Bank', '4455667789', 'Savings'),
(10, 'Eximbank', '8899001123', 'Checking');
SELECT * FROM Linked_bank_accounts
GO;

/*
Tạo một Trigger sau khi thêm dữ liệu vào bảng Orders để:
- Thêm dữ liệu hoặc cập nhật vào cột stock_id và quantity của bảng Porfolios
- Thêm dữ liệu vào bảng Notifications
- Thêm dữ liệu vào bảng Transactions
*/
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
GO;

-- Ví dụ: Thực hiện câu lệnh insert dữ liệu vào bảng Orders
SET IDENTITY_INSERT Orders ON;
INSERT INTO Orders (order_id, user_id, stock_id, order_type, action, quantity, price, status, order_time)
VALUES
(501, 1, 12, 'Market', 'Buy', 150, 80, 'Executed', '2025-01-14 10:00:00')
-- Thực hiện kiểm tra trên các bảng liên quan
SELECT * FROM Orders
SELECT * FROM Portfolios
SELECT * FROM Notifications
SELECT * FROM Transactions
GO;

-- Thực hiện tạo câu lệnh tự động thêm dữ liệu thông tin chứng khoán cho bảng Quotes sau mỗi 5 giây bằng code Python
SELECT * FROM Quotes
SELECT COUNT(*) FROM Quotes