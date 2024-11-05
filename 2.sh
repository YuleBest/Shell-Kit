## [2] 批量安装指定目录下的 APK 安装包 (代号 PLAZ)

PLAZ() {
    fgx 7; blank 1
    say "欢迎使用"
    saya "批量安装指定目录下的 APK 安装包"
    say "作者: 于乐yule\n"
    fgx 7; blank 1

    # 设置要安装APK的目录
    says "请输入安装包所在目录完整路径"
    read APK_DIR
    
    # 检查是否设置了正确的目录
    if [ ! -d "$APK_DIR" ]; then
      say "${RE}错误: 目录 $APK_DIR 不存在${RES}"
      exit 1
    fi    
    blank 1
    
    # 遍历目录中所有的.apk文件，并列出其文件名和大小
    for apk in "$APK_DIR"/*.apk; do
      if [ -f "$apk" ]; then
        # 获取文件名（不带路径）
        filename=$(basename "$apk")
        # 获取文件大小
        size=$(du -m "$apk" | cut -f 1)
        # 输出文件信息
        say "${YE}$filename${RES} [${size} MB]"
      fi
    done
    
    # 确认是否继续安装
    blank 1
    say "↑ 以上是将要安装的所有APK文件的信息"
    blank 1
    says "y 继续安装 | n 取消"
    read determine
    if [[ $determine == "n" ]]; then
        exit 0
    elif [[ $determine == "y" ]]; then
        sayb "开始安装..."
    else
        say "${RE}输入错误${RES} (W001)"
        exit 1
    fi
    mkdir /data/local/tmp/APK_FILE
    success=0; failure=0
    
    # 再次遍历并安装APK
    stt 2
    for apk in "$APK_DIR"/*.apk; do
      if [ -f "$apk" ]; then
        cp $apk /data/local/tmp/APK_FILE/$(basename $apk)
        apk="/data/local/tmp/APK_FILE/$(basename $apk)"
        chmod 777 $apk
        say "${CY}开始安装 $(basename $apk)${RES}"
        stt install
        pm install -r "$apk"
        ent install
        # 检查安装结果
        if [ $? -eq 0 ]; then
          say "${GR}[$(pet install)S] 成功安装了 $(basename $apk)${RES}"
          ((success++))
        else
          say "${RE}[$(pet install)S] 未能安装 $(basename $apk)${RES}"
          ((failure++))
        fi
        rm -f $apk
        blank 1
      fi
    done
    rm -rf /data/local/tmp/APK_FILE/
    ent 2; fgx 7
    say "${GR}安装完毕，耗时 $(pet 2) 秒"
    say "- 成功: ${GR}$success${RES}"
    say "- 失败: ${RE}$failure${RES}"
}

PLAZ