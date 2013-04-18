#sudo tshark -i eth0 -nn -c 10 -e ip.src -e ip.dst -Tfields -E separator=| > temp1.txt

#sudo tshark -i eth0 -nn -c 10 -Tfields -E separator=$ -R ip >> temp1.tx

#sudo tshark -S -a duration:10 -w del .. gives output in binary

#-e frame.number
## filter for search string google to be used as capture filter - http://www.wireshark.org/tools/string-cf.html
#tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x676f6f67 && tcp[((tcp[12:1] & 0xf0) >> 2) + 4:2] = 0x6c65

sudo tshark -q -z conv,tcp -z conv,udp

sudo tshark -i wlan0 -q -z conv,ip -a duration:20  > dumptemp

sudo tshark -i eth0 -nn -a duration:60 -f "host www.google.com" -e frame.time -e ip.src -e ip.dst -e ip.proto -e ip.len -Tfields -E separator="," > dump

#sudo tshark -i eth0 -nn -a duration:60 -f "port 80" -e frame.time -e ip.src -e ip.dst -e ip.proto -e ip.len -Tfields -E separator="," > dump

#only http GET 
#sudo tshark -i eth0 -nn -a duration:60 -f "tcp[((tcp[12:1] & 0xf0) >> 2):2] = 0x4745 && tcp[((tcp[12:1] & 0xf0) >> 2) + 2:1] = 0x54" -e frame.time -e ip.src -e ip.dst -e ip.proto -e ip.len -Tfields -E separator="," > dump

cut -d "," -f 2,3,4,5,6 dump >dump1

cut -d " " -f 3 dump1 > capture

#mv dump2 capture

rm dump1

/home/kamal/project2_p2psrch/hadoop-1.0.4/bin/hadoop dfs -mkdir input

/home/kamal/project2_p2psrch/hadoop-1.0.4/bin/hadoop dfs -copyFromLocal ~/project/captures/capture input

#run hive

CREATE TABLE captures (frametime STRING,ipsrc STRING,ipdst STRING,ipproto STRING,iplen STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n' STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH './dump2' INTO TABLE captures

#drop table captures
#CREATE TABLE captures (Time STRING, Source STRING, Destination STRING, Protocol STRING, Length STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS TEXTFILE;

#LOAD DATA INPATH '/user/kamal/input/capture' INTO TABLE captures

#rm capture
#/home/kamal/project2_p2psrch/hadoop-1.0.4/bin/hadoop dfs -rmr input

