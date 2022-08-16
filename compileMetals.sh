#!/usr/bin/env bash

cd ./Sources/GPUImage/Metal

for PLATFORM in "iOS" "iOSSimulator"; do

    case $PLATFORM in
    "iOS")
    SDK="iphoneos"
    ;;
    "iOSSimulator")
    SDK="iphonesimulator"
    ;;
    esac

   for i in *.metal; do
      xcrun -sdk $SDK metal -c $i -o $(basename -s .metal $i).air
   done

   xcrun -sdk $SDK metallib *.air -o ../Resources/default$PLATFORM.metallib
   rm *.air

done
