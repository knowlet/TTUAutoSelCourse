source config.sh
test -f sbj.txt && echo "sbjFile Found" || (echo "File Not Found" && exit 1)
source login.sh

login
while true; do
    curl -skA "$UA" "$domain/menu/seltop.php" -b ./Cookie.txt > /dev/null
    selDeny=$(curl -skA "$UA" "$domain/selcourse/ListClassCourse.php" -b ./Cookie.txt -c ./Cookie.txt | grep 'DoAddDelSbj' | wc -l)
    if [ $selDeny -ge 1 ]; then
        while read sbj; do
            if [[ $sbj =~ ^[A-Z][0-9A-Z]{4,5} ]]; then
                echo "Sbj ${BASH_REMATCH[0]} processing..."
                result=$(curl -L -skA "$UA" --referer "$domain/selcourse/ListClassCourse.php" "$domain/selcourse/DoAddDelSbj.php?AddSbjNo=${BASH_REMATCH[0]}" -b ./Cookie.txt | iconv -f big5 -t utf8)
                msg=$(echo $result | grep -o "alert(.*);" | sed "s/[alert('');]//g")
                echo $msg
            fi
        done < sbj.txt
        sleep 5
    else
        echo "Select Deny, wait 15 sec."
        sleep 15
    fi
done
