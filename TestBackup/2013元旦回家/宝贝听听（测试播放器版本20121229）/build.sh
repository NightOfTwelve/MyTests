SDK=$compileEnv
#local run example:SDK=iphoneos5.0
XCODE_PATH=$XCODE_PATH$compileEnv
#local run example:XCODE_PATH=xcodebuild
#ָ��resultĿ¼Ϊ��Ű�װ����Ŀ¼;
if [ -e result ] ;then
rm -r result;
fi
mkdir result

#ִ���������,������Ҫ�滻��Ӧ��target���ֺ�config���Լ���Ӧ��SDK�汾;
#���滻������Ϊ:xcodebuild -target dailybuildipa -configuration release clean -sdk iphoneos4.3
$XCODE_PATH -target dailybuildipa -configuration DailyBuild clean -sdk $SDK
if [ -e build/DailyBuild-iphoneos/*.ipa ] ;then
cd build/DailyBuild-iphoneos;
cd ..
rm -r *;
cd ..;
fi

#��clean�������ƣ�Ҳ��Ҫ�滻��Ӧ��target���ֺ�config���Լ���Ӧ��SDK�汾;
$XCODE_PATH -target dailybuildipa -configuration DailyBuild -sdk $SDK
if ! [ $? = 0 ] ;then
exit 1
fi

#��װ���鵵
cp build/DailyBuild-iphoneos/*.ipa result/$BaseLine.ipa

