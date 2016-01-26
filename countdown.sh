function countdown()
{
	while [[ $(($1-$(date "+%s"))) -ge 0 ]]; do
		echo -e "\r$(($1-$(date "+%s")))\c"
		sleep 1
	done
}
# Usage: countdown 1407295200
[ "$#" -eq 1 ] && countdown $1
