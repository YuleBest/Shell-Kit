## [14] 挂载虚拟 SD 卡

fgx 7; blank 1
say "欢迎使用"
saya "挂载虚拟 SD 卡"
say "作者: 于乐yule\n"
fgx 7; blank 1

sayb "注意事项"
say "a. 你需要先去'多系统工具箱'完成虚拟 SD 的配置"
say "b. 重启可能会失效"
say "c. 部分机器可能挂载失败(文件权限问题)"
blank 1

if [[ ! -b "/dev/block/by-name/rannki" ]]; then
    say "${RE}虚拟 SD 分区不存在，请使用'多系统工具箱'进行配置${RES} (E001)"
fi

say "${GR}虚拟 SD 卡已被成功配置..."
blank 1
say "${CY}请选择要挂载到的目录: ${RES}"
say "[1] /mnt/rannki"
say "[2] /sdcard/.虚拟SD"
say "[3] 我都要"
say "[4] 自定义"
say "[5] 取消挂载"
blank 1
says "请输入序号: "
read choose_a

blank 1
if [[ $choose_a == "1" ]]; then
    output="/mnt/rannki"
    
elif [[ $choose_a == "2" ]]; then
    output="/sdcard/.虚拟SD"
    
elif [[ $choose_a == "3" ]]; then
    output="/sdcard/.虚拟SD"
    outputb="/mnt/rannki"
    
elif [[ $choose_a == "4" ]]; then
    says "输入你要挂载到的目录 1: "
    read output
        
    if [ ! -d $output ] || [[ $output == "\n" ]] || [[ $output == "" ]] || [[ $output == " " ]]; then
        blank 1
        say "${RE}目录 1 不存在或未填写${RES}"
        exit 1
    fi
    
    says "输入你要挂载到的目录 2: "
    say "如不需要请输入 no"
    read outputb
    
    if [[ $outputb == "no" ]]; then
        sayn ""
    else
        if [ ! -d $outputb ] || [[ $outputb == "" ]] || [[ $outputb == " " ]]; then
            blank 1
            say "${RE}目录 2 不存在，请先去创建${RES}"
            exit 1
        fi
    fi
    
elif [[ $choose_a == "5" ]]; then
    if [ ! -f "/data/YuleBusyBox/tmp/14.txt" ]; then
        say "${RE}您还没有使用本脚本挂载过 SD 卡"
        exit 1
    else
        filename="/data/YuleBusyBox/tmp/14.txt"        
        inputdira=$(head -n 1 "$filename" | tr -d '\n')
        inputdirb=$(sed -n '2p' "$filename" | tr -d '\n') 
        
        say "目录 1: $inputdira"
        if [[ $inputdirb == "" ]]; then
            sayn ""
        else
            say "目录 2: $inputdirb"; blank 1
        fi        
        say "${YE}开始尝试取消挂载...${RES}"
        
        success="1"
        if umount "$inputdira"; then
            say "${GR}成功取消挂载: $inputdira${RES}"
        else
            say "${RE}取消挂载失败: $inputdira${RES}"
            success="0"
        fi
        
        if [[ $inputdirb == "" ]]; then
            sayn ""
        else
            if umount "$inputdirb"; then
                say "${GR}成功取消挂载: $inputdirb${RES}"
            else
                say "${RE}取消挂载失败: $inputdirb${RES}"
                success="0"
            fi
        fi
        
        if [[ $success == "1" ]]; then
            rm -f $filename
        fi
        
        exit 0
    fi

else
    say "${RE}输入超出范围${RES} (W001)"
fi

sayb "开始挂载，出现非红字报错不用管..."

touch "/data/YuleBusyBox/tmp/14.txt"
tmp_f="/data/YuleBusyBox/tmp/14.txt"

mkdir $output
mount -t ext4 /dev/block/by-name/rannki $output
chmod 0777 -R $output
text="目录 1: $output"
echo "$output" > $tmp_f

if [[ $outputb == "no" ]]; then
    sayn ""
else
    mkdir $outputb
    mount -t ext4 /dev/block/by-name/rannki $outputb
    chmod 0777 -R $outputb
    textb="目录 2: $outputb"
    echo "$outputb" > $tmp_f
fi

blank 1
say "${GR}尝试挂载完成${RES}"
say "$text"
say "$textb"