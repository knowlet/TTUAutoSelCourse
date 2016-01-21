function myEcho()
{
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e $1
    else
        echo $1
    fi
}
function countdown()
{
	if [ $(($1-$(date "+%s"))) -lt 0 ]; then
		echo "Time Passed!!"
	else
		while [[ $(($1-$(date "+%s"))) -ge 0 ]]; do
			myEcho "\r$(($1-$(date "+%s")))\c"
			sleep 1
		done
		myEcho "\rTime UP!"
	fi
}
# Usage: countdown 1407295200
[ "$#" -eq 1 ] && countdown $1