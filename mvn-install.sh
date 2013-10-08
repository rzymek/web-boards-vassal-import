#!/bin/bash 
mkdir tmp 
cd tmp
set -e
#wget -c --content-disposition -O vassal.zip http://sourceforge.net/projects/vassalengine/files/latest/download
#unzip vassal.zip
ver=`echo VASSAL-* | cut -d- -f2`
mvn install:install-file -Dfile=VASSAL-*/lib/Vengine.jar -DgroupId=org.vassal -DartifactId=engine -Dversion=$ver -Dpackaging=jar
