## [15] 图片加密/解密

fgx 7; blank 1
say "欢迎使用"
saya "文件加密/解密(openssl)"
say "作者: 于乐yule\n"
fgx 7; blank 1

sayb "注意事项"
say "a. 本脚本所加密的文件在被解密后不保证 100% 还原/可用，请自行测试"
say "b. 禁止使用本脚本加密违法违规内容，否则后果自负"
say "c. 加密后的文件请不要修改拓展名，除非你额外记了"
blank 1

jiami() {
    says "请输入文件路径"
    read input_file
    # 判断文件是否存在
    if [ ! -f $input_file ]; then
        say "${RE}文件不存在${RES} (E001)"
        exit 1
    fi
    blank 1
    says "请输入密码 (忘记无法找回)"
    read password
    if [[ $password == "" ]] || [ "$password" = "\n" ]; then
        say "${RE}密码不能为空${RES}"
        exit 1
    fi
    output_file="/sdcard/Download/ShellKit/加密"
    mkdir $output_file
    filename=$(basename ${input_file})
    openssl enc -aes-256-cbc -pass pass:"$password" -in "$input_file" -out "${output_file}/${filename}"
    chmod 777 "$output_file/${filename}"
    say "${GR}加密完成，输出路径: ${output_file}${RES}"
    exit 0
}

jiemi() {
    says "请输入文件路径"
    read input_file
    # 判断文件是否存在
    if [ ! -f $input_file ]; then
        say "${RE}文件不存在${RES} (E001)"
        exit 1
    fi
    blank 1
    says "请输入密码"
    read password
    if [[ $password == "" ]] || [ "$password" = "\n" ]; then
        say "${RE}密码不能为空${RES}"
        exit 1
    fi
    output_file="/sdcard/Download/ShellKit/解密"
    mkdir $output_file
    filename=$(basename ${input_file})
    openssl enc -aes-256-cbc -d -pass pass:"$password" -in "$input_file" -out "${output_file}/${filename}"    
    # 获取解密后文件大小
    out_size=$(du -b "${output_file}/${filename}" | cut -f1)
    in_size=$(du -b "$input_file" | cut -f1)
    echo "输入 $in_size b，输出 $out_size b"
    blank 1
    if [ $in_size -gt $out_size ]; then
        # 输入大小 ＞ 输出大小，判定为可能解密失败
        say "${YE}解密已完成，但可能失败，请查看上方提示信息${RES}"
    else
        say "${GR}解密完成${RES}"
    fi
    say "输出路径: ${output_file}"   
    chmod 777 "$output_file/${filename}"      
    exit 0
}

saya "请选择你需要的功能"
sayb "[1] 加密"
sayb "[2] 解密"
read choose
blank 1

if [[ $choose == "1" ]]; then
    jiami
elif [[ $choose == "2" ]]; then
    jiemi
else
    say "${RE}输入错误${RES}"
fi

