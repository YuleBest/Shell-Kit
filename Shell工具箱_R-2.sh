#!/bin/bash

# 颜色变量
GR="\033[1;32m"     # 绿
YE="\033[1;33m"     # 黄
BL="\033[1;34m"     # 深蓝
CY="\033[1;36m"     # 天蓝
RE="\033[1;31m"     # 红
WH="\033[1;37m"     # 白
BO="\033[1m"        # 粗体
RES="\033[0m"       # 结束

# 定义空白行输出
blank() {
    for blank_lines in $(seq 1 ${1}); do
        echo ""
    done
}

# 定义美化格式的输出
    # 普通输出
    say() {
        echo -e " $1"
    }
    # 不输出换行符的普通输出
    sayn() {
        echo -en "$1"
    }
    # 一级标题输出
    saya() {
        echo -e " ▶︎ ${BL}$1${RES}"
    }
    # 二级标题输出
    sayb() {
        echo -e " - ${CY}$1${RES}"
    }
    # 选择询问输出
    says() {
        echo -e "${BL} > ${1}${RES}"
        echo -en "   你的输入是: "
    }
    
# 定义分割线
fgx() {
    for fgxs in $(seq 1 ${1}); do
        sayn "——————"
    done
    say ""
}

# 定义时间输出函数
    # 函数定义
    stt() {
        local id=$1
        start_times[$id]=$(date +%s%3N)  # 获取当前时间戳（秒+三位纳秒）
    }
    
    # 记录命令结束执行的时间（以毫秒为单位）
    ent() {
        local id=$1
        end_times[$id]=$(date +%s%3N)  # 获取当前时间戳（秒+三位纳秒）
    }
    
    # 计算并输出执行时间（以秒为单位，包含小数部分）
    pet() {
        local id=$1
        # 检查是否有对应的开始时间和结束时间
        if [[ -z ${start_times[$id]} || -z ${end_times[$id]} ]]; then
            echo "Error: No start or end time recorded for ID: $id"
            return
        fi
        # 计算执行时间差（以毫秒为单位）
        local execution_time_ms=$((end_times[$id] - start_times[$id]))
        # 将毫秒转换为秒（包括小数部分）
        local execution_time_seconds=$(bc <<< "scale=3; $execution_time_ms / 1000.0")
        
        # 获取字符串长度
        local length=${#execution_time_seconds}
        
        # 输出执行时间
        if [[ $length -eq 4 ]]; then
            echo "0${execution_time_seconds}"
        else
            echo "${execution_time_seconds}"
        fi
    }

# 用于执行功能
runsh() {
    . ./${1}.sh
}

# 计算 UID
UID() {
    serialno=$(getprop ro.serialno)
    UID=$(echo -n $serialno | md5sum)
    say $UID
}

# 定义更新公告
updata_log() {
    saya "官方仓库"
    say "https://github.com/YuleBest/Shell-Kit"
}

# 定义功能列表
json_reader() {
    cat "./info.json" | jq ".$1"
}
function_menu() {
    saya "功能列表"
    cat info.json | jq -r 'to_entries | .[] | select(.value.title) | " [\(.key)] \(.value.title)"'
}

# 错误码列表
    # 一般错误
        # W001: 输入错误
    # 重要错误
        # E001: 未找到文件
        # E002: 文件处理错误
        # E003: 权限不足

# 000 检查 Root、CPU 架构、Shell 环境 ——————————————————————————————————————————

cd $(dirname "$(readlink -f "$0")")
echo "$PWD"
if [ ! -f ./Tools/busybox.yule ]; then
    for i in $(seq 1 50); do
        sayb "请把文件${RE}全部解压${RES}到${RE}同一个目录${RES}${CY}再执行脚本! ${RES}"
        say "  重要的事情说 ${CY}${i}${RES} 遍! "
        sleep 0
    done
    exit 1
fi

cpu_type=$(uname -m)
if [[ $cpu_type != "aarch64" ]]; then
    clear; blank 3
    sayb "抱歉，本脚本暂时只支持 ARM64 架构处理器 (aarch64)"
    say "  你的 CPU 架构: $cpu_type"
    exit 1
fi

if [ "$(whoami)" != root ]; then
    clear; blank 3
	sayb "抱歉 本脚本暂时只支持 Root 用户使用 (E003)"
	exit 1
fi

if [[ $SHELL = *mt* ]]; then
    clear; blank 3
    sayb "请不要使用 MT 拓展包环境执行"
    say "  而是使用系统环境"
    exit 1
fi

# 001 配置环境（首次）——————————————————————————————————————————

if [[ ! -f /data/YuleBusyBox/busybox ]]; then
    clear
    echo "\n\n允许本脚本在 /data/YuleBusyBox/ 生成必要依赖文件吗？(仅生成一次，无需联网，占用空间 5 MB左右)"
    echo "        [1] 允许    [2] 不允许并退出脚本"
    read Jurisdiction
    if [[ $Jurisdiction == "2" ]]; then
        exit 1
    elif [[ $Jurisdiction == "1" ]]; then
        Jurisdiction="y"
    else
        exit 1
    fi
fi
cd $(dirname "$(readlink -f "$0")")
echo "开始配置环境"
. ${PWD}/Tools/busybox.yule
export PATH=/data/YuleBusyBox:$PATH
echo "环境配置完成"

# 002 检查环境是否完整 ——————————————————————————————————————————

clear

files=(
    "./1.sh"
    "./2.sh"
    "./3.sh"
    "./11.sh"
    "./12.sh"
    "./13.sh"
    "./14.sh"
    "./15.sh"
    "./busybox"
    "./busybox.yule"
    "./info.json"
    "./zip"
    "./jq"
    "./openssl"
)

for file in "${files[@]}"; do
    if [ ! -f "$file" ]; then
        say "${RE}文件 $file 不存在，环境不完整${RES}(E001)"
        say "请前往酷安 @于乐Yule 获取最新链接并重新下载"
        exit 1 # 退出脚本
    else
        say "检查环境完整性：$file 存在"
    fi
done

echo "所有文件存在，继续执行..."

# 003 输出基本信息 ——————————————————————————————————————————

clear

say "${RE}__   __     _      ____            _   ${RES}"; 
say "${YE}\ \ / /   _| | ___| __ )  ___  ___| |_ ${RES}"; 
say "${BL} \ V / | | | |/ _ \  _ \ / _ \/ __| __|${RES}"; 
say "${CY}  | || |_| | |  __/ |_) |  __/\__ \ |_ ${RES}"; 
say "${GR}  |_| \__,_|_|\___|____/ \___||___/\__|${RES}"

blank 1; fgx 7; blank 1

say "    ${BL}欢 迎 来 到${RES}${RE} S${RES}${YE}h${RES}${BL}e${RES}${CY}l${RES}${GR}l${RES}${RE} 工${RES}${YE} 具${RES}${RE} 箱${RES} · R-2"; blank 1; fgx 7; blank 1

saya "UID"
UID; blank 1

updata_log; blank 1

function_menu

# 004 功能选择 ——————————————————————————————————————————

for NoE in $(seq 1 10); do
    blank 1
    says "请选择你需要的功能对应的序号"
    read function_menu_choose
    case $function_menu_choose in
        1)
            clear; runsh 1; exit 0
            ;;
        2)
            clear; runsh 2; exit 0            
            ;;
        3)
            clear; runsh 3; exit 0
            ;;
        11)
            clear; runsh 11; exit 0
            ;;
        12)
            clear; runsh 12; exit 0
            ;;
        13)
            clear; runsh 13; exit 0
            ;;
        14)
            clear; runsh 14; exit 0
            ;;
        15)
            clear; runsh 15; exit 0
            ;;
        *|\n)
            # 输入错误
            say "${YE}输入错误，请重新输入，机会 ${NoE} / 10！${RES} (W001)"
            ;;
    esac
done