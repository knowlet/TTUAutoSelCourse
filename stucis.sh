source config.sh
test -f sbj.txt && echo "sbjFile Found" || (echo "File Not Found" && exit 1)
source countdown.sh
source login.sh

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
        count=0; chose=0;
        while read sbj; do
            if [[ $sbj =~ ^[A-Z][0-9A-Z]{4,5} ]]; then
                echo "Sbj ${BASH_REMATCH[0]} processing..."
                result=$(curl -L -sA "$UA" --referer "$domain/selcourse/ListClassCourse.php" "$domain/selcourse/DoAddDelSbj.php?AddSbjNo=${BASH_REMATCH[0]}" -b ./Cookie.txt | iconv -f big5 -t utf8)
                msg=$(echo $result | grep -o "alert(.*);" | sed "s/[alert('');]//g")
                echo $msg
                if [ -n $msg ]; then ((chose++)); fi
                ((count++))
            fi
        done < sbj.txt
        if [ $chose -eq $count ]; then echo "All done."; exit 0; fi
        sleep 3
    else
        echo "Select Deny, wait 15 sec."
        sleep 15
    fi
done