is_big=1
O=paw-shop

if [ "$1" == --small ]
then
    is_big=0
    O=$O/small
fi

mkdir -p $O

for letter in P A W S H O
do
    echo "Generating guide-$letter.stl"
    openscad -o $O/guide-$letter.stl -Dletter='"'$letter'"' -Dis_big=$is_big -Ddrill_guide=1 ./paw-shop.scad
done
