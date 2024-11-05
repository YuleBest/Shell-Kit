## [5] 备份字库 (代号 BFZK)

BFZK() {
    fgx 7; blank 1
    say "欢迎使用"
    saya "备份字库"
    say "作者: 于乐yule\n"
    fgx 7; blank 1
    
    exclude_img="userdata|cust|boot|modem|exaid|cache|mmcblk0|recovery|super|rannki|system|vendor|vendor_boot|product|sda|sdb|sdc|sdd|sde|sdf|sdg"
    
    backup_img=$(ls -C /dev/block/bootdevice/by-name/ | grep -vE '(userdata|cust|boot|modem|exaid|cache|mmcblk0|recovery|super|rannki|system|vendor|vendor_boot|product|sda|sdb|sdc|sdd|sde|sdf|sdg)')
    sayb "不备份: "
    echo "${RE}${exclude_img}${RES}"
    blank 1
    sayb "备份: "
    echo "${GR}${backup_img}${RES}"
    blank 1
    sayb "↑ 前往 /Tools/5.sh 的 10 / 12 行配置"
    blank 1
    says "按下回车确认"; read enter
    
    # 压缩算法选择
    says "是否在备份完之后执行压缩？(耗时变长、体积变小) (y/n)"
    read compress
    if [[ $compress == "y" ]]; then
        compress="y"
        says "请选择压缩算法\n   1) tar.gz\n   2) zip"
        read algorithm
    elif [[ $compress == "n" ]]; then
        compress="n"
    else
        say "${RE}无效的输入。${RES}(W001)"
        exit 1
    fi
    
    sayb "开始备份..."
    
    stt 5
    
    mkdir /sdcard/images
    for fs in $(ls /dev/block/bootdevice/by-name/ | grep -vE '(userdata|cust|boot|modem|exaid|cache|mmcblk0|recovery|super|rannki|system|vendor|vendor_boot|product|sda|sdb|sdc|sdd|sde|sdf|sdg)');
    do
        sayn "备份: ${fs}.img    "
    	dd if=/dev/block/bootdevice/by-name/${fs} of=/sdcard/images/${fs}.img > /dev/null 2>&1
    	say "${GR}完成${RES}($(du -m /sdcard/images/${fs}.img | cut -f 1) MB)"
    done
    
    say "${GR}全部备份完成${RES}"
    dir_size=$(du -m /sdcard/images/ | cut -f 1)
    say "总大小: $dir_size MB"
    
    if [[ $compress == "y" ]]; then
        say "开始压缩..."
        cd /sdcard/images
        if [[ $algorithm == "1" ]]; then
            tar -czvf "/sdcard/字库备份.tar.gz" .
            type='.tar.gz'
        elif [[ $algorithm == "2" ]]; then
            zip -r -5 "/sdcard/字库备份.zip" .
            type='.zip'
        fi
        compress_size=$(du -m /sdcard/字库备份${type} | cut -f 1)
        say "${GR}压缩完成啦${RES}"
        say "大小:   $compress_size MB"
        say "压缩率: $(echo "scale=2;$compress_size / $dir_size * 100" | bc) %"
    fi
    blank 1
    fgx 7
    blank 1
    saya "备份路径"
    sayb "分区镜像: /sdcard/images/"
    if [[ $compress == "y" ]]; then
        sayb "压缩包:   /sdcard/字库备份${type}"
    fi
    
    ent 5
    
    sayb "耗时:    $(pet 5) 秒"
}

BFZK