#! /bin/bash

require()
 {
    local program all_ok=1
    for program; do
        if ! type "$program" &>/dev/null; then
            echo "Error: the required program '$program' is not installed or not in PATH"
            all_ok=
        fi
    done
    test "$all_ok" || exit 1
 }

require ffmpeg mktorrent


  #defaults
  INPUT_FOLDER=/mnt/sda1/.../flac2mp3/input #specify input folder
  OUTPUT_FOLDER=/mnt/sda1/.../flac2mp3/output #specify output folder
  DOWN_FOLDER=/mnt/sda1/.../downloads #specify your download folder
  # put your default announce url and required flag by your tracker (match numbers) in array below and delete examples
  ANNOUNCE_URL[1]=https://blue.or.red.pill/de0d769dd8676b32c696d30a911701d/announce # first announce pair will be used as default
  ANNOUNCE_FLAG[1]=CHOICE
  ANNOUNCE_URL[2]=https://planets.uranus/6ce52eade0d769dd8676b32c696d30a9117010fde23/announce
  ANNOUNCE_FLAG[2]=ROSE
  ANNOUNCE_URL[3]=http://tracker.dp.tits/boyonboy.php/b9ee52eade0d769dd8676b32c696d30a9117010fde23f8b6/announce
  ANNOUNCE_FLAG[3]=GB
  ANNOUNCE_URL[8]=http://random.squirt.a2m/eade0d769dd8676b32c696d30a9117010f/announce
  ANNOUNCE_FLAG[8]=CPIE
  ANNOUNCE_URL[69]=http://example.nosourceflag.world/d769dd8676b32c696d30/announce
  ANNOUNCE_FLAG[69]=

  

setenc ()

 {
	clear
	echo " "
	echo " Choose your desired Output now"
	echo " "
	echo " (1) encode to [MP3 320] & [V0] & [V2]"
	echo " (2) encode to [MP3 320] & [V0]"
	echo " (3) encode to [MP3 320] & [V2]"
	echo " (4) encode to [V0] & [V2]"
	echo " (5) encode to [V320]"
	echo " (6) encode to [V0]"
	echo " (7) encode to [V2]"
	echo " (0) skip encoding to mp3"
	echo " "
	read -r -p "choice: " i
	case $i in
		[1])
			s=" -> will encode to [MP3 320] & [V0] & [V2]"
			t320=1
			tv0=1
			tv2=1
			;;
		[2])
			s=" -> will encode to [MP3 320] & [V0]"
			t320=1
			tv0=1
			tv2=0;;
		[3])
			s=" -> will encode to [MP3 320] & [V2]"
			t320=1
			tv0=0
			tv2=1
			;;
		[4])
			s=" -> will encode to [V0] & [V2]"
			t320=0
			tv0=1
			tv2=1
			;;
		[5])
			s=" -> will encode to [MP3 320]"
			t320=1
			tv0=0
			tv2=0
			;;
		[6])
			s=" -> will encode to [V0]"
			t320=0
			tv0=1
			tv2=0
			;;
		[7])
			s=" -> will encode to [V2]"
			t320=0
			tv0=0
			tv2=1;;
		[0])
			s=""
			t320=0
			tv0=0
			tv2=0;;
		*)
			setenc
			;;
	esac
 }
 
copyflac ()

 {
	clear
	echo " "
	echo " (1) copy the original FLACs to output folder"
	echo " (0) skip copying the original FLACs"
	echo " "
	read -r -p "choice: " j	
	case $j in
		[1])
			o=" -> will copy original FLACs to output folder"
			optflac=1;;
		[0])
			o=""
			optflac=0;;
		*)
			copyflac
			;;
	esac
 }

flac2496 ()

 {
	clear
	echo " "
	echo " (1) encode to FLAC 24Bit 96000HZ"
	echo " (0) skip encoding to FLAC 24Bit 96000HZ"
	echo " "
	read -r -p "choice: " j
	case $j in
		[1])
			d=" -> will encode to FLAC 24Bit 96000HZ"
			flac_24=1;;
		[0])
			d=""
			flac_24=0;;
		*)
			flac2496
			;;
	esac
 }
 
flac4448 ()

 {
	clear
	echo " "
	echo " (1) encode to FLAC 16Bit 48000HZ (SACD)"
	echo " (2) encode to FLAC 16Bit 44100HZ"
	echo " (0) skip encoding to FLAC 16Bit"
	echo " "
	read -r -p "choice: " j
	case $j in
		[1])
			c=" -> will encode to FLAC 16Bit 48000HZ (SACD)"
			flac_samp=1;;
		[2])
			c=" -> will encode to FLAC 16Bit 44100HZ"
			flac_samp=2;;
		[0])
			c=""
			flac_samp=0;;
		*)
			flac4448
			;;
	esac
 }
 
vinylrip ()
{
	clear
	echo " "
	echo " (1) encode to FLAC 24Bit 96000HZ"
	echo "        and to FLAC 16Bit 44100HZ"
	echo "        and to [V0]"
	echo " (0) chose individual output"
	echo " "
	read -r -p "choice: " j
	case $j in
		[1])
			fastmenu=1
			d=" -> will encode to FLAC 24Bit 96000HZ"
			flac_24=1
			c=" -> will encode to FLAC 16Bit 44100HZ"
			flac_samp=2
			s=" -> will encode to [V0]"
			t320=0
			tv0=1
			tv2=0
			;;
		[0])
			clear;;
		*)
			vinylrip
			;;
	esac
}
 
 setannounce ()
{
	#this is a bit overload, but it will fix the array if numbers are not consecutive for smoother input in menu
	clear
	echo " "
	num=1
	for INDEX in "${!ANNOUNCE_URL[@]}";	do
		for zz in $INDEX; do
			arrsort[$num]="${ANNOUNCE_URL[$INDEX]}"
			arrsortf[$num]="${ANNOUNCE_FLAG[$INDEX]}"
			echo -n " ($num) "${ANNOUNCE_URL[$INDEX]:0:40}"... "
			if [ "${ANNOUNCE_FLAG[$INDEX]}" != "" ]; then
			echo "Flag: "${ANNOUNCE_FLAG[$INDEX]}""
			else
			echo "no Flag"
			fi
			let num=(num+1)
			done
	done
	echo " "
	let cnt="${#ANNOUNCE_URL[@]}"+1
	read -r -p "please choose your desired announce url: " a
	case $a in
		''|*[!0-9]*) setannounce ;;
		*) 	while [ "$a" -le 0 ] || [ "$a" -ge $cnt ]; do 
				setannounce
			done
			ANNOUNCE="${arrsort[$a]}"
			FLAG="${arrsortf[$a]}";;
	esac
	clear
}

anotherurl ()
{
	echo " (1) make torrents with another announce url"
	echo " (0) end"
	echo " "
	read -r -p "choice: " j
	case $j in
		[1])
			setannounce
			clear
			echo "Press any key to proceed making torrents for every folder in output "
			echo " "
			read -n 1 -s -r -p "using "${ANNOUNCE:0:40}...""
			clear
  
  
			cd "$OUTPUT_FOLDER"

			for in in *; do
				if [ -d "$in" ]; then
					echo " "
					echo "#Building TORRENT#: $in"
							
					set -euo pipefail
					IFS=$'\n'
					torrent="$OUTPUT_FOLDER/"$FLAG"_"$in".torrent"
					[ -f "$torrent" ] && rm "$torrent"
					mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $in
				fi
			done
				if [ "$in" = "*" ]; then
					echo " "
					echo "  #####>>>>> \""$OUTPUT_FOLDER"\" is empty"
				else
				    echo " "
					echo "added torrents using:"
					echo "    -> "${ANNOUNCE:0:40}...""
					if [ "$FLAG" != "" ]; then
						echo "    -> flag: -s "$FLAG""
						else
						echo "    -> NO source flag"
					fi
					echo " "
				fi
			anotherurl;;
		[0])
			clear;;
		*)
			anotherurl
			;;
	esac
} 

