echo "This program processes video for ORBSLAM2"

if [ -z "$1" ]
then
echo "Usage: video_processor.sh input_video_file"
exit 1
fi

inputname=$1

if [ ! -e "$inputname" ]
then
echo "File not found. Make sure it is in the same folder as video_processor.sh"
exit 1
else
width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=s=x:p=0 $inputname)
height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=s=x:p=0 $inputname)
echo $inputname": "$width"x"$height
fi

echo -n "What would you like the output folder to be called: "
read outputname

mkdir -p $outputname/rgb

echo -n "Choose frames per second. Between 10 and 25 is preferable: "
read fps

if [ $width -lt $height ]
then
echo "The video must be wider than it is high i.e. Landscape"
echo -n "Would you like to rotate it? (y/n) "
read rotchoice
else
rotchoice="n"
fi

echo -n "Do you want to resize the images? (y/n) "
read resize_choice

if [ $resize_choice = "n" ] || [ $resize_choice = "N" ]
then
resize_height=$height

elif [ $resize_choice = "y" ] || [ $resize_choice = "Y" ]
then
echo -n "Choose resize height (width is set automatically to preserve aspect ratio):"
read resize_height

else
    echo "Invalid choice. Choose y/n"
    exit 1
fi

if [ $rotchoice = "n" ] || [ $rotchoice = "N" ]
then
ffmpeg -i $inputname -r $fps -vf scale=-1:$resize_height $outputname/rgb/img%04d.png

elif [ $rotchoice = "y" ] || [ $rotchoice = "Y" ]
then
ffmpeg -i $inputname -r $fps -vf scale=$resize_height:-1,"transpose=1" $outputname/rgb/img%04d.png

else
    echo "Invalid choice. Choose y/n"
    exit 1
fi

#Counts the number of output files
imgnum=$(ls $outputname/rgb | wc -l)

echo "# colour images" > $outputname/rgb.txt
echo "#file: '$outputname'" >> $outputname/rgb.txt
echo "# timestamp filename" >> $outputname/rgb.txt

#Uses bc to calculate timestamp increment to 6 places
#No spaces around =
frameTime=$(echo "scale=6; 1.0/$fps" | bc)
timestamp=0.000000

for i in $(seq -f "%04g" $imgnum)
do
echo $timestamp rgb/img$i.png >> $outputname/rgb.txt
timestamp=$(echo "scale=6; $timestamp+$frameTime" | bc)
done

echo
echo "Your files are ready, and have all been put in a single folder."
echo "Please place this folder in ~/Desktop/ORBSLAM2 datasets/our datasets."
echo
