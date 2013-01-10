SDK=$compileEnv
#local run example:SDK=iphoneos5.0
XCODE_PATH=$XCODE_PATH$compileEnv
#local run example:XCODE_PATH=xcodebuild
#指定result目录为存放安装包的目录;
if [ -e result ] ;then
rm -r result;
fi
mkdir result

#执行清理操作,这里需要替换对应的target名字和config、以及对应的SDK版本;
#如替换后的语句为:xcodebuild -target dailybuildipa -configuration release clean -sdk iphoneos4.3
$XCODE_PATH -target dailybuildipa -configuration DailyBuild clean -sdk $SDK
if [ -e build/DailyBuild-iphoneos/*.ipa ] ;then
cd build/DailyBuild-iphoneos;
cd ..
rm -r *;
cd ..;
fi

#与clean操作类似，也需要替换对应的target名字和config、以及对应的SDK版本;
$XCODE_PATH -target dailybuildipa -configuration DailyBuild -sdk $SDK
if ! [ $? = 0 ] ;then
exit 1
fi

#安装包归档
cp build/DailyBuild-iphoneos/*.ipa result/$BaseLine.ipa

