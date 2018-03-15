is_big=1

for letter in P A W S H O
do
    for which in 0 1
    do
	echo "Generating $letter-$which"
        openscad -o paw-shop/$letter-$which.stl -Dletter='"'$letter'"' -Dwhich=$which -Dis_big=$is_big ./paw-shop.scad
    done
done
