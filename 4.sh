## [4] 提取手机系统分区镜像文件 (代号 TQSJ)

TQSJ() {
    fgx 7; blank 1
    say "欢迎使用"
    saya "提取手机系统分区镜像文件"
    say "作者: 于乐yule\n"
    fgx 7; blank 1
    
    sayb "文件列表: \n"

    # 尝试从 /dev/block/bootdevice/by-name/ 获取文件列表
    files=("/dev/block/bootdevice/by-name/"*)
    if [ ${#files[@]} -eq 0 ]; then
        # 如果 by-name 目录没有文件，尝试从 /dev/block/bootdevice/ 获取
        files=("/dev/block/bootdevice/"*)
        if [ ${#files[@]} -eq 0 ]; then
            say "${RE}获取镜像文件列表失败，请检查脚本权限。${RES}(E003)"
            exit 1
        else
            say "${YE}获取镜像文件列表成功，但可能不正确，因为您的机器不支持。${RES}"
        fi
    fi

    # 输出带有序号的文件列表
    counter=1
    for file in "${files[@]}"; do
        # 只显示文件名部分，去掉路径
        filename=$(basename "$file")
        printf " %3d) %s\n" "${counter}" "$filename"
        ((counter++))
    done

    # 提示用户输入序号
    blank 1
    says "请输入您要选择的文件编号: "
    read selection
    blank 1

    # 检查输入是否为有效的数字
    if ! echo "$selection" | grep -qE '^[0-9]+$'; then
        say "${RE}无效的输入。请输入一个数字。${RES}(W001)"
        exit 1
    fi

    # 检查输入的序号是否在有效范围内
    if [ "$selection" -lt 1 ] || [ "$selection" -ge "$counter" ]; then
        echo "${YE}选择超出范围。请重试。${RES}(W001)"
        exit 1
    fi

    # 计算实际索引（数组是从0开始的）
    index=$((selection - 1))

    # 输出选中的文件名及其完整路径
    selected_file="${files[$index]}"
    say "${CY}您选择了: $selected_file${RES}"    
    blank 1  
    says "将要执行\n   复制: ${CY}$(basename ${selected_file})${RES}\n   ${BL}到:${RES}   ${CY}/sdcard/Download/$(basename ${selected_file}).img${RES}\n   ${BL}您确认要继续吗？(y 确认 / n 取消)${RES}"
    read choose
    if [[ $choose == "n" ]]; then
        exit 0
    elif [[ $choose != "y" ]]; then
        say "${RE}输入无效，请输入 y 或 n ${RES}(W001)"
        exit 1
    fi
    blank 1; fgx 7; blank 1
    stt 002    
    dd if="${selected_file}" of="/sdcard/Download/$(basename ${selected_file}).img" > /dev/null 2>&1
    ent 002; say "${GR}复制完成${RES}"
    say "耗时: $(pet 002) 秒"
    
    file_size=$(du -m "/sdcard/Download/$(basename ${selected_file}).img" | awk '{print $1}')
    
    say "大小: $file_size MB"
    say "速度: $(echo "scale=2; $file_size / $(pet 002)" | bc) MB/s"    
}

TQSJ