#set default announce and clear
num=1
for INDEX in "${!ANNOUNCE_URL[@]}";	do
	for zz in $INDEX; do
		arrsort[$num]="${ANNOUNCE_URL[$INDEX]}"
		arrsortf[$num]="${ANNOUNCE_FLAG[$INDEX]}"
		let num=(num+1)
		done
done
#stayinwonderland? No, take 1 pill
redpill=0
ANNOUNCE="${arrsort[1]}"
FLAG="${arrsortf[1]}"
fastmenu=0
exit=0
flac_24=0
flac_samp=0
t320=0
tv0=0
tv2=0



clear
while true; do
  if [ "$redpill" == "0" ]; then
  echo " "
  echo " "
  echo " (1) Encode from Wav + make .torrents"
  echo " "
  echo " (2) Encode from Flac + make .torrents"
  echo " "
  echo " (3) Encode specific folder and make .torrent"
  echo " "
  echo " (4) Encode from INPUT to [MP3 V0] in OUTPUT (no .torrent)"
  echo " "
  echo " (5) Rebuild .torrent for every folder in OUTPUT"
  echo " "
  echo " "
  echo " "
  echo " (6) change announce url for this session"
  echo "    -> now using "${ANNOUNCE:0:40}...""
  if [ "$FLAG" != "" ]; then
	echo "    -> adding source flag: -s "$FLAG""
  else
    echo "    -> adding NO source flag"
  fi
  echo " "
  echo " (x) clear folder"
  echo " "
  echo " (00) quit"
  echo " "
  echo " you need to swallow a red pill or you stay in wonderland"
  else
  echo " "
  echo " "
  echo " (1) Encode from Wav + make .torrents"
  echo " "
  echo " (2) Encode from Flac + make .torrents"
  echo " "
  echo " (3) Encode specific folder and make .torrent"
  echo " "
  echo " (4) Encode from INPUT to [MP3 V0] in OUTPUT (no .torrent)"
  echo " "
  echo " (5) Rebuild .torrent for every folder in OUTPUT"
  echo " "
  echo " "
  echo " "
  echo " (6) change announce url for this session"
  echo "    -> now using "${ANNOUNCE:0:40}...""
  if [ "$FLAG" != "" ]; then
	echo "    -> adding source flag: -s "$FLAG""
  else
    echo "    -> adding NO source flag"
  fi
  echo " "
  echo " (x) clear folder"
  echo " "
  echo " (00) quit"
  echo " "
  echo " "
  fi
  echo -n " choice: "; read f


#####################################################################################################
if [ "$f" = "1" ]; then

vinylrip
if [ "$fastmenu" != "1" ]; then
	flac2496
	flac4448
	setenc
fi

if ([ "$flac_samp" == "0" ] && [ "$flac_24" == "0" ] && [ "$t320" == "0" ] && [ "$tv0" == "0" ] && [ "$tv2" == "0" ]); then
	clear
	echo " "
	echo " --> nothing to do"
	read -n 1 -s -r -p "Press any key to proceed to menu"
	clear
	else
	
clear
	echo " "
	echo "$s"
	echo " "
	echo "$d"
	echo " "
	echo "$c"
	echo " "
	echo " -> will make a torrent for each created folders"
	echo " "
	echo " "
	echo "This will overwrite files in output folder if already exists!"
	echo " "
	echo "from INPUT: $INPUT_FOLDER" 
	echo " to OUTPUT: $OUTPUT_FOLDER "
	echo " "
	read -n 1 -s -r -p "Press any key to proceed"
clear
  
  
cd "$INPUT_FOLDER"


	for in in *; do
	if [ -d "$in" ]; then
		# Will not run if no directories are available
		echo "  ##INPUT: $in"
		echo "  ########         ***name changing***"
		out=$(echo $in | sed 's/[ \?,-]\?FLAC \?//g' | sed 's/[ \?,-]\?Flac \?//g' | sed 's/[ \?,-]\?flac \?//g' | sed 's/[ \?,-]\?24Bit \?//g' | sed 's/[ \?,-]\?24BIT \?//g' | sed 's/[ \?,-]\?24bit \?//g' | sed 's/[ \?,-]\?24Bits \?//g' | sed 's/[ \?,-]\?24BITS \?//g' | sed 's/[ \?,-]\?24bits \?//g' | sed 's/[ \?,-]\?16Bit \?//g' | sed 's/[ \?,-]\?16BIT \?//g' | sed 's/[ \?,-]\?16bit \?//g' | sed 's/[ \?,-]\?16Bits \?//g' | sed 's/[ \?,-]\?16BITS \?//g' | sed 's/[ \?,-]\?16bits \?//g' | sed 's/[ \?,-]\?96khz \?//g' | sed 's/[ \?,-]\?96Khz \?//g' | sed 's/[ \?,-]\?44.1khz \?//g' | sed 's/[ \?,-]\?44.1Khz \?//g' | sed 's/[ \?,-]\?96 khz \?//g' | sed 's/[ \?,-]\?96 Khz \?//g' | sed 's/[ \?,-]\?44.1 khz \?//g' | sed 's/[ \?,-]\?44.1 Khz \?//g' | sed 's/[ \?,-]\?SACD \?//g' | sed 's/[ \?,-]\?sacd \?//g' | sed 's/[ \?,-]\?16-48 \?//g' | sed 's/[ \?,-]\?48-16 \?//g' | sed 's/[ \?,-]\?16-44 \?//g' | sed 's/[ \?,-]\?44-16 \?//g' | sed 's/ \?([ \*]\?)//g' | sed 's/ \?\[[ \*]\?\]//g' | sed 's/ \?([ \*]\?)//g' | sed 's/ \?{[ \*]\?}//g' | sed 's/^ *//;s/ *$//')
		echo "  #OUTPUT: $out"
				
		set -euo pipefail
		IFS=$'\n'

		# expand input path
		function abspath {
			if [[ -d "$in" ]]
				then
					pushd "$in" >/dev/null
					pwd
					popd >/dev/null
				elif [[ -e $in ]]
				then
					pushd "$(dirname "$in")" >/dev/null
					echo "$(pwd)/$(basename "$in")"
					popd >/dev/null
				else
					echo "$in" does not exist! >&2
					return 127
			fi
			}

	
# input parameters, the source directory, and the stem of our naming scheme
SOURCE=`abspath $in`

