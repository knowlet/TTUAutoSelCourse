# source config.sh
test -f sbj.txt && echo "sbjFile Found" || (echo "File Not Found" && exit 1)
source countdown.sh
# source login.sh
source test.sh

function isLogin()
{
    if [ `echo $1 | grep "Not login or session expire!" | wc -l` -eq 1 ]; then
        echo "Not login or session expire!";
        login
    else
        echo "Login Checked."
    fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    startTime=$(gdate -d "$TIME" "+%s")
else
    startTime=$(date -d "$TIME" "+%s")
fi
countdown $(($startTime-15))
# run 2 mins
runTime=$((60 * 2))
login
while [[ $(($(date "+%s")-$startTime)) -lt $runTime ]]; do
    curl -skA "$UA" "$domain/menu/seltop.php" -b ./Cookie.txt -c ./Cookie.txt > /dev/null
    result=`curl -skA "$UA" "$domain/selcourse/ListClassCourse.php" -b ./Cookie.txt`
    isLogin "$result"
    selDeny=`echo $result | grep 'DoAddDelSbj' | wc -l`
    if [ $selDeny -ge 1 ]; then
        count=0; chose=0;
        while read sbj; do
            if [[ $sbj =~ ^[A-Z][0-9A-Z]{4,5} ]]; then
                echo "Sbj ${BASH_REMATCH[0]} processing..."
                result=$(curl -L -skA "$UA" --referer "$domain/selcourse/ListClassCourse.php" "$domain/selcourse/DoAddDelSbj.php?AddSbjNo=${BASH_REMATCH[0]}" -b ./Cookie.txt | iconv -f big5 -t utf8)
                msg=$(echo $result | grep -o "alert(.*);" | sed "s/[alert('');]//g")
                echo $msg
                if [ -n $msg ]; then ((chose++)); fi
                ((count++))
                isLogin "$result"
            fi
        done < sbj.txt
        if [ $chose -eq $count ]; then echo "All done."; exit 0; fi
        sleep 3
    else
        echo "Select Deny, wait a sec."
        sleep 1
    fi
done
