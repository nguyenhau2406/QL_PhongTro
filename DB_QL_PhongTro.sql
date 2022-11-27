USE master
GO
IF EXISTS(SELECT * FROM sys.databases WHERE name='QL_PHONGTRO_KL')
BEGIN
        DROP DATABASE QL_PHONGTRO_KL
END
CREATE DATABASE QL_PHONGTRO_KL
GO
USE QL_PHONGTRO_KL
GO

CREATE TABLE DM_MANHINH
(
	ID VARCHAR(15) NOT NULL,
	TENMH NVARCHAR(50)
	CONSTRAINT PK_DM_MANHINH PRIMARY KEY (ID)
)

CREATE TABLE TAIKHOAN
(
	MATK VARCHAR(15) NOT NULL,
	TENDANGNHAP VARCHAR(15),
	PASSWORD VARCHAR(50),
	CONSTRAINT PK_TAIKHOAN PRIMARY KEY(MATK)
)

CREATE TABLE QL_NHOMNGUOIDUNG
(
    MANHOM INT IDENTITY NOT NULL PRIMARY KEY,
    TENNHOM NVARCHAR(50),
	GHICHU VARCHAR(2)
)

CREATE TABLE QL_NGUOIDUNGNHOMNGUOIDUNG 
(
    ID_NHOM INT REFERENCES QL_NHOMNGUOIDUNG(MANHOM),
    ID_TAIKHOAN VARCHAR(15) REFERENCES TAIKHOAN(MATK),
    CONSTRAINT PK_NND PRIMARY KEY (ID_NHOM, ID_TAIKHOAN)
)

CREATE TABLE QL_PHANQUYEN
(
    ID_NHOM INT REFERENCES QL_NHOMNGUOIDUNG(MANHOM) NOT NULL,
    ID_MH VARCHAR(15) REFERENCES DM_MANHINH(ID) NOT NULL,
    COQUYEN BIT NOT NULL,
    CONSTRAINT PK_PQ PRIMARY KEY (ID_NHOM, ID_MH)
)

CREATE TABLE THONGTINTAIKHOAN (
    ID VARCHAR(20) NOT NULL, -- CREATE AUTO
    HOTEN NVARCHAR(50), -- HỌ TÊN
    NGSINH DATE, -- NGÀY SINH
    GTINH NVARCHAR(10),
    SDT VARCHAR(11), -- SDT
    DCHI NVARCHAR(50), -- ĐỊA CHỈ NHÀ 
    ID_TAIKHOAN VARCHAR(15) REFERENCES TAIKHOAN(MATK) unique,
    CONSTRAINT PK_TTTK PRIMARY KEY (ID)
)

CREATE TABLE CHUNHATRO
(
	MaChuNha varchar(10) NOT NULL,
	TenChuNha nvarchar(50),
	GioiTinh nvarchar(20),
	NgheNghiep nvarchar(50),
	DiaChi nvarchar(50),
	QueQuan nvarchar(50),
	CMND varchar(14),
	SDT varchar(11),
	Email varchar(50),
	ID VARCHAR(15) unique,
	Constraint PK_CHUNHATRO PRIMARY KEY (MaChuNha),
	Constraint FK_CHUNHATRO_TAIKHOAN FOREIGN KEY (ID) REFERENCES TAIKHOAN(MATK),
)

CREATE TABLE LOAIPHONG
(
	MaLoaiPhong varchar(10) NOT NULL,
	TenLoaiPhong nvarchar(50),
	Constraint PK_LOAIPHONG PRIMARY KEY (MaLoaiPhong)
)