if [ -z "$(ls -A $SOURCE)" ]; then
	echo " "   
	echo "  #####>>>>>  skipping empty folder"
	echo "-->: $SOURCE"
	echo "  #####>>>>>  skipping empty folder"
	echo " "
	else
		STEM=$out
	
		# naming scheme completed with formats
		FLAC2496_NAME="$STEM [24bit-96Khz FLAC]"
		FLAC1648_NAME="$STEM [FLAC 16-48]"
		FLAC_NAME="$STEM [FLAC]"
		M_320_NAME="$STEM [MP3 320]"
		M_V0_NAME="$STEM [MP3 V0]"
		M_V2_NAME="$STEM [MP3 V2]"

		# paths to our encoded formats
		FLAC2496_PATH="$OUTPUT_FOLDER/$FLAC2496_NAME"
		FLAC1648_PATH="$OUTPUT_FOLDER/$FLAC1648_NAME"
		FLAC_PATH="$OUTPUT_FOLDER/$FLAC_NAME"
		M_320_PATH="$OUTPUT_FOLDER/$M_320_NAME"
		M_V0_PATH="$OUTPUT_FOLDER/$M_V0_NAME"
		M_V2_PATH="$OUTPUT_FOLDER/$M_V2_NAME"

		if [ "$flac_24" = "1" ]; then
			rm -rf "$FLAC2496_PATH"
			mkdir -p "$FLAC2496_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$FLAC2496_PATH/{}" ';'
		fi
		if [ "$t320" = "1" ]; then
		    rm -rf "$M_320_PATH"
			mkdir -p "$M_320_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$M_320_PATH/{}" ';'
		fi
		if [ "$tv0" = "1" ]; then
		    rm -rf "$M_V0_PATH"
			mkdir -p "$M_V0_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$M_V0_PATH/{}" ';'
		fi
		if [ "$tv2" = "1" ]; then
		    rm -rf "$M_V2_PATH"
			mkdir -p "$M_V2_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$M_V2_PATH/{}" ';'
		fi
		if [ "$flac_samp" = "1" ]; then
		    rm -rf "$FLAC1648_PATH"
			mkdir -p "$FLAC1648_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$FLAC1648_PATH/{}" ';'
		fi
		if [ "$flac_samp" = "2" ]; then
		    rm -rf "$FLAC_PATH"
			mkdir -p "$FLAC_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$FLAC_PATH/{}" ';'
		fi

		# encode files
		if [ "$redpill" == "0" ]; then
			mkdir -p "$OUTPUT_FOLDER/AsatoMaSatGamaya"
			clear
			else
			for x in `find . -type d -name "*" -print`; do
				cd $x
				for file in *.wav
					do
					if [ "$file" != "*.wav" ]; then
						echo "     $file"
						FLAC=$(echo "${file%.*}").flac
						MP3=$(echo "${file%.*}").mp3
						if [ "$flac_24" = "1" ]; then
						echo -n "       ---> writing FLAC 24Bit 96000Hz "
						ffmpeg -y -hide_banner -v 8 -i "$file" -sample_fmt s32 -af aresample=osr=96000:filter_size=256:cutoff=1:dither_method=triangular ""$FLAC2496_PATH"/"$x"/"$FLAC""
						#ffmpeg -y -hide_banner -v 8 -i "$file" -af aformat=s32:96000 ""$FLAC2496_PATH"/"$x"/"$FLAC""
						echo "done"
						fi
						if [ "$flac_samp" = "1" ]; then
						echo -n "       ---> writing FLAC 16Bit 48000Hz "
						ffmpeg -y -hide_banner -v 8 -i "$file" -sample_fmt s16 -af aresample=osr=48000:filter_size=256:cutoff=1:dither_method=triangular ""$FLAC1648_PATH"/"$x"/"$FLAC""
						#ffmpeg -y -hide_banner -v 8 -i "$file" -af aformat=s16:48000 ""$FLAC1648_PATH"/"$x"/"$FLAC""
						echo "done"
						fi
						if [ "$flac_samp" = "2" ]; then
						echo -n "       ---> writing FLAC 16Bit 44100Hz "
						ffmpeg -y -hide_banner -v 8 -i "$file" -sample_fmt s16 -af aresample=osr=44100:filter_size=256:cutoff=1:dither_method=triangular ""$FLAC_PATH"/"$x"/"$FLAC""
						#ffmpeg -y -hide_banner -v 8 -i "$file" -af aformat=s16:44100 ""$FLAC_PATH"/"$x"/"$FLAC""
						echo "done"
						fi
						if [ "$t320" = "1" ]; then
						echo -n "       ---> writing 320k "
						ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -b:a 320k ""$M_320_PATH"/"$x"/"$MP3""
						echo "done"
						fi
						if [ "$tv0" = "1" ]; then
						echo -n "       ---> writing V0 "
						ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -q:a 0  ""$M_V0_PATH"/"$x"/"$MP3""
						echo "done"
						fi
						if [ "$tv2" = "1" ]; then
						echo -n "       ---> writing V2 "
						ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -q:a 2  ""$M_V2_PATH"/"$x"/"$MP3""
						echo "done"
						fi
					fi	
				done
					cd "$SOURCE"
			done
			fi
		
		# move over the cover art
	
		if [ "$flac_24" = "1" ]; then
			for y in `find . -type d -name "*" -print`; do
				cd $y
				for path in "$FLAC2496_PATH"
					do
						for file in *.{jp{e,}g,txt,pdf{,8}}
						do
							[ -f "$file" ] && cp "$file" "$path/$y"
						done
				done
				cd "$SOURCE"
			done
		fi
		if [ "$flac_samp" = "1" ]; then
			for y in `find . -type d -name "*" -print`; do
				cd $y
				for path in "$FLAC1648_PATH"
					do
						for file in *.{jp{e,}g,txt,pdf{,8}}
						do
							[ -f "$file" ] && cp "$file" "$path/$y"
						done
				done
				cd "$SOURCE"
			done
		fi
		if [ "$flac_samp" = "2" ]; then
			for y in `find . -type d -name "*" -print`; do
				cd $y
				for path in "$FLAC_PATH"
					do
						for file in *.{jp{e,}g,txt,pdf{,8}}
						do
							[ -f "$file" ] && cp "$file" "$path/$y"
						done
				done
				cd "$SOURCE"
			done
		fi
		if [ "$t320" = "1" ]; then
			for y in `find . -type d -name "*" -print`; do
				cd $y
				for path in "$M_320_PATH"
					do
						for file in *.{jp{e,}g,txt,pdf{,8}}
						do
							[ -f "$file" ] && cp "$file" "$path/$y"
						done
				done
				cd "$SOURCE"
			done
		fi
		if [ "$tv0" = "1" ]; then
			for y in `find . -type d -name "*" -print`; do
				cd $y
				for path in "$M_V0_PATH"
					do
						for file in *.{jp{e,}g,txt,pdf{,8}}
						do
							[ -f "$file" ] && cp "$file" "$path/$y"
						done
				done
				cd "$SOURCE"
			done
		fi
		if [ "$tv2" = "1" ]; then
			for y in `find . -type d -name "*" -print`; do
				cd $y
				for path in "$M_V2_PATH"
					do
						for file in *.{jp{e,}g,txt,pdf{,8}}
						do
							[ -f "$file" ] && cp "$file" "$path/$y"
						done
					done
				cd "$SOURCE"
			done
		fi
		
		# build the torrent files
		if [ "$flac_24" = "1" ]; then
		cd "$OUTPUT_FOLDER"
			for name in "$FLAC2496_NAME"
				do
					torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
					[ -f "$torrent" ] && rm "$torrent"
					mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
				done
			echo " "
		fi
		if [ "$flac_samp" = "1" ]; then
			cd "$OUTPUT_FOLDER"
			for name in "$FLAC1648_NAME"
				do
					torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
					[ -f "$torrent" ] && rm "$torrent"
					mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
				done
			echo " "
		fi
		if [ "$flac_samp" = "2" ]; then
			cd "$OUTPUT_FOLDER"
			for name in "$FLAC_NAME"
				do
					torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
					[ -f "$torrent" ] && rm "$torrent"
					mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
				done
			echo " "
		fi
		if [ "$t320" = "1" ]; then
			cd "$OUTPUT_FOLDER"
			for name in "$M_320_NAME"
				do
					torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
					[ -f "$torrent" ] && rm "$torrent"
					mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
				done
			echo " "
		fi
		if [ "$tv0" = "1" ]; then
			cd "$OUTPUT_FOLDER"
			for name in "$M_V0_NAME"
				do
					torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
					[ -f "$torrent" ] && rm "$torrent"
					mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
				done
			echo " "
		fi
		if [ "$tv2" = "1" ]; then
			cd "$OUTPUT_FOLDER"
			for name in "$M_V2_NAME"
				do
					torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
					[ -f "$torrent" ] && rm "$torrent"
					mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
				done
			echo " "
		fi
	fi	
	cd "$INPUT_FOLDER"
	fi
	done
	echo "finished encoding and made torrents using:"
	echo "    -> "${ANNOUNCE:0:40}...""
	if [ "$FLAG" != "" ]; then
		echo "    -> flag: -s "$FLAG""
		else
		echo "    -> NO source flag"
	fi
	echo " "
