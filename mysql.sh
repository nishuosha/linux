#!./bash
hostname="localhost"
username="root"
password="1234"
dbname="linux"
tbname="word"
flag="true"
exit="false"

function wordGame() {
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
}

function getAllWords() {
	
	sql="select * from cetsix;"
	echo `mysql -h ${hostname} -u ${username} -p${password} ${dbname} -e "${sql}" > allWords.txt`
	pwd=`pwd`
	echo "保存至${pwd}/allWords.txt"

}

while [ $exit == "false" ]
do
	echo "****************************Welcome To The Word Center************************************************"
	echo "*****************There Are Many Function, You Can Choose One To Play**********************************"
	echo "--------------1,将所有单词输出到文件"
	echo "--------------2,将以输入字母为开始的单词输出到文件"
	echo "--------------3,将包含输入字母的单词输出到文件"
	echo "--------------4,词汇比拼小游戏"
	echo "--------------5,单词补全小游戏"
	echo "--------------6,退出"

read -p "please choose a number : " num
case $num in
	1)
	getAllWords
	;;
	2)
	;;
	3)
	;;
	4)
	;;
	5)
	wordGame
	;;
	6)
	exit="true"
	;;
esac
done

