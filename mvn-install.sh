#!/bin/bash 
mkdir tmp 
cd tmp
set -e
wget -c --content-disposition -O vassal.zip http://sourceforge.net/projects/vassalengine/files/latest/download
unzip vassal.zip
ver=`echo VASSAL-* | cut -d- -f2`
file=`echo VASSAL-*/lib/Vengine.jar`
mvn install:install-file -Dfile=$file -DgroupId=org.vassal -DartifactId=engine -Dversion=$ver -Dpackaging=jar