CREATE TABLE PHONGTRO
(
	MaPhongTro varchar(10) NOT NULL,
	TenPhongTro nvarchar(50),
	DiaChi nvarchar(60),
	HinhAnh varchar(50),
	MoTaChiTiet ntext,
	SLThanhVien int, --sl người ở là 4 
	DienTich float,
	GiaPhong float, --giá 1 tháng
	TinhTrang varchar(50),
	MaLoaiPhong varchar(10),
	MaChuNha varchar(10),

-- tiền điện theo bậc:
	--Bậc 1: Cho kWh từ 0 – 50	1.678
 	--Bậc 2: Cho kWh từ 51 – 100	1.734
 	--Bậc 3: Cho kWh từ 101 – 200	2.014
 	--Bậc 4: Cho kWh từ 201 – 300	2.536
	--Bậc 5: Cho kWh từ 301 – 400	2.834
 	--Bậc 6: Cho kWh từ 401 trở lên	2.927
	TienDienBac1_0_50 float,
	TienDienBac2_51_100 float,
	TienDienBac3_101_200 float,
	TienDienBac4_201_300 float,
	TienDienBac5_301_400 float,
	TienDienBac6_401_Trolen float,
 
-- tiền nước tỷ suất theo tháng 
	--Mức giá 5.300 đồng/m3 (đến 4m3/người/tháng)
	--Mức giá 10.200 đồng/m3 (trên 4m3 đến 6m3/người/tháng)
	--Mức giá  11.400 đồng/m3 (trên 6m3/người/tháng)
	TienNuoc_1M3_4M3 float,
	TienNuoc_5M3_6M3 float,
	TienNuoc_7M3_TroLen float,

--
	Constraint PK_PHONGTRO PRIMARY KEY(MaPhongTro),
	Constraint FK_PHONGTRO_LOAIPHONG FOREIGN KEY (MaLoaiPhong) REFERENCES LOAIPHONG(MaLoaiPhong),
	Constraint FK_PHONGTRO_CHUNHATRO FOREIGN KEY (MaChuNha) REFERENCES CHUNHATRO(MaChuNha),
)

CREATE TABLE HIENTRANGPHONG
(
	MaPhongTro varchar(10) NOT NULL,
	Ngay date,
	TinhTrangNoiThat text,
	Constraint PK_HIENTRANGPHONG PRIMARY KEY (MaPhongTro, Ngay),
	ConstraInt FK_HIENTRANGPHONG_PHONGTRO FOREIGN KEY(MaPhongTro) REFERENCES PHONGTRO(MaPhongTro)
)

CREATE TABLE KHACHHANG
(
	MaKH varchar(10) NOT NULL,
	MaHopDong varchar(10),
	HoTenKH nvarchar(50),
	GioiTinh nvarchar(20),
	NgheNghiep nvarchar(50),
	DiaChi nvarchar(50),
	QueQuan nvarchar(100),
	CMND varchar(14),
	SDT varchar(11),
	Email varchar(50),
	NgayDangKy date,
	TinhTrangXetDuyet nvarchar(50),
	MaPhongTro varchar(10),
	Constraint PK_KHACHHANG PRIMARY KEY(MaKH),
	Constraint FK_KHACHHANG_PHONGTRO FOREIGN KEY (MaPhongTro) REFERENCES PHONGTRO(MaPhongTro),
)

CREATE TABLE HOPDONG
(
	MaHopDong varchar(10) NOT NULL,
	MaKH varchar(10) unique,
	MaPhongTro varchar(10),
--GiaThue float, --giá thuê/tháng ( ko cần vì kết với bảng phòng rồi , giá như nhau )
	HinhThucThanhToan nvarchar(50),
	NgayKiHopDong date,
	NgayBatDauThue date,
	NgayTraPhong date,
	Constraint PK_HOPDONG PRIMARY KEY (MaHopDong),
	Constraint FK_HOPDONG_KHACHHANG FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
	Constraint FK_HOPDONG_PHONGTRO FOREIGN KEY (MaPhongTro) REFERENCES PHONGTRO(MaPhongTro),
)

CREATE TABLE HOADON
(
	MaHoaDon varchar(10) NOT NULL,
	MaPhongTro varchar(10),
	ChiSoDienCu float,
	ChiSoDienMoi float,
	ChiSoNuocCu float,
	ChiSoNuocMoi float,
--DonGiaPhong float, --đơn giá 1 tháng ( ko cần vì kết với bảng phòng rồi , giá như nhau )
	TongTien float,
	KyThanhToan nvarchar(100),
	TrangThai nvarchar(100),
	Constraint PK_HOADON PRIMARY KEY (MaHoaDon),
	Constraint FK_HOADON_PHONGTRO FOREIGN KEY (MaPhongTro) REFERENCES PHONGTRO(MaPhongTro)
)

