---
title: bash获取参数 
date: 2016-11-30 14:04:16
tags: [bash,shell]
categories: linux
---

# bash获取参数

## 参数解析
在shell script获取参数前，需要知道几个特殊变量。

- \$0   执行命令本身路径，如 ~/.test.sh.
- \$1~\$9   1~9参数
- \$# 参数个数，不包括\$0
- \$@ 所有参数的列表，数组类型。不包括\$0
- \$* 与\$@一样返回所有参数，String类型。不包括\$0

获取shell script一般有三种方式。
- 手工方式
- getopts
- getopt

## 手工方式
直接判断变量的值。如以下代码:

```bash
# 遍历参数
case "$1" in
  "test"|"t")
    testHandler $@
    ;;
  *)
    echo ""
    echo "    error: unknown option \`$1\`\n"
esac
```
## getopt
getopts 是bash内置的获取参数的方法，不限linux/unix平台使用，缺点是只支持短参数。使用方法如下：
```bash
#!/bin/bash
# getopts:后端加':'表示忽略系统错误，自定义错误消息
while getopts:"a:bc" opt #选项后面的冒号表示该选项需要参数
do
        case $opt in
             a)
                echo "a's arg:$OPTARG" #a后端可带参数值，参数值为$OPTARG
                ;;
             b)
                echo "b"
                ;;
             c)
                echo "c"
                ;;
             ?)  #当有不认识的选项的时候arg为?
            echo "unkonw argument"
        exit 1
        ;;
        esac
done
```

## getopts
getopt是独立的可执行文件，不是内嵌在bash，不支持macOS系统。相比getopts，getopt支持长参数。官方使用方法如下：
```bash
#!/bin/bash

#-o表示短选项，两个冒号表示该选项有一个可选参数，可选参数必须紧贴选项
#如-carg 而不能是-c arg
#--long表示长选项
#"$@"在上面解释过
# -n:出错时的信息
# -- ：举一个例子比较好理解：
#我们要创建一个名字为 "-f"的目录你会怎么办？
# mkdir -f #不成功，因为-f会被mkdir当作选项来解析，这时就可以使用
# mkdir -- -f 这样-f就不会被作为选项。

TEMP=`getopt -o ab:c:: --long a-long,b-long:,c-long:: \
     -n 'example.bash' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
#set 会重新排列参数的顺序，也就是改变$1,$2...$n的值，这些值在getopt中重新排列过了
eval set -- "$TEMP"

#经过getopt的处理，下面处理具体选项。

while true ; do
        case "$1" in
                -a|--a-long) echo "Option a" ; shift ;;
                -b|--b-long) echo "Option b, argument \`$2'" ; shift 2 ;;
                -c|--c-long)
                        # c has an optional argument. As we are in quoted mode,
                        # an empty parameter will be generated if its optional
                        # argument is not found.
                        case "$2" in
                                "") echo "Option c, no argument"; shift 2 ;;
                                *)  echo "Option c, argument \`$2'" ; shift 2 ;;
                        esac ;;
                --) shift ; break ;;
                *) echo "Internal error!" ; exit 1 ;;
        esac
done
echo "Remaining arguments:"
for arg do
   echo '--> '"\`$arg'" ;
done
```

## demo
```bash
#!/bin/bash
# lu-cli useage
usage(){
  echo ""
  echo  "   Usage: `basename $0 .sh` <command>\n\n"
  echo  "   Commands:\n"
  echo  "     test|t [options]        测试"
  echo  "   Options:\n"
  echo  "   -h, --help output usage information\n"
  exit 1
}
# 初始化模板 usage
testUsage(){
  echo ""
  echo  "   Usage: test|t [options]\n"
  echo  "   测试\n"
  echo  "   Options:\n"
  echo  "   -h, <help>         output usage information"
  echo  "   -a, <testa>        （可选）可选字段"
  echo  "   -b, <testb>        （必选）必选字段\n"
  exit 1
}


# 处理 Test 逻辑
testHandler(){
  # 定义本地变量
  local help
  local a
  local b
  shift
  while getopts :ha:b: option
  do
    case $option in
      h)
        help="y"
        ;;
      a)
        a="$OPTARG"
        ;;
      b)
        b="$OPTARG"
        ;;
      \?)
        echo "    error: unknown option"
        exit 1
        ;;
    esac
  done
  if [[ "$help" == "y" ]]; then
    testUsage
  fi
  if [[ -z "$b" ]]; then
    echo ""
    echo "    error: option \`-b testb\` argument missing\n"
    exit 1
  fi
  #todo 处理初始化
  echo "todo"
}

if [[ $# -eq 0 ]]; then
  usage
fi

# 遍历参数
case "$1" in
  "test"|"t")
    testHandler $@
    ;;
  "-h"|"--help")
    usage
    ;;
  *)
    echo ""
    echo "    error: unknown option \`$1\`\n"
esac
```






