## [3] 找出占用空间达到某个值的文件 (代号 ZCZY)

ZCZY() {
    fgx 7; blank 1
    say "欢迎使用"
    saya "找出占用空间达到某个值的文件"
    say "作者: 于乐yule\n"
    fgx 7; blank 1
        
    # 函数: 将GB转换成字节，并只保留整数部分
    gb_to_bytes() {
        echo "$1 * 1024 * 1024 * 1024 / 1" | bc
    }
    
    # 函数: 将字节转换成MB，支持浮点数
    bytes_to_mb() {
        echo "scale=2; $1 / 1024 / 1024" | bc
    }
    
    # 显示菜单并获取用户的选择
    says "请选择要搜索的目录:\n   1) 根目录 /\n   2) 内部储存 /storage/emulated/0/"
    read choice
    
    # 根据用户的选择设置搜索路径
    case $choice in
        1)
            search_path="/"
            ;;
        2)
            search_path="/storage/emulated/0/"
            ;;
        *)
            say "${RE}无效的选项。退出程序${RES} (W001)"
            exit 1
            ;;
    esac
    
    blank 1
    
    # 获取用户输入的大小(GB)，允许浮点数
    says "请输入要查找的大于多少GB的文件:"
    read size_gb
    
    blank 1; say "${CY}已开始搜索，根据手机性能大概需要等待 10 - 200 秒~${RES}"; blank 1; fgx 7; blank 1; stt a
    
    # 将GB转换为字节，并只保留整数部分
    size_bytes=$(gb_to_bytes $size_gb)
    size_bytes=${size_bytes%.*}  # 只保留整数部分
    
    sayb "大于 ${size_gb} GB 的文件: "
    say "(1024 MB = 1 GB)"; blank 1
    
    # 查找大于指定大小的文件，并按照大小降序排列
    find "$search_path" -type f -size +"$size_bytes"c -exec du -b {} + | sort -nr | while read line; do
        # 提取文件大小和路径
        file_size=$(echo $line | cut -f1)
        file_path=$(echo $line | cut -d' ' -f2-)
        file_name=$(basename "$file_path")
        
        # 转换文件大小为MB并保留两位小数
        file_size_mb=$(bytes_to_mb $file_size)
        
        # 输出文件大小(MB)和文件名
        say "◆ ${CY}${file_size_mb} MB${RES} - ${YE}${file_name}${RES}"
        say "  ${file_path}"
    done
    ent a
    echo "\n${YE}耗时: $(pet a)s"
}

ZCZY