anotherurl
	clear
	if [ "$in" = "*" ]; then
		echo " "
		echo "  #####>>>>> \""$OUTPUT_FOLDER"\" is empty"
	else
		echo " "
		echo "   #####>>>>>  finished everything succesfully in"
		echo "   #####>>>>> "$OUTPUT_FOLDER""
	fi
fi
	
#####################################################################################################
elif [ "$f" = "2" ]; then 

echo " "
flac4448
setenc
copyflac
if ([ "$optflac" == "0" ] &&[ "$flac_samp" == "0" ] && [ "$t320" == "0" ] && [ "$tv0" == "0" ] && [ "$tv2" == "0" ]); then
	clear
	echo " "
	echo " --> nothing to do"
	read -n 1 -s -r -p "Press any key to proceed to menu"
	clear
	else

clear
	echo " "
	echo "$s"
	echo " "
	echo "$d"
	echo " "
	echo "$c"
	echo " "
	echo "$o"
	echo " "
	echo " -> will make a torrent for each created folders"
	echo " "
	echo " "
	echo "This will overwrite files in output folder if already exists!"
	echo " "
	echo "Press any key to encode EVERY folder"
	echo "from INPUT: $INPUT_FOLDER" 
	read -n 1 -s -r -p " to OUTPUT: $OUTPUT_FOLDER "
clear
  
  
cd "$INPUT_FOLDER"



for in in *; do
	if [ -d "$in" ]; then
		# Will not run if no directories are available
		echo "  ##INPUT: $in"
		echo "  ########         ***name changing***"
		out=$(echo $in | sed 's/[ \?,-]\?FLAC \?//g' | sed 's/[ \?,-]\?Flac \?//g' | sed 's/[ \?,-]\?flac \?//g' | sed 's/[ \?,-]\?24Bit \?//g' | sed 's/[ \?,-]\?24BIT \?//g' | sed 's/[ \?,-]\?24bit \?//g' | sed 's/[ \?,-]\?24Bits \?//g' | sed 's/[ \?,-]\?24BITS \?//g' | sed 's/[ \?,-]\?24bits \?//g' | sed 's/[ \?,-]\?16Bit \?//g' | sed 's/[ \?,-]\?16BIT \?//g' | sed 's/[ \?,-]\?16bit \?//g' | sed 's/[ \?,-]\?16Bits \?//g' | sed 's/[ \?,-]\?16BITS \?//g' | sed 's/[ \?,-]\?16bits \?//g' | sed 's/[ \?,-]\?96khz \?//g' | sed 's/[ \?,-]\?96Khz \?//g' | sed 's/[ \?,-]\?44.1khz \?//g' | sed 's/[ \?,-]\?44.1Khz \?//g' | sed 's/[ \?,-]\?96 khz \?//g' | sed 's/[ \?,-]\?96 Khz \?//g' | sed 's/[ \?,-]\?44.1 khz \?//g' | sed 's/[ \?,-]\?44.1 Khz \?//g' | sed 's/[ \?,-]\?SACD \?//g' | sed 's/[ \?,-]\?sacd \?//g' | sed 's/[ \?,-]\?16-48 \?//g' | sed 's/[ \?,-]\?48-16 \?//g' | sed 's/[ \?,-]\?16-44 \?//g' | sed 's/[ \?,-]\?44-16 \?//g' | sed 's/ \?([ \*]\?)//g' | sed 's/ \?\[[ \*]\?\]//g' | sed 's/ \?([ \*]\?)//g' | sed 's/ \?{[ \*]\?}//g' | sed 's/^ *//;s/ *$//')
		echo "  #OUTPUT: $out"
				
		set -euo pipefail
		IFS=$'\n'

		# expand input path
		function abspath {
			if [[ -d "$in" ]]
				then
					pushd "$in" >/dev/null
					pwd
					popd >/dev/null
				elif [[ -e $in ]]
				then
					pushd "$(dirname "$in")" >/dev/null
					echo "$(pwd)/$(basename "$in")"
					popd >/dev/null
				else
					echo "$in" does not exist! >&2
					return 127
			fi
			}

		
# input parameters, the source directory, and the stem of our naming scheme
SOURCE=`abspath $in`

