@ECHO OFF
COLOR 5
TITLE ��������
setlocal enabledelayedexpansion

rem ���㡰��ǰ����·�����ַ����ĳ���
set countStr=%cd%
call :fun_counting
rem �� 1����Ϊ��ǰ�ļ���·���ַ������ȣ���Ϊ���и���\��
set /a countOfPath_=!count!+1
rem �� 10����Ϊ data �ļ���·���ַ�������
set /a countOfPath=!count!+15

rem ��ʽ����
if EXIST pack.mcmeta (
    :mainSurface
    rem ��ʾѡ�������
    cls
    echo ��������
    echo LIB��ʱ�����ҳ�Ʒ
    echo ��^(m��i^)ͷ�� �޸İ�
    echo ---
    echo ʹ�÷���
    echo ���빦��ǰ��������ٰ��س�
    echo ---
    echo �����б�

    rem ����.\delHelperData���ļ����ڵ������ļ���Ϊѡ����ʾ����
    for /r ".\delHelperData" %%i in (*.txt) do (
        set pathOfMe=%%i

        rem �� for ѭ��ɾ��·���������ļ���
        for /l %%j in (1,1,!countOfPath!) do (
            set pathOfMe=!pathOfMe:~1!
        )

        echo !pathOfMe!
    )

    echo 0.�˳�
    echo ---

    rem �ȴ�����
    set cont=ɶҲû��
    set /p cont=^>

    rem ���������ַ�����
    set countStr=!cont!
    call :fun_counting
    set /a countOfCont=!count!

    echo ---

    rem �����Ϊ��0�������˳�
    if '!cont!' == '0' (
        goto end
    rem �����Ϊ��ɶҲû�С�������ʾ������
    ) else if '!cont!' == 'ɶҲû��' (
        echo ����������
        pause > nul
        goto mainSurface
    rem �������ж�ѡ��
    ) else (
        rem ���ζԱ�ѡ�����ļ�
        for /r ".\delHelperData" %%i in (*.txt) do (
            rem ɾ��·���������ļ���
            set pathOfMe=%%i
            for /l %%j in (1,1,!countOfPath!) do (
                set pathOfMe=!pathOfMe:~1!
            )

            rem ���� fun_strHead �������������棩�������ж�
            set strl=!pathOfMe!
            set strs=!cont!
            call :fun_strHead
            set success=!isHead!

            rem ����ҵ���Ӧ�ļ�������һ��
            if '!success!' == '1' (
                set filepath=%%i

                rem ɾ������·����תΪ���·����Ϊ�˷�ֹ����·���пո�
                for /l %%j in (1,1,!countOfPath_!) do (
                    set filepath=!filepath:~1!
                )
                set filepath=.\!filepath!

                rem ��ȡ txt �ļ����ݣ���ȡ json �ļ�·��
                set num_c=0
                for /f %%j in (!filepath!) do (
                    rem ���ԡ�//����ͷʱ����Ϊע�ͣ����账��
                    set strl=%%j
                    set strs=//
                    call :fun_strHead
                    set isComment=!isHead!
                    if not '!isComment!'=='1' (

                        rem ����״̬��enable��ʱ��ʹ�øñ�������׺Ϊ .json
                        set filepath_enable=.\%%j
                        rem �ر�״̬��disable��ʱ��ʹ�øñ�������׺Ϊ .disabled
                        set filepath_disable=!filepath_enable:~0,-5!.disabled

                        rem ���ж�Ϊ����
                        if '!num_c!' == '1' (
                            if EXIST !filepath_enable! (
                                ren !filepath_enable! *.disabled
                            ) else (
                                echo !filepath_enable! �ļ������ڣ�����
                            )
                        rem ���ж�Ϊ�ر�
                        ) else if '!num_c!' == '2' (
                            if EXIST !filepath_disable! (
                                ren !filepath_disable! *.json
                            ) else (
                                echo !filepath_disable! �ļ������ڣ�����
                            )
                        rem ��ѭ���еĵ�һ�β���Ҫ���ļ���׺����Ҫ�жϿ���״̬
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

                rem ��ʾ�ɹ�������������ѡ�����
                if '!num_c!' == '1' (
                    echo �ѳɹ��رո���
                    pause > nul
                    goto mainSurface
                ) else if '!num_c!' == '2' (
                    echo �ѳɹ���������
                    pause > nul
                    goto mainSurface
                rem ���˴�Ϊ�Է���һ
                ) else (
                    echo ��������
                    pause > nul
                    goto end
                )
            )
        )

        rem û�ҵ���Ӧ�ļ����ж�������Ч
        echo ��Ч���룬����������
        pause > nul
        goto mainSurface
    )
) else (
    echo ��ǰ·������
    echo ��鿴ʹ��˵���������������ַ�����ȷλ�á�
    pause > nul
)

rem  --------- ����Ϊ���� ---------

rem  === fun_counting ��ʼ ===
rem  ���ܣ������ַ������ȵĺ���
rem  ���������
rem      countStr �����ַ���
rem  ���������
rem      count �ַ�������
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
rem  === fun_counting ���� ===

rem  === fun_strHead ��ʼ ===
rem  ���ܣ��ж� strl �Ŀ�ͷ�ǲ��� strs �ĺ���
rem  ���������
rem      strl ���ַ���
rem      strs ���ַ���
rem  ���������
rem      isHead Ϊ 0 ���Ϊ 1 ���ǣ�Ϊ 2 �� strs Ϊ��
rem  fun_strHead ��ʼ
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
rem  === fun_strHead ���� ===

:end
