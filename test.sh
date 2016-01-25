source config.sh
source login.sh
login
count=0
while read sbj; do
    if [[ $sbj =~ ^[A-Z][0-9A-Z]{4,5} ]]; then
        echo "Sbj ${BASH_REMATCH[0]} found"
        ((count++))
    fi
done < sbj.txt
echo "Total found $count sbjs"