if [ -z "$(ls -A $SOURCE)" ]; then
	echo " "   
	echo "  #####>>>>>  skipping empty folder"
	echo "-->: $SOURCE"
	echo "  #####>>>>>  skipping empty folder"
	echo " "
	else
		STEM=$out
	
		# naming scheme completed with formats
		FLACorg_NAME="$in"
		FLAC1648_NAME="$STEM [FLAC 16-48]"
		FLAC_NAME="$STEM [FLAC]"
		M_320_NAME="$STEM [MP3 320]"
		M_V0_NAME="$STEM [MP3 V0]"
		M_V2_NAME="$STEM [MP3 V2]"

		# paths to our encoded formats
		FLACorg_PATH="$OUTPUT_FOLDER/$in"
		FLAC1648_PATH="$OUTPUT_FOLDER/$FLAC1648_NAME"
		FLAC_PATH="$OUTPUT_FOLDER/$FLAC_NAME"
		M_320_PATH="$OUTPUT_FOLDER/$M_320_NAME"
		M_V0_PATH="$OUTPUT_FOLDER/$M_V0_NAME"
		M_V2_PATH="$OUTPUT_FOLDER/$M_V2_NAME"

		if ([ "$flac_samp" == "0" ] && [ "$t320" == "0" ] && [ "$tv0" == "0" ] && [ "$tv2" == "0" ]); then
		echo ""
		else
		if [ "$t320" = "1" ]; then
		    rm -rf "$M_320_PATH"
			mkdir -p "$M_320_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$M_320_PATH/{}" ';'
		fi
		if [ "$tv0" = "1" ]; then
		    rm -rf "$M_V0_PATH"
			mkdir -p "$M_V0_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$M_V0_PATH/{}" ';'
		fi
		if [ "$tv2" = "1" ]; then
		    rm -rf "$M_V2_PATH"
			mkdir -p "$M_V2_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$M_V2_PATH/{}" ';'
		fi
		if [ "$flac_samp" = "1" ]; then
		    rm -rf "$FLAC1648_PATH"
			mkdir -p "$FLAC1648_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$FLAC1648_PATH/{}" ';'
		fi
		if [ "$flac_samp" = "2" ]; then
		    rm -rf "$FLAC_PATH"
			mkdir -p "$FLAC_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$FLAC_PATH/{}" ';'
		fi

		# encode the files
		if [ "$redpill" == "0" ]; then
			mkdir -p "$OUTPUT_FOLDER/AsatoMaSatGamaya"
			clear
			else
			for x in `find . -type d -name "*" -print`; do
 			cd $x
			for file in *.flac
				do
				if [ "$file" != "*.flac" ]; then
					echo "     $file"
					FLAC=$(echo "${file%.*}").flac
					MP3=$(echo "${file%.*}").mp3
					if [ "$flac_samp" = "1" ]; then
					echo -n "       ---> writing FLAC 16Bit 48000Hz "
					ffmpeg -y -hide_banner -v 8 -i "$file" -sample_fmt s16 -af aresample=osr=48000:filter_size=256:cutoff=1:dither_method=triangular ""$FLAC1648_PATH"/"$x"/"$FLAC""
					#ffmpeg -y -hide_banner -v 8 -i "$file" -af aformat=s16:48000 ""$FLAC1648_PATH"/"$x"/"$FLAC""
					echo "done"
					fi
					if [ "$flac_samp" = "2" ]; then
					echo -n "       ---> writing FLAC 16Bit 44100Hz "
					ffmpeg -y -hide_banner -v 8 -i "$file" -sample_fmt s16 -af aresample=osr=44100:filter_size=256:cutoff=1:dither_method=triangular ""$FLAC_PATH"/"$x"/"$FLAC""
					#ffmpeg -y -hide_banner -v 8 -i "$file" -af aformat=s16:44100 ""$FLAC_PATH"/"$x"/"$FLAC""
					echo "done"
					fi
					if [ "$t320" = "1" ]; then
					echo -n "       ---> writing 320k "
					ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -b:a 320k ""$M_320_PATH"/"$x"/"$MP3""
					echo "done"
					fi
					if [ "$tv0" = "1" ]; then
					echo -n "       ---> writing V0 "
					ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -q:a 0  ""$M_V0_PATH"/"$x"/"$MP3""
					echo "done"
					fi
					if [ "$tv2" = "1" ]; then
					echo -n "       ---> writing V2 "
					ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -q:a 2  ""$M_V2_PATH"/"$x"/"$MP3""
					echo "done"
					fi
				fi	
			done
				cd "$SOURCE"
		done
		fi
		
	# move over the cover art

	if [ "$flac_samp" = "1" ]; then
		for y in `find . -type d -name "*" -print`; do
			cd $y
			for path in "$FLAC1648_PATH"
				do
					for file in *.{jp{e,}g,txt,pdf{,8}}
					do
						[ -f "$file" ] && cp "$file" "$path/$y"
					done
			done
			cd "$SOURCE"
		done
	fi
	if [ "$flac_samp" = "2" ]; then
		for y in `find . -type d -name "*" -print`; do
			cd $y
			for path in "$FLAC_PATH"
				do
					for file in *.{jp{e,}g,txt,pdf{,8}}
					do
						[ -f "$file" ] && cp "$file" "$path/$y"
					done
			done
			cd "$SOURCE"
		done
	fi
	if [ "$t320" = "1" ]; then
	for y in `find . -type d -name "*" -print`; do
		cd $y
		for path in "$M_320_PATH"
			do
				for file in *.{jp{e,}g,txt,nfo,png,pdf,m3u{,8}}
				do
					[ -f "$file" ] && cp "$file" "$path/$y"
				done
		done
		cd "$SOURCE"
	done
	fi
	if [ "$tv0" = "1" ]; then
	for y in `find . -type d -name "*" -print`; do
		cd $y
		for path in "$M_V0_PATH"
			do
				for file in *.{jp{e,}g,txt,nfo,png,pdf,m3u{,8}}
				do
					[ -f "$file" ] && cp "$file" "$path/$y"
				done
		done
		cd "$SOURCE"
	done
	fi
	if [ "$tv2" = "1" ]; then
	for y in `find . -type d -name "*" -print`; do
		cd $y
		for path in "$M_V2_PATH"
			do
				for file in *.{jp{e,}g,txt,nfo,png,pdf,m3u{,8}}
				do
					[ -f "$file" ] && cp "$file" "$path/$y"
				done
			done
		cd "$SOURCE"
	done
	fi
	fi
	
	# create a copy of the FLAC folder with your naming scheme and build the torrent files
	if [ "$optflac" = "1" ]; then
		cd "$OUTPUT_FOLDER"
		rm -rf "$FLACorg_PATH"
		cp -alT "$SOURCE/." "$FLACorg_PATH"
		for name in "$FLACorg_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi
	if [ "$flac_samp" = "1" ]; then
		cd "$OUTPUT_FOLDER"
		for name in "$FLAC1648_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi
	if [ "$flac_samp" = "2" ]; then
		cd "$OUTPUT_FOLDER"
		for name in "$FLAC_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi
	if [ "$t320" = "1" ]; then
		cd "$OUTPUT_FOLDER"
		for name in "$M_320_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi
	if [ "$tv0" = "1" ]; then
		cd "$OUTPUT_FOLDER"
		for name in "$M_V0_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi
	if [ "$tv2" = "1" ]; then
		cd "$OUTPUT_FOLDER"
		for name in "$M_V2_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi

fi
cd "$INPUT_FOLDER"
fi
done
	echo "finished encoding and made torrents using:"
	echo "    -> "${ANNOUNCE:0:40}...""
	if [ "$FLAG" != "" ]; then
		echo "    -> flag: -s "$FLAG""
		else
		echo "    -> NO source flag"
	fi
	echo " "
anotherurl
clear
	if [ "$in" = "*" ]; then
		echo " "
		echo "  #####>>>>> \""$INPUT_FOLDER"\" is empty"
		echo " "
	else
		echo " "
		echo "   #####>>>>>  finished everything succesfully in"
		echo "   #####>>>>> "$OUTPUT_FOLDER""
	fi
fi

#####################################################################################################
elif [ "$f" = "3" ]; then

clear
setfold ()
{
	echo " "
	echo " (1) encode from Input Folder"
	echo " (2) encode from Downloads Folder"
	echo " (0) exit"
	echo " "
	read -r -p "choice: " j
	case $j in
		[1])
			cd "$INPUT_FOLDER";;
		[2])
			cd "$DOWN_FOLDER";;
		[0])
			exit=1;;
		*)
			setfold
			;;
	esac
}
setfold

if [ "$exit" == "1" ]; then
	clear
	else
	echo " "
	echo " "
	echo " copy/paste EXACT foldername to encode below"
	echo " "
	echo -n "Foldername to encode: "; read in
	while [ ! -d "$in" ]
	do
		echo "Folder does NOT exist, try again: "
		echo -n "Foldername to encode: "; read in
	done
	echo " "
	echo "great, if the foldername contains \"FLAC\" I'll remove it"
	echo -n "would you like to edit the foldername anyway? (y/n) "; read edi
		case $edi in
		[yY])
		echo "                      ok, now compose new folder scheme"
		echo "                      like: Artist - YEAR - Album"
		echo -n " specify output foldername: "; read out
		;;
		*)
			out=$in;;
		esac
	echo " "

set -euo pipefail
IFS=$'\n'

# expand input path
	function abspath {
		if [[ -d "$in" ]]
		then
			pushd "$in" >/dev/null
			pwd
			popd >/dev/null				
			elif [[ -e $in ]]
			then
				pushd "$(dirname "$in")" >/dev/null
				echo "$(pwd)/$(basename "$in")"
				popd >/dev/null
			else
				echo "$in" does not exist! >&2
				return 127
		fi
	}

SOURCE=`abspath $in`
		
clear
flac4448
setenc
copyflac

if ([ "$flac_samp" == "0" ] && [ "$optflac" == "0" ] && [ "$t320" == "0" ] && [ "$tv0" == "0" ] && [ "$tv2" == "0" ]); then
	clear
	echo " "
	echo " --> nothing to do"
	read -n 1 -s -r -p "Press any key to proceed to menu"
	clear
	else

clear
	echo " "
	echo "$s"
	echo " "
	echo "$c"
	echo " "
	echo "$o"
	echo " "
	echo " -> will make a torrent for each created folder"
	echo " "
	echo " "
	echo "This will overwrite files in Outputfolder if already exists!"
	echo " "
	echo "Press any key to encode"
	echo "from: $SOURCE" 
	read -n 1 -s -r -p " to OUTPUT: $OUTPUT_FOLDER "

