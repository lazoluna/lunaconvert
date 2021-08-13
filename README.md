# lunaconvert
bash script for encoding wav / flac / mp3 + few extras

I worte this script to keep me alive during corona times. Everybody shall use it for free. Share the music and enjoy everthing.

A script for comfortably encoding Musik on a linux machine. If you rip your Vinyls, you might love this. It now supports 32bit float 96khz wav files as input to convert to other formats such as flac 24Bit 96Khz and more. Tags will be same as input and subfolders are supported as well as copying artwork from source to destination.

!! Remember to first create your input and output folder and edit the script to add your defaults. !!
!! Follow the white Rabbit to see !!

+    added a menustructure for comfortable use
+    added 24Bit 96Khz support
+    added subfolder depth support
+    added improved name cleanup for foldernames
+    added batch encode
+    added menu to choose desired outputs
+    added supoort to encode specific folder directly without copying to Input Folder
+    added check if folder exist / skip if empty
+    added check if ffmpeg & mktorrent is present
+    added option to create a torrent for every folder in outputfolder
+    added option to shrink flac to V0 for every folder in Inputfolder without creating torrent (for making music transportable)
+    added option to change announce url
+    added multi tracker support
+    added support for changing piece size

Main Menu:

(1)  Encode from Wav + make .torrents

(2)  Encode from Flac + make .torrents

(3)  Encode specific folder and make .torrent

(4)  Encode from INPUT to [MP3 V0] in OUTPUT (no .torrent)

(5)  Rebuild .torrent for every folder in OUTPUT

(6)  change announce url / piece size

(x) clear folder

(00) quit
