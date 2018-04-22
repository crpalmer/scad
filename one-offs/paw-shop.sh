is_big=1
O=paw-shop

if [ "$1" == --small ]
then
    is_big=0
    O=$O/small
fi

for letter in P A W S H O
do
    for which in 0 1 2 3
    do
	echo "Generating $letter-$which"
        openscad -o $O/$letter-$which.stl -Dletter='"'$letter'"' -Dwhich=$which -Dis_big=$is_big ./paw-shop.scad
    done
done