clear

if [ -z "$(ls -A $SOURCE)" ]; then
	echo " "   
	echo "  #####>>>>>  skipping empty folder"
	echo "-->: $SOURCE"
	echo "  #####>>>>>  skipping empty folder"
	echo " "
	else
	echo "  ##INPUT: $in"
	echo "  ########         ***name changing***"
	if ([ $edi == "y" ] && [ $edi == "Y" ]); then
	out=$(echo $in | sed 's/[ \?,-]\?FLAC \?//g' | sed 's/[ \?,-]\?Flac \?//g' | sed 's/[ \?,-]\?flac \?//g' | sed 's/[ \?,-]\?24Bit \?//g' | sed 's/[ \?,-]\?24BIT \?//g' | sed 's/[ \?,-]\?24bit \?//g' | sed 's/[ \?,-]\?24Bits \?//g' | sed 's/[ \?,-]\?24BITS \?//g' | sed 's/[ \?,-]\?24bits \?//g' | sed 's/[ \?,-]\?16Bit \?//g' | sed 's/[ \?,-]\?16BIT \?//g' | sed 's/[ \?,-]\?16bit \?//g' | sed 's/[ \?,-]\?16Bits \?//g' | sed 's/[ \?,-]\?16BITS \?//g' | sed 's/[ \?,-]\?16bits \?//g' | sed 's/[ \?,-]\?96khz \?//g' | sed 's/[ \?,-]\?96Khz \?//g' | sed 's/[ \?,-]\?44.1khz \?//g' | sed 's/[ \?,-]\?44.1Khz \?//g' | sed 's/[ \?,-]\?96 khz \?//g' | sed 's/[ \?,-]\?96 Khz \?//g' | sed 's/[ \?,-]\?44.1 khz \?//g' | sed 's/[ \?,-]\?44.1 Khz \?//g' | sed 's/[ \?,-]\?SACD \?//g' | sed 's/[ \?,-]\?sacd \?//g' | sed 's/[ \?,-]\?16-48 \?//g' | sed 's/[ \?,-]\?48-16 \?//g' | sed 's/[ \?,-]\?16-44 \?//g' | sed 's/[ \?,-]\?44-16 \?//g' | sed 's/ \?([ \*]\?)//g' | sed 's/ \?\[[ \*]\?\]//g' | sed 's/ \?([ \*]\?)//g' | sed 's/ \?{[ \*]\?}//g' | sed 's/^ *//;s/ *$//')
	fi
	echo "  #OUTPUT: $out"
	
    STEM=$out
	# naming scheme completed with formats
	FLACorg_NAME="$in"
	FLAC1648_NAME="$STEM [FLAC 16-48]"
	FLAC_NAME="$STEM [FLAC]"
	M_320_NAME="$STEM [MP3 320]"
	M_V0_NAME="$STEM [MP3 V0]"
	M_V2_NAME="$STEM [MP3 V2]"
	
	# paths to our encoded formats
	FLACorg_PATH="$OUTPUT_FOLDER/$in"
	FLAC1648_PATH="$OUTPUT_FOLDER/$FLAC1648_NAME"
	FLAC_PATH="$OUTPUT_FOLDER/$FLAC_NAME"
	M_320_PATH="$OUTPUT_FOLDER/$M_320_NAME"
	M_V0_PATH="$OUTPUT_FOLDER/$M_V0_NAME"
	M_V2_PATH="$OUTPUT_FOLDER/$M_V2_NAME"
	
		if [ "$t320" = "1" ]; then
		    rm -rf "$M_320_PATH"
			mkdir -p "$M_320_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$M_320_PATH/{}" ';'
		fi
		if [ "$tv0" = "1" ]; then
		    rm -rf "$M_V0_PATH"
			mkdir -p "$M_V0_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$M_V0_PATH/{}" ';'
		fi
		if [ "$tv2" = "1" ]; then
		    rm -rf "$M_V2_PATH"
			mkdir -p "$M_V2_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$M_V2_PATH/{}" ';'
		fi
		if [ "$flac_samp" = "1" ]; then
		    rm -rf "$FLAC1648_PATH"
			mkdir -p "$FLAC1648_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$FLAC1648_PATH/{}" ';'
		fi
		if [ "$flac_samp" = "2" ]; then
		    rm -rf "$FLAC_PATH"
			mkdir -p "$FLAC_PATH"
			cd "$SOURCE"
			find . -type d -exec mkdir -p "/$FLAC_PATH/{}" ';'
		fi
	
	# encode the MP3 files
	if [ "$redpill" == "0" ]; then
		mkdir -p "$OUTPUT_FOLDER/AsatoMaSatGamaya"
		clear
		else
		for x in `find . -type d -name "*" -print`; do
 			cd $x
			for file in *.flac
				do
				if [ "$file" != "*.flac" ]; then
					echo "     $file"
					FLAC=$(echo "${file%.*}").flac
					MP3=$(echo "${file%.*}").mp3
					if [ "$flac_samp" = "1" ]; then
					echo -n "       ---> writing FLAC 16Bit 48000Hz "
					ffmpeg -y -hide_banner -v 8 -i "$file" -sample_fmt s16 -af aresample=osr=48000:filter_size=256:cutoff=1:dither_method=triangular ""$FLAC1648_PATH"/"$x"/"$FLAC""
					#ffmpeg -y -hide_banner -v 8 -i "$file" -af aformat=s16:48000 ""$FLAC1648_PATH"/"$x"/"$FLAC""
					echo "done"
					fi
					if [ "$flac_samp" = "2" ]; then
					echo -n "       ---> writing FLAC 16Bit 44100Hz "
					ffmpeg -y -hide_banner -v 8 -i "$file" -sample_fmt s16 -af aresample=osr=44100:filter_size=256:cutoff=1:dither_method=triangular ""$FLAC_PATH"/"$x"/"$FLAC""
					#ffmpeg -y -hide_banner -v 8 -i "$file" -af aformat=s16:44100 ""$FLAC_PATH"/"$x"/"$FLAC""
					echo "done"
					fi
					if [ "$t320" = "1" ]; then
					echo -n "       ---> writing 320k "
					ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -b:a 320k "$M_320_PATH/$x/$MP3"
					echo "done"
					fi
					if [ "$tv0" = "1" ]; then
					echo -n "       ---> writing V0 "
					ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -q:a 0  "$M_V0_PATH/$x/$MP3"
					echo "done"
					fi
					if [ "$tv2" = "1" ]; then
					echo -n "       ---> writing V2 "
					ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -q:a 2  "$M_V2_PATH/$x/$MP3"
					echo "done"
					fi
				fi	
			done
				cd "$SOURCE"
		done
		fi

	# move over the cover art

	if [ "$flac_samp" = "1" ]; then
		for y in `find . -type d -name "*" -print`; do
			cd $y
			for path in "$FLAC1648_PATH"
				do
					for file in *.{jp{e,}g,txt,pdf{,8}}
					do
						[ -f "$file" ] && cp "$file" "$path/$y"
					done
			done
			cd "$SOURCE"
		done
	fi
	if [ "$flac_samp" = "2" ]; then
		for y in `find . -type d -name "*" -print`; do
			cd $y
			for path in "$FLAC_PATH"
				do
					for file in *.{jp{e,}g,txt,pdf{,8}}
					do
						[ -f "$file" ] && cp "$file" "$path/$y"
					done
			done
			cd "$SOURCE"
		done
	fi
	if [ "$t320" = "1" ]; then
	for y in `find . -type d -name "*" -print`; do
		cd $y
		for path in "$M_320_PATH"
			do
				for file in *.{jp{e,}g,txt,nfo,png,pdf,m3u{,8}}
				do
					[ -f "$file" ] && cp "$file" "$path/$y"
				done
		done
		cd "$SOURCE"
	done
	fi
	if [ "$tv0" = "1" ]; then
	for y in `find . -type d -name "*" -print`; do
		cd $y
		for path in "$M_V0_PATH"
			do
				for file in *.{jp{e,}g,txt,nfo,png,pdf,m3u{,8}}
				do
					[ -f "$file" ] && cp "$file" "$path/$y"
				done
		done
		cd "$SOURCE"
	done
	fi
	if [ "$tv2" = "1" ]; then
	for y in `find . -type d -name "*" -print`; do
		cd $y
		for path in "$M_V2_PATH"
			do
				for file in *.{jp{e,}g,txt,nfo,png,pdf,m3u{,8}}
				do
					[ -f "$file" ] && cp "$file" "$path/$y"
				done
			done
		cd "$SOURCE"
	done
	fi
	
	# create a copy of the FLAC folder and build the torrens
	if [ "$optflac" = "1" ]; then
		cd "$OUTPUT_FOLDER"
		rm -rf "$FLACorg_PATH"
		cp -alT "$SOURCE/." "$FLACorg_PATH"
		for name in "$FLACorg_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi
	if [ "$flac_samp" = "1" ]; then
		cd "$OUTPUT_FOLDER"
		for name in "$FLAC1648_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi
	if [ "$flac_samp" = "2" ]; then
		cd "$OUTPUT_FOLDER"
		for name in "$FLAC_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi
	if [ "$t320" = "1" ]; then
		cd "$OUTPUT_FOLDER"
		for name in "$M_320_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi
	if [ "$tv0" = "1" ]; then
		cd "$OUTPUT_FOLDER"
		for name in "$M_V0_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi
	if [ "$tv2" = "1" ]; then
		cd "$OUTPUT_FOLDER"
		for name in "$M_V2_NAME"
			do
				torrent="$OUTPUT_FOLDER/"$FLAG"_"$name".torrent"
				[ -f "$torrent" ] && rm "$torrent"
				mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $name
			done
		echo " "
	fi

