#!./bash
hostname="localhost"
username="root"
password="1234"
dbname="linux"
tbname="word"
exit="false"

function wordGame() {
read -p "请输入开始字符:" char
flag="true"
while [ "$flag" == "true" ]
	do
		echo "当前字符串为 : ${char}"
		echo -e "\n"
		temp="${char}"
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
			read -n 1 -p "是否查看上一次匹配单词[Y/N]:" bool 
			echo -e "\n"
			if [ "${bool}" == "Y" ]
				then
				sql="select words from cetsix where words like '${temp}%' limit 1;"
				echo `mysql -h ${hostname} -u ${username} -p${password} ${dbname} -e "${sql}" > 2.txt`
				res=`sed -n 2p 2.txt`
				echo "上一个匹配的单词之一为:${res}"
				echo -e "\n"
			fi
		fi		 
	done
}

function getAllWords() {
	
	sql="select * from cetsix;"
	echo `mysql -h ${hostname} -u ${username} -p${password} ${dbname} -e "${sql}" > allWords.txt`
	pwd=`pwd`
	echo "保存至${pwd}/allWords.txt"
	echo -e "\n"

}

function getWordsBegin() {
	read -p "请输入开始的字母:" begin
	sql="select * from cetsix where words like '${begin}%';"
	echo `mysql -h ${hostname} -u ${username} -p${password} ${dbname} -e "${sql}" > wordsBegin.txt`
	pwd=`pwd`
	echo "保存至${pwd}/wordsBegin.txt"
	echo -e "\n"
}

function getWordsInclude() {
	read -p "请输入要包含的字母:" include
	sql="select * from cetsix where words like '%${include}%';"
	echo `mysql -h ${hostname} -u ${username} -p${password} ${dbname} -e "${sql}" > wordsInclude.txt`
	pwd=`pwd`
	echo "保存至${pwd}/wordsInclude.txt"
	echo -e "\n"
}

function random() {
	min=1
	sql="select count(*) from cetsix;"
	echo `mysql -h ${hostname} -u ${username} -p${password} ${dbname} -e "${sql}" > 3.txt`
	count=`sed -n 2p 3.txt`
	max=${count}
	num=$(date +%s%N)
	echo $(($num%$max+$min))
}

function getWordById() {
	id=$1
	echo $id
	sql="select words from cetsix where ID = ${id};"
	echo `mysql -h ${hostname} -u ${username} -p${password} ${dbname} -e "${sql}" > 4.txt`
	sql2="select meaning from cetsix where ID = ${id};"
	echo `mysql -h ${hostname} -u ${username} -p${password} ${dbname} -e "${sql2}" >> 4.txt`
}

function wordCompletion() {
	rnd=$(random)
	getWordById $rnd
	echo -e "\n"
	word=`sed -n 2p 4.txt`
	length=${#word}
	meaning=`sed -n 4p 4.txt`
	echo -e "此单词的意思是:${meaning}"
	echo -e "此单词长度为:${length}"
	read -p "请输入这个单词:" danci
	
	if [ "${danci}" == "${word}" ]
		then
		echo -e "答案正确！你真棒！\n"
	else
		echo "啊哦，答案错误"
		read -n 1 -p "是否需要一点点提示?[Y/N]:" tishi		
		if [ "${tishi}" == "Y" ]
			then
			ll=$(( $length/2 + 1 ))
			ww=${word:0:$ll}
			echo -e "\n"
			echo -e "前缀为:${ww}\n"
			read -p "请按照提示补全单词:" completion
			if [ "${completion}" == "${word}" ]
				then
				echo -e "答对了，恭喜你！\n"
			else
				echo "啊哦，又错了！"
				echo -e "正确答案是:${word}\n"
				pwd=`pwd`
				echo "我们已将答错的单词保存至${pwd}/error.txt,还请您经常复习!!!"
				echo `echo ${word} : ${meaning} >> error.txt`
			fi
		fi
		if [ "${tishi}" == "N" ]
			then
			echo -e "你需要多一点耐心嘞！\n"
			echo -e "答案为:${word}\n"
			pwd=`pwd`
                        echo "我们已将答错的单词保存至${pwd}/error.txt,还请您经常复习!!!"
                        echo `echo ${word} : ${meaning} >> error.txt`
		fi
	fi

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
	echo -e "\n"

read -p "please choose a number : " num
case $num in
	1)
	getAllWords
	;;
	2)
	getWordsBegin
	;;
	3)
	getWordsInclude
	;;
	4)
	wordGame
	;;
	5)
	wordCompletion
	;;
	6)
	exit="true"
	;;
esac
done

