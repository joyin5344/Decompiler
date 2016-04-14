
sign()
{
    echo -n "----------sign---------- "
    echo $1
	libdir=~/lib/apktool_sign/
    java -jar ${libdir}signapk.jar ${libdir}testkey.x509.pem ${libdir}testkey.pk8 $1 update_signed.zip
    mv update_signed.zip $2
    echo -n "------sign done!!!------ "
    echo $2
    echo
}

sign_from_current_path()
{
    dir="*.apk"
    echo
    echo $dir
    
    echo
    echo -n "choose an apk file: "
    read which_apk
    
    flag=0
    for tmp in $dir
    do
        if [ $tmp = $which_apk ]; then
            sign $which_apk ${which_apk}_sign.apk
            flag=1
        fi
    done
    
    if [ $flag = 0 ]; then
        echo "Error: input file not found"
    fi

}

if [ $# = 0 ]; then
    sign_from_current_path
elif [ $# = 1 ]; then
    sign $1 ${1}_sign.apk
elif [ $# = 2 ]; then
    sign $1 $2
fi
