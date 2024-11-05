## [1] 修复字体模块于 Android 15 系统上失效 (代号 XFZT)

XFZT() {
    fgx 7; blank 1
    say "欢迎使用"
    saya "修复字体模块于 Android 15 系统上失效"
    say "作者: 于乐yule\n"
    fgx 7; blank 1
    
    # 1. 让用户输入字体路径
    says "请输入字体模块的路径: "
    read fontdir
    echo ""
    
    # 记录脚本开始时间
    stt f
    
    # 2. 解压字体包
    filename=$fontdir
    font_filename=${filename##*.}
    if [ ${font_filename} != "zip" ]; then
        say "${RE}你选择的文件不是一个 .zip 文件 (E002)${RES}"
        exit 1
    fi
    say "${BL}(0%)正在解压[${filename}]...${RES}"
    workdir="/sdcard/fontworkyule"
    mkdir $workdir
    cd $workdir
    unzip -q $filename -d $workdir
    say ""
    say "${BL}(25%)正在读取文件...${RES}"
    
    # 3. 复制文件
    say ""
    say "${BL}(50%)正在复制文件...${RES}"
    say "${BL}- 正在复制文件...[1/6]${RES}"
    dd if=$workdir/system/etc/fonts.xml of=$workdir/system/etc/font_fallback.xml 2>/dev/null
    say "${BL}- 正在复制文件...[2/6]${RES}"
    dd if=$workdir/system/etc/fonts.xml of=$workdir/system/etc/fonts_slate.xml 2>/dev/null
    say "${BL}- 正在复制文件...[3/6]${RES}"
    dd if=$workdir/system/etc/fonts.xml of=$workdir/system/etc/flyme.xml 2>/dev/null
    say "${BL}- 正在复制文件...[4/6]${RES}"
    dd if=$workdir/system/etc/fonts.xml of=$workdir/system/etc/fonts_base.xml 2>/dev/null
    say "${BL}- 正在创建文件夹...[1/2]${RES}"
    mkdir $workdir/system/system_ext 2>/dev/null
    say "${BL}- 正在创建文件夹...[2/2]${RES}"
    mkdir $workdir/system/system_ext/etc 2>/dev/null
    say "${BL}- 正在复制文件...[5/6]${RES}"
    dd if=$workdir/system/etc/fonts.xml of=$workdir/system/etc/fonts_ule.xml 2>/dev/null
    say "${BL}- 正在复制文件...[6/6]${RES}"
    dd if=$workdir/system/etc/fonts.xml of=$workdir/system/etc/fonts_base.xml 2>/dev/null
    
    # 4. 移动文件
    echo ""
    say "${BL}(50%)正在压缩文件...${RES}"
    cd $workdir; zip -r -5 /sdcard/NewFont_A15.zip .  
    say "${BL}(75%)正在删除工作目录...${RES}"
    rm -rf $workdir
    
    # 输出结语
    echo ""
    echo "------------------------------------------------"
    saya "${YE}操作已完成，文件已保存至/sdcard/NewFont_A15.zip${RES}"
    sayb "${RE}请手动安装并重启即可。${RES}"
}

XFZT
