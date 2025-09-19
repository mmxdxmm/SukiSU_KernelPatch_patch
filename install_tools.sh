if [ -f "android-ndk-r28c.zip" ]; then
    echo "文件已存在，正在解压..."
    yes | unzip android-ndk-r28c.zip
else
    echo "文件不存在，正在下载..."
    wget -nv -O android-ndk-r28c.zip "https://dl.google.com/android/repository/android-ndk-r28c-linux.zip"
    if [ $? -eq 0 ]; then
        echo "下载完成，正在解压..."
        yes | unzip android-ndk-r28c.zip
    else
        echo "下载失败，请检查网络或链接是否正确。"
    fi
fi