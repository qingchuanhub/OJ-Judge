#!/bin/bash
set -euo pipefail

# 接收参数：题目编号、提交ID
problem_id=$1
submission_id=$2

# 进入题目目录
cd "problems/$problem_id"

# 编译 C++ 代码（假设用户代码存储在 user_code.cpp）
g++ -std=c++17 -O2 -Wall ../../user_code.cpp -o program
# 如果编译失败，将错误信息写入结果
if [ $? -ne 0 ]; then
    echo "COMPILE_ERROR" > "../../results/$submission_id.txt"
    exit 1
fi

# 运行并计时（5 秒超时）
if timeout 5s ./program < test.in > user_out.txt 2> err.txt; then
    # 比较输出（忽略行尾空格）
    if diff -wB user_out.txt test.out > /dev/null; then
        echo "ACCEPTED" > "../../results/$submission_id.txt"
    else
        echo "WRONG_ANSWER" > "../../results/$submission_id.txt"
        diff -wB user_out.txt test.out >> "../../results/$submission_id.txt"
    fi
else
    if [ -s err.txt ]; then
        echo "RUNTIME_ERROR" > "../../results/$submission_id.txt"
        cat err.txt >> "../../results/$submission_id.txt"
    else
        echo "TIME_LIMIT_EXCEEDED" > "../../results/$submission_id.txt"
    fi
fi