source config.sh
source countdown.sh
test -f sbj && echo "sbjFile Found" || (echo "File Not Found" && exit 1)

function login()
{
    loginResult=$(curl -sA "$UA" -d $loginParams $loginUrl -c ./Cookie.txt | grep 'stumain.php' | wc -l)
    if [ $loginResult -eq 1 ]; then
        echo "User $ID Login Success!!!";
    else
        echo "Something wrong! \nPlease check your password?"
        exit 1
    fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    startTime=$(gdate -d "$TIME" "+%s")
else
    startTime=$(date -d "$TIME" "+%s")
fi
countdown $startTime
# run 5 mins
runTime=$((60 * 5))
while [[ $(($(date "+%s")-$startTime)) -lt $runTime ]]; do
    login
    curl -sA "$UA" "$domain/menu/seltop.php" -b ./Cookie.txt > /dev/null
    selDeny=$(curl -sA "$UA" "$domain/selcourse/ListClassCourse.php" -b ./Cookie.txt | grep 'DoAddDelSbj' | wc -l)
    if [ $selDeny -ge 1 ]; then
        while read sbj; do
            checkSbj=$(echo $sbj | grep "^[A-Z][0-9]" | wc -l)
            if [ $checkSbj -eq 1 ]; then
                echo "Sbj $sbj processing..."
                result=$(curl -L -sA "$UA" --referer "$domain/selcourse/ListClassCourse.php" "$domain/selcourse/DoAddDelSbj.php?AddSbjNo=$sbj" -b ./Cookie.txt | iconv -f big5 -t utf8)
                msg=$(echo $result | grep -o "alert(.*);" | sed "s/[alert('');]//g")
                echo $msg
            fi
        done < sbj
        echo "done, wait 3 sec.."
        sleep 3
    else
        echo "Select Deny, wait 30 sec."
        sleep 30
    fi
done