CREATE TABLE LOAIBAIDANG
(
	MaLoaiBaiDang INT IDENTITY(1,1) NOT NULL,
	TenLoaiBaiDang nvarchar(100),
	TrangThai BIT,
	Constraint PK_LOAIBAIDANG PRIMARY KEY (MaLoaiBaiDang)
)
GO
CREATE TABLE DANHMUCDIADIEM
(
	MaDiaDiem INT IDENTITY(1,1) NOT NULL,
	TenDiaDiem nvarchar(100),
	TrangThai BIT,
	Constraint PK_DANHMUCDIADIEMBAIDANG PRIMARY KEY (MaDiaDiem)
)
GO
CREATE TABLE BAIDANG
(
	IDBaiDang INT IDENTITY(1,1) NOT NULL,
	MaLoaiBaiDang INT NOT NULL,
	MaDiaDiem INT,
	TieuDeBaiDang nvarchar(100),
	NoiDungBaiDang NTEXT,
	HinhAnh varchar(50),
	MaChuNha varchar(10),
	ThoiGianDang date,
	TrangThai BIT,
	Constraint PK_BAIDANG PRIMARY KEY(IDBaiDang),
	Constraint FK_BAIDANG_CHUPHONGTRO FOREIGN KEY (MaChuNha) REFERENCES CHUNHATRO(MaChuNha),
	Constraint FK_BAIDANG_LOAIBAIDANG FOREIGN KEY (MaLoaiBaiDang) REFERENCES LOAIBAIDANG(MaLoaiBaiDang),
	Constraint FK_BAIDANG_DMDiaDiem FOREIGN KEY (MaDiaDiem) REFERENCES DANHMUCDIADIEM(MaDiaDiem)
)
GO
--Tạo mối quan hệ 1 hợp đồng có nhiều khách hàng
alter table KHACHHANG
ADD Constraint FK_KHACHHANG_HOPDONG FOREIGN KEY (MaHopDong) REFERENCES HOPDONG (MaHopDong)

--function
GO 
CREATE FUNCTION fn_PhanQuyen(@idGR INT)
RETURNS TABLE
AS
	RETURN SELECT ID, TENMH, COQUYEN
	FROM DM_MANHINH MH LEFT JOIN QL_PHANQUYEN PQ
		ON MH.ID = PQ.ID_MH AND ID_NHOM = @idGR
GO
GO

--drop FUNCTION func_PhanQuyen 
-------------------------------------DATA----------------------------------------

--MÀN HÌNH
INSERT DM_MANHINH VALUES ('MAMH01', N'Phân Quyền') --ADMIN
INSERT DM_MANHINH VALUES ('MAMH02', N'Quản Lý Tài Khoản') --ADMIN
INSERT DM_MANHINH VALUES ('MAMH03', N'Quản Lý Nhóm Người Dùng') --ADMIN
INSERT DM_MANHINH VALUES ('MAMH04', N'Thêm Người Dùng Vào Nhóm') --ADMIN
INSERT DM_MANHINH VALUES ('MAMH05', N'Quản Lý Màn Hình') --ADMIN 
INSERT DM_MANHINH VALUES ('MAMH06', N'Quản Lý Phòng Trọ') --ADMIN --KHÁCH HÀNG
INSERT DM_MANHINH VALUES ('MAMH07', N'Quản Lý Khách Hàng') --ADMIN --KHÁCH HÀNG
INSERT DM_MANHINH VALUES ('MAMH08', N'Lập Hợp Đồng') --KHÁCH HÀNG
INSERT DM_MANHINH VALUES ('MAMH09', N'Thanh Toán') --KHÁCH HÀNG
INSERT DM_MANHINH VALUES ('MAMH10', N'Quản Lý Hóa Đơn') --KHÁCH HÀNG
INSERT DM_MANHINH VALUES ('MAMH11', N'Doanh Thu Cả Tháng') --KHÁCH HÀNG
INSERT DM_MANHINH VALUES ('MAMH12', N'Doanh Thu Cả Năm') --KHÁCH HÀNG

