#!/bin/bash
# ทดสอบ 
# ================================
# เชื่อมต่อ ssh ด้วย Root
cd
# ติดตั้ง Command
apt-get -y install ufw
apt-get -y install sudo

# ติดตั้ง Pritunl โดย เพิ่มแหล่งฐานข้อมูลในไฟล์ sources.list
echo "http://repo.pritunl.com/stable/apt stretch main" > /etc/apt/sources.list.d/pritunl.list
apt-get install dirmngr
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get update
apt-get --assume-yes install pritunl mongodb-server
systemctl start mongodb pritunl
systemctl enable mongodb pritunl

# ติดตั้ง Squid Proxy เวอร์ชั่น 3 โดยการโหลดไฟล์คอนฟิกสำเร็จรูป
apt-get -y install squid3
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/auiyhyo/vps2/master/squid.conf" 
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
service squid3 restart

# เปิด Firewall
sudo ufw allow 22,80,81,222,443,8080,9700,60000/tcp
sudo ufw allow 22,80,81,222,443,8080,9700,60000/udp
sudo yes | ufw enable

# ตั้งจ่าเขตเวลา
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# คำแนะคำเกี่ยวกับการใช้งาน
clear
echo "ปลายยยยแถววววววววว"
echo "Pritunl, Squid Proxy, Firewall ติดตั้งเสร็จและนานสัส"
echo "อันนี้ของ Debian 9 x64 นะมึง"
echo "Shell script โดย ปลายแถว"
echo "ต้นฉบับจากไหนไม่รู้ เดี๋ยวสืบให้"
echo "ก้อปปี้ หรือ กดที่ url เพื่อใช้งาน : https://$MYIP"
echo "ก้อปปี้ คีย์ข้างล่างไว้เอาไว้ใส่หน้าเว็ป"
pritunl setup-key
echo "reboot vps ก่อนจะใช้งานล่ะ เดี๋ยวจะCannot open TUN/TAP dev ตอน start server"
echo ""
rm pridb8.sh
