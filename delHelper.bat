@ECHO OFF
COLOR 5
TITLE 禁用助手
setlocal enabledelayedexpansion

rem 计算“当前所在路径”字符串的长度
set countStr=%cd%
call :fun_counting
rem 加 1，作为当前文件夹路径字符串长度，因为还有个“\”
set /a countOfPath_=!count!+1
rem 加 10，作为 data 文件夹路径字符串长度
set /a countOfPath=!count!+15

rem 正式运行
:mainSurface
rem 显示选项与界面
cls
echo 禁用助手
echo LIB临时工作室出品
echo 槑^(méi^)头脑 修改版
echo ---
echo 使用方法
echo 输入功能前面的数字再按回车
echo ---
echo 功能列表

rem 将“.\delHelperData”文件夹内的所有文件作为选项显示出来
for /r ".\delHelperData" %%i in (*.txt) do (
	set pathOfMe=%%i

	rem 用 for 循环删除路径，保留文件名
	for /l %%j in (1,1,!countOfPath!) do (
		set pathOfMe=!pathOfMe:~1!
	)

	echo !pathOfMe!
)

echo 0.退出
echo ---

rem 等待输入
set cont=啥也没有
set /p cont=^>

rem 计算输入字符长度
set countStr=!cont!
call :fun_counting
set /a countOfCont=!count!

echo ---

rem ↓如果为“0”，则退出
if '!cont!' == '0' (
	goto end
rem ↓如果为“啥也没有”，则提示并重来
) else if '!cont!' == '啥也没有' (
	echo 请输入数字
	pause > nul
	goto mainSurface
rem ↓否则判断选项
) else (
	rem 依次对比选项与文件
	for /r ".\delHelperData" %%i in (*.txt) do (
		rem 删除路径，保留文件名
		set pathOfMe=%%i
		for /l %%j in (1,1,!countOfPath!) do (
			set pathOfMe=!pathOfMe:~1!
		)

		rem 调用 fun_strHead 函数（在最下面），进行判断
		set strl=!pathOfMe!
		set strs=!cont!
		call :fun_strHead
		set success=!isHead!

		rem 如果找到对应文件，则下一步
		if '!success!' == '1' (
			set filepath=%%i

			rem 删除绝对路径，转为相对路径（为了防止绝对路径有空格）
			for /l %%j in (1,1,!countOfPath_!) do (
				set filepath=!filepath:~1!
			)
			set filepath=.\!filepath!

			rem 读取 txt 文件内容，获取 json 文件路径
			set num_c=0
			for /f %%j in (!filepath!) do (
				rem 当以“//”开头时，视为注释，不予处理
				set strl=%%j
				set strs=//
				call :fun_strHead
				set isComment=!isHead!
				if not '!isComment!'=='1' (

					rem 开启状态（enable）时，使用该变量，后缀为 .json
					set filepath_enable=.\%%j
					rem 关闭状态（disable）时，使用该变量，后缀为 .disabled
					set filepath_disable=!filepath_enable:~0,-5!.disabled

					rem ↓判断为开启
					if '!num_c!' == '1' (
						if EXIST !filepath_enable! (
							ren !filepath_enable! *.disabled
						) else (
							echo !filepath_enable! 文件不存在，请检查
						)
					rem ↓判断为关闭
					) else if '!num_c!' == '2' (
						if EXIST !filepath_disable! (
							ren !filepath_disable! *.json
						) else (
							echo !filepath_disable! 文件不存在，请检查
						)
					rem ↓循环中的第一次不但要改文件后缀，还要判断开关状态
					) else if '!num_c!' == '0' (
						if EXIST !filepath_enable! (
							ren !filepath_enable! *.disabled
							set num_c=1
						) else if EXIST !filepath_disable! (
							ren !filepath_disable! *.json
							set num_c=2
						)
					)
				)
			)

			rem 显示成功操作，并返回选项界面
			if '!num_c!' == '1' (
				echo 已成功关闭该项
				pause > nul
				goto mainSurface
			) else if '!num_c!' == '2' (
				echo 已成功开启该项
				pause > nul
				goto mainSurface
			rem ↓此处为以防万一
			) else (
				echo 出问题了
				echo num_c=!num_c!
				pause > nul
				goto end
			)
		)
	)

	rem 没找到对应文件，判断输入无效
	echo 无效输入，请重新输入
	pause > nul
	goto mainSurface

rem  --------- 以下为函数 ---------

rem  === fun_counting 开始 ===
rem  功能：计算字符串长度的函数
rem  输入参数：
rem      countStr 待测字符串
rem  输出参数：
rem      count 字符串长度
goto end
:fun_counting
set /a count=0

:counting
if "!countStr!"=="" (
    goto out_of_fun_counting
)
set "countStr=!countStr:~1!"
set /a count+=1
goto counting

:out_of_fun_counting
rem  === fun_counting 结束 ===

rem  === fun_strHead 开始 ===
rem  功能：判断 strl 的开头是不是 strs 的函数
rem  输入参数：
rem      strl 长字符串
rem      strs 短字符串
rem  输出参数：
rem      isHead 为 0 则否，为 1 则是，为 2 则 strs 为空
rem  fun_strHead 开始
goto end
:fun_strHead
if "!strs!" == "" (
    set /a isHead=2
    goto out_of_fun_strHead
)
set /a isHead=1

:strHead
set strs_=!strs:~0,1!
set strl_=!strl:~0,1!
if !strs_! == !strl_! (
    set strs=!strs:~1!
    set strl=!strl:~1!
    if "!strs!" == "" (
        goto out_of_fun_strHead
    ) else (
        goto strHead
    )
) else (
    set /a isHead=0
    goto out_of_fun_strHead
)


:out_of_fun_strHead
rem  === fun_strHead 结束 ===

:end