echo "finished encoding and made torrents using:"
echo "    -> "${ANNOUNCE:0:40}...""
if [ "$FLAG" != "" ]; then
	echo "    -> flag: -s "$FLAG""		
	else
	echo "    -> NO source flag"
fi	
echo " "
anotherurl

clear
echo " "
echo "  #####>>>>>   finished succesfully encoding"
echo "  #####>>>>>  \""$SOURCE"\""
echo "  #####>>>>>   --> to"
echo "  #####>>>>>  \""$OUTPUT_FOLDER"/"$out"\""
echo "  #####>>>>>   and making .torrents"
fi
fi
fi

	  
#####################################################################################################
elif [ "$f" = "4" ]; then 

clear
echo " "
echo "This is only to shrink FLAC and/or Wav to [V0] to make things portable"
echo "No .torrent file will be created"
echo "Mp3s will be copied without transcoding"
echo " "
echo " "
echo "This will overwrite files in output folder if already exists!"
echo " "
echo "Press any key to encode EVERY folder"
echo "from INPUT: "$INPUT_FOLDER"" 
read -n 1 -s -r -p " to OUTPUT: "$OUTPUT_FOLDER""
clear
  
  
cd "$INPUT_FOLDER"



for in in *; do
	if [ -d "$in" ]; then
		# Will not run if no directories are available
		echo "  ##INPUT: $in"
		echo "  ########         ***name changing***"
		out=$(echo $in | sed 's/[ \?,-]\?FLAC \?//g' | sed 's/[ \?,-]\?Flac \?//g' | sed 's/[ \?,-]\?flac \?//g' | sed 's/[ \?,-]\?24Bit \?//g' | sed 's/[ \?,-]\?24BIT \?//g' | sed 's/[ \?,-]\?24bit \?//g' | sed 's/[ \?,-]\?24Bits \?//g' | sed 's/[ \?,-]\?24BITS \?//g' | sed 's/[ \?,-]\?24bits \?//g' | sed 's/[ \?,-]\?16Bit \?//g' | sed 's/[ \?,-]\?16BIT \?//g' | sed 's/[ \?,-]\?16bit \?//g' | sed 's/[ \?,-]\?16Bits \?//g' | sed 's/[ \?,-]\?16BITS \?//g' | sed 's/[ \?,-]\?16bits \?//g' | sed 's/[ \?,-]\?96khz \?//g' | sed 's/[ \?,-]\?96Khz \?//g' | sed 's/[ \?,-]\?44.1khz \?//g' | sed 's/[ \?,-]\?44.1Khz \?//g' | sed 's/[ \?,-]\?96 khz \?//g' | sed 's/[ \?,-]\?96 Khz \?//g' | sed 's/[ \?,-]\?44.1 khz \?//g' | sed 's/[ \?,-]\?44.1 Khz \?//g' | sed 's/[ \?,-]\?SACD \?//g' | sed 's/[ \?,-]\?sacd \?//g' | sed 's/[ \?,-]\?16-48 \?//g' | sed 's/[ \?,-]\?48-16 \?//g' | sed 's/[ \?,-]\?16-44 \?//g' | sed 's/[ \?,-]\?44-16 \?//g' | sed 's/ \?([ \*]\?)//g' | sed 's/ \?\[[ \*]\?\]//g' | sed 's/ \?([ \*]\?)//g' | sed 's/ \?{[ \*]\?}//g' | sed 's/^ *//;s/ *$//')
		echo "  #OUTPUT: $out"
				
		set -euo pipefail
		IFS=$'\n'

		# expand input path
		function abspath {
			if [[ -d "$in" ]]
				then
					pushd "$in" >/dev/null
					pwd
					popd >/dev/null
				elif [[ -e $in ]]
				then
					pushd "$(dirname "$in")" >/dev/null
					echo "$(pwd)/$(basename "$in")"
					popd >/dev/null
				else
					echo "$in" does not exist! >&2
					return 127
			fi
}
		
# input parameters, the source directory, and the stem of our naming scheme
SOURCE=`abspath $in`

