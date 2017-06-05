#!./bash
hostname="localhost"
username="root"
password="1234"
dbname="linux"
tbname="word"
flag="true"
read -p "请输入开始字符:" char

while [ "$flag" == "true" ]
	do
		echo "当前字符串为 : ${char}"
		read -p "请输入下一个字符:" cc
		char="${char}"$cc
		select="select count(*) from cetsix where words like '${char}%';"
		echo `mysql -h ${hostname} -u ${username} -p${password} ${dbname} -e "${select}" > 2.txt`
		result=`sed -n 2p 2.txt`
		echo "有${result}个匹配"
		if [ "$result" ==  "0" ]
			then 
			flag="false"
			echo "游戏结束，很遗憾，您输了！"
		fi		 

	done

