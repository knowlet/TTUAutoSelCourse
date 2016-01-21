source config.sh
test -f sbj.txt && echo "sbjFile Found" || (echo "File Not Found" && exit 1)
source countdown.sh

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
# run 2 mins
runTime=$((60 * 2))
while [[ $(($(date "+%s")-$startTime)) -lt $runTime ]]; do
    login
    curl -sA "$UA" "$domain/menu/seltop.php" -b ./Cookie.txt > /dev/null
    selDeny=$(curl -sA "$UA" "$domain/selcourse/ListClassCourse.php" -b ./Cookie.txt | grep 'DoAddDelSbj' | wc -l)
    if [ $selDeny -ge 1 ]; then
        while read sbj; do
            sbj=$(echo $sbj | grep -o "^[A-Z]\w\+")
            if [[ $sbj =~ ^[A-Z] ]]; then
                echo "Sbj $sbj processing..."
                result=$(curl -L -sA "$UA" --referer "$domain/selcourse/ListClassCourse.php" "$domain/selcourse/DoAddDelSbj.php?AddSbjNo=$sbj" -b ./Cookie.txt | iconv -f big5 -t utf8)
                msg=$(echo $result | grep -o "alert(.*);" | sed "s/[alert('');]//g")
                echo $msg
            fi
        done < sbj.txt
        echo "done, wait 3 sec.."
        sleep 3
    else
        echo "Select Deny, wait 15 sec."
        sleep 15
    fi
done