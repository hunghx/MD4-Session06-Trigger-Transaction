create database bank;
use bank;
create table accounts(
id int primary key auto_increment,
name varchar(50),
balance double ,
createdDate date 
);
select "2023-08-03" > curdate() ;
insert into accounts(name , balance) values("hunghx",1000,"2023-08-03"),("Namtx",500,"2023-08-03");

-- thực hiện 1 procedure chuyển tiền từ tài khoản này sang tài khoản khác 
-- id người nhận, id người gửi, số tiền muốn chuyển
-- 2 thao tác: trừ tiền tài khoản gửi và cộng  tiền tài khoản nhận 
delimiter //
create procedure PROC_SEND_MONEY (idSender int, idReceiver int,cost double)
begin
-- khối code logic
-- trừ tiền tài khoản gửi 
declare balanceSender double;
Select balance into balanceSender from accounts where id = idsender;
if balanceSender >= cost then 
	begin 
		Update accounts set balance = balance - cost where id = idSender;
		-- cọng tiền tài khoản nhận 
		Update accounts set balance = balance + cost where id = idReceiver;
	end;
end if;
end // 

call PROC_SEND_MONEY(1,3,100);


-- Cú pháp tạo trigger - trình tự kích hoạt khi có sự thay đổi dữ liệu
Create trigger Before_Insert_Accounts 
before insert on accounts for each row
begin
	-- Bảng NEW 
   if New.balance < 0 then
		signal sqlstate '45000' set MESSAGE_TEXT ='Số dư không thể  < 0';
    elseif New.createdDate < curdate() then
		signal sqlstate '45000' set MESSAGE_TEXT ='Ngày mở thẻ khôg thể trước ngày hiện tại';
	else
    end if;
end;


use bank;
Create trigger Before_Insert_Accounts
    before insert on accounts for each row
begin
    -- Bảng NEW, OLD
    if New.balance < 0 then
        signal sqlstate '45000' set MESSAGE_TEXT ='Số dư không thể  < 0';
    elseif New.createdDate < curdate() then
        signal sqlstate '45000' set MESSAGE_TEXT ='Ngày mở thẻ khôg thể trước ngày hiện tại';
    end if;
end;

insert into  accounts( name, balance, createddate) values ('hunghx',1000,'2023-08-03');
-- taoj trigger không cho phép xóa taì khoản có id = 1

Create trigger Before_Delete_Accounts
    before delete on accounts for each row
begin
    if old.id = 1 then
        signal sqlstate '45000' set MESSAGE_TEXT ='Không thể xóa tài khoản nay';
    end if;
end;

delete from accounts where id = 1;

#  Viết trigger khi người dùng thêm mới hoăc cập nhật dữ liệu
#  của bảng khách hàng thì sdt phải >=10 <=11 kí tự (4 trigger )
# use quanlybanhang;
# create trigger before_insert_khachhang
# before  insert  on khachhang for each row
#     begin
#         if length(NEW.sodt) <10 or  length(NEW.sodt)>11 then
#             signal sqlstate '45000' set message_text = 'SDT khong hop le';
#         end if;
#     end;
# create trigger after_insert_khachhang
# after  insert  on khachhang for each row
#     begin
#         if length(NEW.sodt) <10 or  length(NEW.sodt)>11 then
#             signal sqlstate '45000' set message_text = 'SDT khong hop le';
#         end if;
#     end;
#
# insert into khachhang values ('KH09','Hung HX','Ha Noi','1999-6-18','00187288');
#
# create trigger after_update_khachhang
#     after update on khachhang for each row
#     begin
#         if length(NEW.sodt) <10 or  length(NEW.sodt)>11 then
#             signal sqlstate '45000' set message_text = 'SDT khong hop le';
#         end if;
#     end;

use bank;

delimiter //
create procedure PROC_SEND_MONEY (idSender int, idReceiver int,cost double)
begin
    -- khối code logic
-- trừ tiền tài khoản gửi
    declare balanceSender double;
    declare idCheck int;
    Select balance into balanceSender from accounts where id = idsender;
    if balanceSender >= cost then
        begin
            start transaction ;
            Update accounts set balance = balance - cost where id = idSender;
            -- cọng tiền tài khoản nhận
            SELECT id into idCheck from accounts where id = idReceiver;
            if idCheck is null then
                rollback ;
            end if ;
            Update accounts set balance = balance + cost where id = idReceiver;
            commit ;
        end;
    end if;
end //
call PROC_SEND_MONEY(1,2,100);


