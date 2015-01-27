function countdown()
{
	if [ $(($1-$(date "+%s"))) -lt 0 ]; then
		echo "Time Passed!!"
	else
		while [[ $(($1-$(date "+%s"))) -ge 0 ]]; do
			echo "\r$(($1-$(date "+%s")))\c"
			sleep 1
		done
		echo "\rTime UP!"
	fi
}
# Usage: countdown 1407295200
[ "$#" -eq 1 ] && countdown $1