--TÀI KHOẢN
INSERT TAIKHOAN VALUES ('TK01','admin', '123456')
INSERT TAIKHOAN VALUES ('TK02','chunhatro01', '123')
INSERT TAIKHOAN VALUES ('TK03','chunhatro02', '123')
INSERT TAIKHOAN VALUES ('TK04','chunhatro03', '123')
INSERT TAIKHOAN VALUES ('TK05','chunhatro04', '123')
INSERT TAIKHOAN VALUES ('TK06','chunhatro05', '123')
INSERT TAIKHOAN VALUES ('TK07','chunhatro06', '123')

--NHÓM NGƯỜI DÙNG
INSERT QL_NHOMNGUOIDUNG VALUES(N'ADMIN', '00')
INSERT QL_NHOMNGUOIDUNG VALUES(N'CHUNHATRO', '01')

--QUẢN LÝ NGƯỜI DÙNG NHÓM NGƯỜI ĐÙNG
INSERT QL_NGUOIDUNGNHOMNGUOIDUNG VALUES (1, 'TK01')
INSERT QL_NGUOIDUNGNHOMNGUOIDUNG VALUES (2, 'TK02')
INSERT QL_NGUOIDUNGNHOMNGUOIDUNG VALUES (2, 'TK03')
INSERT QL_NGUOIDUNGNHOMNGUOIDUNG VALUES (2, 'TK04')
INSERT QL_NGUOIDUNGNHOMNGUOIDUNG VALUES (2, 'TK05')
INSERT QL_NGUOIDUNGNHOMNGUOIDUNG VALUES (2, 'TK06')
INSERT QL_NGUOIDUNGNHOMNGUOIDUNG VALUES (2, 'TK07')

--PHÂN QUYỀN CỦA ADMIN
INSERT QL_PHANQUYEN VALUES (1, 'MAMH01', 1)
INSERT QL_PHANQUYEN VALUES (1, 'MAMH02', 1)
INSERT QL_PHANQUYEN VALUES (1, 'MAMH03', 1)
INSERT QL_PHANQUYEN VALUES (1, 'MAMH04', 1)
INSERT QL_PHANQUYEN VALUES (1, 'MAMH05', 1)
INSERT QL_PHANQUYEN VALUES (1, 'MAMH06', 1)
INSERT QL_PHANQUYEN VALUES (1, 'MAMH07', 1)
INSERT QL_PHANQUYEN VALUES (1, 'MAMH08', 0)
INSERT QL_PHANQUYEN VALUES (1, 'MAMH09', 0)
INSERT QL_PHANQUYEN VALUES (1, 'MAMH10', 0)
INSERT QL_PHANQUYEN VALUES (1, 'MAMH11', 0)
INSERT QL_PHANQUYEN VALUES (1, 'MAMH12', 0)

--PHÂN QUYỀN CHO CHỦ NHÀ TRỌ
INSERT QL_PHANQUYEN VALUES (2, 'MAMH01', 0)
INSERT QL_PHANQUYEN VALUES (2, 'MAMH02', 0)
INSERT QL_PHANQUYEN VALUES (2, 'MAMH03', 0)
INSERT QL_PHANQUYEN VALUES (2, 'MAMH04', 0)
INSERT QL_PHANQUYEN VALUES (2, 'MAMH05', 0)
INSERT QL_PHANQUYEN VALUES (2, 'MAMH06', 1)
INSERT QL_PHANQUYEN VALUES (2, 'MAMH07', 1)
INSERT QL_PHANQUYEN VALUES (2, 'MAMH08', 1)
INSERT QL_PHANQUYEN VALUES (2, 'MAMH09', 1)
INSERT QL_PHANQUYEN VALUES (2, 'MAMH10', 1)
INSERT QL_PHANQUYEN VALUES (2, 'MAMH11', 1)
INSERT QL_PHANQUYEN VALUES (2, 'MAMH12', 1)

--THÔNG TIN TÀI KHOẢN
SET DATEFORMAT DMY
INSERT THONGTINTAIKHOAN VALUES ('ID01', N'NGUYỄN GIA HUY', '01/11/1969', N'NAM', '0984729914', N'TP.HCM', 'TK01')
INSERT THONGTINTAIKHOAN VALUES ('ID02', N'TRẦN HUỆ MẪN', '02/08/1970', N'NỮ', '0984728815', N'TP.HCM', 'TK02')
INSERT THONGTINTAIKHOAN VALUES ('ID03', N'NGUYỄN HẢI ĐĂNG', '22/12/1968', N'NAM', '0984727716', N'TP.HCM', 'TK03')
INSERT THONGTINTAIKHOAN VALUES ('ID04', N'NGUYỄN THÚY VY', '04/10/1969', N'NỮ', '0984726612', N'TP.HCM', 'TK04')
INSERT THONGTINTAIKHOAN VALUES ('ID05', N'TRẦN TUẤN VỸ', '11/05/1970', N'NAM', '0984725514', N'TP.HCM', 'TK05')
INSERT THONGTINTAIKHOAN VALUES ('ID06', N'NGUYỄN KIM NGÂN', '08/03/1968', N'NỮ', '0984724411', N'TP.HCM', 'TK06')
INSERT THONGTINTAIKHOAN VALUES ('ID07', N'TRẦN GIA BẢO', '26/01/1969', N'NAM', '0984723317', N'TP.HCM', 'TK07')

--CHỦ NHÀ TRỌ
INSERT CHUNHATRO VALUES ('CHUNHA01', N'TRẦN HUỆ MẪN', N'NỮ', N'KẾ TOÁN', N'Quận 10', N'TP.HCM','079301039198', '0984728815', 'mantr@gmail.com', 'TK02')
INSERT CHUNHATRO VALUES ('CHUNHA02', N'NGUYỄN HẢI ĐĂNG', N'NAM', N'LẬP TRÌNH VIÊN', N'Quận Bình Tân', N'TP.HCM','079301039196', '0984727716', 'dangng@gmail.com', 'TK03')
INSERT CHUNHATRO VALUES ('CHUNHA03', N'NGUYỄN THÚY VY', N'NỮ', N'KINH DOANH', N'Quận Tân Phú', N'TP.HCM','079301039176', '0984726612', 'vyng@gmail.com', 'TK04')
INSERT CHUNHATRO VALUES ('CHUNHA04', N'TRẦN TUẤN VỸ', N'NAM', N'BÁC SĨ', N'Quận 11', N'TP.HCM','079301039188', '0984725514', 'vytr@gmail.com', 'TK05')
INSERT CHUNHATRO VALUES ('CHUNHA05', N'NGUYỄN KIM NGÂN', N'NỮ', N'GIÁO VIÊN', N'Quận Tân Phú', N'TP.HCM','079301039154', '0984724411', 'nganng@gmail.com', 'TK06')
INSERT CHUNHATRO VALUES ('CHUNHA06', N'TRẦN GIA BẢO', N'NAM', N'KINH DOANH', N'Quận Tân Bình', N'TP.HCM','079301039146', '0984723317', 'baotr@gmail.com', 'TK07')

--LOẠI PHÒNG
INSERT LOAIPHONG VALUES (1, N'PHÒNG CHO 2 NGƯỜI')
INSERT LOAIPHONG VALUES (2, N'PHÒNG CÓ GÁC')
INSERT LOAIPHONG VALUES (3, N'PHÒNG TRỌ BÌNH DÂN')
INSERT LOAIPHONG VALUES (4, N'PHÒNG TRỌ CAO CẤP')
--Danh Mục Địa Điểm
GO
INSERT dbo.DANHMUCDIADIEM
        ( TenDiaDiem, TrangThai )
VALUES  ( N'HCM, Quận 1', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận 2', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận 3', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận 4', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận 5', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận 6', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận 7', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận 8', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận 9', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận 10', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận 11', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận 12', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận Tân Bình', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận Tân Phú', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Quận Gò Vấp', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Hóc Môn', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Bình Chánh', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HCM, Thủ Đức', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'DN, Quận Hải Châu', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'DN, Quận Thanh Khê', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'DN, Quận Sơn Trà', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'DN, Quận Liên Chiểu', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'DN, Quận Ngũ Hành Sơn', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'DN, Quận Cẩm Lệ', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'DN, Quận Hải Châu', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Ba Đình', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Bắc Từ Liêm', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Cầu Giấy', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Đống Đa', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Hà Đông', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Hai Bà Trưng', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Hoàn Kiếm', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Hoàn Mai', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Long Biên', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Nam Từ Liên', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Tây Hồ', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          ),( N'HN, Quận Thanh Xuân', -- TenDiaDiem - nvarchar(100)
          1  -- TrangThai - bit
          )
GO
--Loai Bai Dang
INSERT dbo.LOAIBAIDANG
        ( TenLoaiBaiDang ,
          TrangThai
        )
VALUES  ( N'Cho thuê phòng trọ' , -- TenLoaiBaiDang - nvarchar(100)
          1  -- TrangThai - bit
        ),( N'Cho thuê nhà nguyên căn' , -- TenLoaiBaiDang - nvarchar(100)
          1  -- TrangThai - bit
        ),( N'Cho thuê căn hộ' , -- TenLoaiBaiDang - nvarchar(100)
          1  -- TrangThai - bit
        )
GO
-- Bai Dang
INSERT dbo.BAIDANG
        ( MaLoaiBaiDang ,
          MaDiaDiem ,
          TieuDeBaiDang ,
          NoiDungBaiDang ,
          HinhAnh ,
          MaChuNha ,
          ThoiGianDang ,
          TrangThai
        )
VALUES  ( 1 , -- MaLoaiBaiDang - int
          1 , -- MaDiaDiem - int
          N'Phòng trọ full nội thất, mới đẹp, hẻm 39 Nguyễn Trãi Quận 1, Ngay ngã sáu phù đổng' , -- TieuDeBaiDang - nvarchar(100)
          N'Cho thuê phòng đẹp ngay trung tâm quận 1, liền kề trường ĐẠI HỌC HOA SEN (HSU), đầy đủ tiện nghi, Full nội thất.
=> Vị trí: 39/7 Nguyễn Trãi, Phường Bến Thành, Quận 1.
* Còn phòng trống, có thể chuyển vào ở ngay. có phòng 1 phòng ngủ, CHDV 2 phòng ngủ. Phòng ngủ kèm phòng khách xịn sò tầng lửng.
* Diện tích 20 - 30m2.
+ Nội thất cao cấp đầy đủ: Giường, tủ áo, nệm, máy lạnh, tủ lạnh. bàn, ghế, sofa, bếp.
=> Tiện ích:
+ Liền kề Trường Đại học Hoa Sen. Đi bộ vài bước là đến.
+ Gần Chợ Bến Thành.
+ Đối diện Zen Plaza.
+ Gần tòa nhà AB.
+ Gần Phố Tây Bùi Viện.
+ Gần công viên 23/9.
+ Có máy giặt, máy sấy.
+ Có trang bị sẵn máy lạnh, máy nước nóng.
+ Có camera quan sát quanh nhà 24/24, đảm bảo an ninh. ra vào bằng thẻ từ.
+ Tự do giờ giấc - không chung chủ, môi trường sống hiện đại - văn minh lịch sự.
Giá phòng 5tr - 8.5tr / tháng ( HĐ 6 tháng cọc 1 tháng / HĐ 12 tháng cọc 1,5 tháng )
Đặc biệt : Giảm 1 tháng tiền nhà khi thanh toán trước 12 tháng, Có hỗ trợ thanh toán trả góp qua thẻ tín dụng khi thanh toán trước 12 tháng tiền nhà.
Có phòng ngắn hạn từ 1-3 tháng.
Để xe Free, để xe tại tầng trệt rất thuận tiện. (1 phòng tối đa 2 xe free),' , -- NoiDungBaiDang - nvarchar(500)
          'phongtro1Q1.jpg' , -- HinhAnh - varchar(50)
          'CHUNHA01' , -- MaChuNha - varchar(10)
          GETDATE() , -- ThoiGianDang - date
          1  -- TrangThai - bit
        ),( 1 , -- MaLoaiBaiDang - int
          2 , -- MaDiaDiem - int
          N'Nhà trọ cao cấp Nhật Quang 2' , -- TieuDeBaiDang - nvarchar(100)
          N'Cách Mặt tiền Đường Nguyễn Duy Trinh 30m – Gần Nguyễn Thị Định Giao Với Nguyễn Duy Trinh
Địa chỉ: Số 120 Đường số 6 phường Bình Trưng Tây Quận 2, TPHCM.
Liền kề Đô Thị Thủ Thiêm, chỉ cách quận 1 chưa đầy 7 km.
Liền kề đại lộ Đông Tây, cao tốc TpHCM – Long Thành.
Nằm giữa trung tâm Quận 2, được bao quanh bởi những đường giao thông huyết mạch, khu dân cư hiện đại bậc nhất Sài Thành. Mang đến cho cư dân những dịch vụ tiện ích hiện đại.
Từ đây, Qúy khách dễ dàng di chuyển thuận tiện về:
• Quận 1 và Quận 3, Quận 4 chỉ 10 Phút Qua Hầm Thủ Thiên - Mai Chí Thọ - Nguyễn Thị Định - Nguyễn Duy Trinh
• Quận Bình Thạnh, Hàng xanh chưa đến 10 phút qua Cầu thủ Thiêm - Lương Định Của - Nguyễn Thị Định - Nguyễn Duy Trinh
• Khu vực Quận 9 - Thủ Đức, Xa lộ Hà Nội cũng chỉ mất 10 Phút theo Đại lộ Mai Chí Thọ
• Đồng Nai, Vũng Tàu nhanh chóng theo tuyến đường Cao Tốc Long Thành Dầu Dây.
Cách các tiện ích trường học, bệnh viện, siêu thị: bán kính 2km.
- Phòng mới xây 100% bạn là người đầu tiên sử dụng, tiện nghi mới 100%.
- Diện tích mỗi phòng từ 25m2 đến 35m2 có tầng lửng đúc bê tông cho bạn không gian sống riêng tư cho dù bạn là gia đình nhỏ hay nhóm bạn ở chung chúng tôi không hạn chế số người ở bạn tự do chia sẻ chi phí.
- Khu vực an ninh, yên tĩnh, sang trọng, đẳng cấp.
- Thang máy cho bạn di chuyển dễ dàng.
- Có bãi gửi xe riêng cho không gian sống them rộng mở.
- Bảo vệ an ninh 24/7 bảo đảm cho bạn và tài sản của bạn.
- Hệ thống PCCC hiện đại.
- Dịch vụ linh hoạt tùy thuộc vào nhu cầu của bạn.
- Mỗi phòng đều có khu vực nấu ăn riêng được ốp gạch men cao cấp sạch sẽ.
- Không gian RIÊNG TƯ, YÊN TĨNH, TỰ DO, không bị ai làm phiền.
- Bạn được TỰ DO TIẾP KHÁCH người thân, bạn bè.
- Vệ sinh sạch sẽ không gian sử dụng chung 24/7' , -- NoiDungBaiDang - nvarchar(500)
          'phongtro2Q2.jpg' , -- HinhAnh - varchar(50)
          'CHUNHA02' , -- MaChuNha - varchar(10)
          GETDATE() , -- ThoiGianDang - date
          1  -- TrangThai - bit
        ),( 1 , -- MaLoaiBaiDang - int
          3 , -- MaDiaDiem - int
          N'Cho thuê phòng trọ quận 3, full nội thất, giờ tự do, an ninh, gần công viên Lê Thị Riêng' , -- TieuDeBaiDang - nvarchar(100)
          N'Phòng thoáng mát, yên tĩnh, an ninh, giờ giấc tự do, sạch sẽ, thoáng mát.
Ngay Quận 3, cách chợ Hòa Hưng 200m, chạy ra bờ kè 5p. Phòng rộng 25m2 sạch sẽ, được trang bị tiện nghi, các thiết bị hiện đại, tiết kiệm điện nước tối đa, đồng hồ riêng biệt.
Nội Thất Gồm: Tủ Lạnh, Máy Lạnh, Giường Nệm, Tủ Đồ, Nước Nóng Năng Lượng Mặt Trời, Kệ Bếp,..
Địa chỉ: 472/48 Cách Mạng Tháng 8, P11, Q3.
Giá thuê: 4.9tr; 5.4tr' , -- NoiDungBaiDang - nvarchar(500)
          'phongtro1Q3.jpg' , -- HinhAnh - varchar(50)
          'CHUNHA03' , -- MaChuNha - varchar(10)
          GETDATE() , -- ThoiGianDang - date
          1  -- TrangThai - bit
        )