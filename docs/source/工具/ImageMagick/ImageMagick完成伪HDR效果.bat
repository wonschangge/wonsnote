@echo off
convert %1 ( %1 -blur 3x3 ) -compose overlay -composite output.png
REM ����������������¹�����
REM 1��������ͼ�����ģ����
REM 2����ģ��֮���ͼƬ��overlay�ķ�ʽ�����ӵ�����ͼ����ȥ��
