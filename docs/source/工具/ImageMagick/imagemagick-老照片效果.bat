convert %1 -sepia-tone 75%% ( %1 -fill #FFFFFF -colorize 100%% +noise Random -colorspace gray -alpha on -channel A -evaluate Set 100 ) -compose overlay -composite %2
::ʹ�÷�������������ʾ�������� imagemagick-����ƬЧ��.bat input.jpg output.jpg
REM ��������������¹�����
REM 1��������ͼ��ʹ��sepia-tone�˾�����
REM 2������һ����ɫ�ɰ棬������������ת��Ϊ�Ҷȣ�������alphaͨ��
REM 3������1�Ͳ���2�Ľ��ʹ��overlay�ķ�ʽcompose