if [ -z "$(ls -A $SOURCE)" ]; then
	echo " "   
	echo "  #####>>>>>  skipping empty folder"
	echo "-->: $SOURCE"
	echo "  #####>>>>>  skipping empty folder"
	echo " "
	else
		STEM=$out
	
		# naming scheme completed with formats
		M_V0_NAME="$STEM [MP3 V0]"
		
		# paths to our encoded formats
		M_V0_PATH="$OUTPUT_FOLDER/$M_V0_NAME"
		
		rm -rf "$M_V0_PATH"
		mkdir -p "$M_V0_PATH"
		cd "$SOURCE"
		find . -type d -exec mkdir -p "/$M_V0_PATH/{}" ';'
		addnum=1

		# encode the MP3 files
		if [ "$redpill" == "0" ]; then
		mkdir -p "$OUTPUT_FOLDER/AsatoMaSatGamaya"
		clear
		else
			for x in `find . -type d -name "*" -print`; do
 			cd $x
			for file in *.flac
				do
					if [ "$file" != "*.flac" ]; then
					echo "     $file"
					MP3=$(echo "${file%.*}").mp3
					echo -n "       ---> writing V0 "
					ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -q:a 0  "$M_V0_PATH/$x/$MP3"
					echo "done"
					fi	
				done
			for file in *.wav
				do
					if [ "$file" != "*.wav" ]; then
					MP3=$(echo "${file%.*}").mp3
					if [ -f "$M_V0_PATH/$x/$MP3" ]; then
					echo "     $file"
					echo "       exists in output --> changing output name"
					MP31=$(echo "${file%.*}")
					while [ -f "${M_V0_PATH}/${x}/${MP31}_${addnum}.mp3" ]; do
					addnum=$(( $addnum + 1 ))
					done
					MP3=$(echo "${file%.*}_${addnum}").mp3
					echo "     ${MP31}_${addnum}"
					echo -n "       ---> writing V0 "
					ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -q:a 0  "$M_V0_PATH/$x/$MP3"
					echo "done"
					else
					MP3=$(echo "${file%.*}").mp3
					echo "     $file"
					echo -n "       ---> writing V0 "
					ffmpeg -y -hide_banner -v 8 -i "$file" -codec:a libmp3lame -write_id3v1 1 -id3v2_version 3 -q:a 0  "$M_V0_PATH/$x/$MP3"
					echo "done"
					fi	
					fi
				done
			for file in *.mp3
				do
					if [ "$file" != "*.mp3" ]; then
					MP3=$(echo "${file%.*}").mp3
					if [ -f "$M_V0_PATH/$x/$MP3" ]; then
					echo "     $file"
					echo "       exists in output --> changing output name"
					MP31=$(echo "${file%.*}")
					while [ -f "${M_V0_PATH}/${x}/${MP31}_${addnum}.mp3" ]; do
					addnum=$(( $addnum + 1 ))
					done
					MP3=$(echo "${file%.*}_${addnum}").mp3
					echo "     ${MP31}_${addnum}"
					#cd "$OUTPUT_FOLDER"
					#rm -rf "$M_V0_PATH/$x/$MP3"
					echo -n "       ---> copy mp3 "
					cp -alT "$file" "$M_V0_PATH/$x/$MP3"
					echo "done"
					else
					MP3=$(echo "${file%.*}").mp3
					echo "     $file"
					echo -n "       ---> copy mp3 "
					cp -alT "$file" "$M_V0_PATH/$x/$MP3"
					echo "done"
					fi	
					fi
				done
			cd "$SOURCE"
		done
		fi

	# move over the cover art
	for y in `find . -type d -name "*" -print`; do
		cd $y
		for path in "$M_V0_PATH"
			do
				for file in *.{jp{e,}g,txt,nfo,png,pdf,m3u{,8}}
				do
					[ -f "$file" ] && cp "$file" "$path/$y"
				done
			done
		cd "$SOURCE"
	done

cd "$INPUT_FOLDER"
fi
fi
done
clear
	if [ "$in" = "*" ]; then
		echo " "
		echo "  #####>>>>> \""$INPUT_FOLDER"\" is empty"
	else
		echo " "
		echo "  #####>>>>> finished succesfully shrinking to [V=0] for every folder in"
		echo "  #####>>>>> "$INPUT_FOLDER""
		echo "  #####>>>>>  --> to:"
		echo "  #####>>>>> "$OUTPUT_FOLDER""
fi


#####################################################################################################
elif [ "$f" = "5" ]; then

clear
echo " "
echo "Rebuilding torrent files for EVERY folder in: "
echo " "
echo " "$OUTPUT_FOLDER""
echo " "
echo " "
echo "Press any key to proceed"
echo " "
read -n 1 -s -r -p "This will overwrite torrents if already exist"
clear
  
setannounce  
cd "$OUTPUT_FOLDER"

if [ "$redpill" == "0" ]; then
clear
else
for in in *; do
	if [ -d "$in" ]; then
		echo " "
		echo "#Building TORRENT#: $in"
				
		set -euo pipefail
		IFS=$'\n'
		torrent="$OUTPUT_FOLDER/"$FLAG"_"$in".torrent"
		[ -f "$torrent" ] && rm "$torrent"
		mktorrent -p -s "$FLAG" -a $ANNOUNCE -o "$torrent" $in
	fi
done
	echo " "
	echo "made torrents using:"
	echo "    -> "${ANNOUNCE:0:40}...""
	if [ "$FLAG" != "" ]; then
		echo "    -> flag: -s "$FLAG""
		else
		echo "    -> NO source flag"
	fi
echo " "
anotherurl
fi
clear
	if [ "$in" = "*" ]; then
		echo " "
		echo "  #####>>>>> \""$OUTPUT_FOLDER"\" is empty"
	else
		echo " "
		echo "   #####>>>>>  finished succesfully making .torrents in"
		echo "   #####>>>>> "$OUTPUT_FOLDER""
	fi


#####################################################################################################
elif [ "$f" = "6" ]; then
	setannounce

	
#####################################################################################################
elif [ "$f" = "x" ]; then
	freshup ()
	{
	clear
	echo " "
	echo " (1) clear input folder"
	echo " (2) clear output folder"
	echo " (0) clear input + output folder"
	echo " "
	read -r -p "choice: " j
	case $j in
		[1])
			echo " "
			echo "DANGER DANGER DANGER"
			echo " "
			echo "This will empty and delete everthing in input !!!"
			echo " "
			echo " ->  input: "$INPUT_FOLDER""
			echo " "
			echo " "
			echo "Press any key to proceed"
			read -n 1 -s -r -p "make sure you want this"
			echo " "
			read -n 1 -s -r -p "ok, I'll do it if you press any key again"
			find "$INPUT_FOLDER" -mindepth 1 -maxdepth 1 -exec rm -rf '{}' \; 2>/dev/null
			echo " "
			echo " "
			echo "   #####>>>>>  finished succesfully"
			echo "   #####>>>>>  hit any key for menu"
			read -n 1 -s -r -p  "   #####>>>>>  input folder is now empty"
			clear;;
		[2])
			echo " "
			echo "DANGER DANGER DANGER"
			echo " "
			echo "This will empty and delete everthing in output !!!"
			echo " "
			echo " -> output: "$OUTPUT_FOLDER""
			echo " "
			echo " "
			echo "Press any key to proceed"
			read -n 1 -s -r -p "make sure you want this"
			echo " "
			read -n 1 -s -r -p "ok, I'll do it if you press any key again"
			find "$OUTPUT_FOLDER" -mindepth 1 -maxdepth 1 -exec rm -rf '{}' \; 2>/dev/null
			echo " "
			echo " "
			echo "   #####>>>>>  finished succesfully"
			echo "   #####>>>>>  hit any key for menu"
			read -n 1 -s -r -p  "   #####>>>>>  output folder is now empty"
			clear;;
		[0])
			echo " "
			echo "DANGER DANGER DANGER"
			echo " "
			echo "This will empty and delete everthing in input and output !!!"
			echo " "
			echo " ->  input: "$INPUT_FOLDER""
			echo " -> output: "$OUTPUT_FOLDER""
			echo " "
			echo " "
			echo "Press any key to proceed"
			read -n 1 -s -r -p "make sure you want this"
			echo " "
			read -n 1 -s -r -p "ok, I'll do it if you press any key again"
			find "$OUTPUT_FOLDER" -mindepth 1 -maxdepth 1 -exec rm -rf '{}' \; 2>/dev/null
			find "$INPUT_FOLDER" -mindepth 1 -maxdepth 1 -exec rm -rf '{}' \; 2>/dev/null
			echo " "
			echo " "
			echo "   #####>>>>>  finished succesfully"
			echo "   #####>>>>>  hit any key for menu"
			read -n 1 -s -r -p  "   #####>>>>>  input and output folder are now empty"
			clear;;
		*)
			freshup
			;;
	esac
	}
freshup

		
#####################################################################################################
elif [ "$f" = "00" ]; then
	clear
	exit
fi
	
done