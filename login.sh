function login()
{
    loginResult=$(curl -skA "$UA" -d $loginParams $loginUrl -c ./Cookie.txt | grep 'stumain.php' | wc -l)
    if [ $loginResult -eq 1 ]; then
        echo "User $ID Login Success!!!";
    else
        echo "Error! Please check your password?"
        exit 1
    fi
}
