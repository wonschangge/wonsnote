## ImageMagick�Ĺ��ܼ�飺
ԭ�ĵ�ַ��http://bbs.gxsd.com.cn/forum.php?mod=viewthread&tid=253184&page=1����BBDD��ɡ�

- 1��������ת���ָ��˳����,һ����λ
- 2���Զ������г��ױߣ�auto-crop��
- 3���Զ���бУ����deskew��
- 4�������ӱ�ע
- 5������ȥ��ע
- 6��������ˮӡ
- 7������ȥˮӡ
--------------------------------------------------------------------------------------------------

- 1���� a.gif תΪ png ��ʽ

```
convert a.gif a.png
```

��ע�⣬convert ����Ļ�����ʽΪ

```
convert Դ�ļ� [����] Ŀ���ļ�
```

������������У�Դ�ļ��� a.gif��Ŀ���ļ��� a.png������������򵥵ĸ�ʽת�������Բ���Ҫ�м�Ĳ�����
convert �����ڵ����ļ���ת�������������������������÷���

ǰ��˵�� IM ֧�ֳ��� 100 �ֵ��ļ���ʽ��
�������������г� IM ��֧�ֵ����и�ʽ��

```
identify -list format
```

- 2�������ļ��ĸ�ʽת��

```
mogrify -path newdir -format png  *.gif
```

�����������ã��ǽ���ǰĿ¼�µ����� gif �ļ���ת��Ϊ png ��ʽ������������ newdir Ŀ¼�¡�

```
mogrify ���������������ļ���������Ļ�����ʽ�������ģ�
mogrify ���� Դ�ļ�
mogrify ֧�ֻ�����ͨ���������������� a*.png ָ�������� a ��ͷ�� png �ļ���������ࡣ
```

�ٻص��ղŵ����

```
mogrify -path newdir -format png  *.gif
```

����� -path �� -format ��������ѡ��Ĳ�����
-format ָ��������ļ���ʽ���� -path ��ָ��������ļ�Ŀ¼��

����������ǿ��һ�£�������� -path �����Ļ���mogrify �п��ܻḲ�����Դ�ļ������ǿ���Ƽ���ÿ�� mogrify �����ﶼ���� -path ����������ִ��֮ǰ���ȼ������������ȷ�ԡ�

 

## ͼ������ţ�ʹ�� -resize

IM �кü�������ͼ��ķ�������������ֻ��������� resize ���

��һ��200x304��С��ͼ����СΪ100x152�����������һ�룩��

```
convert page200.png -resize 100x152 page100.png
```

����� 100x152��ָ����Ŀ���ļ��ĳ��Ϳ�

��Ҳ����ָֻ��Ŀ���ļ���ȣ��������ĸ߶Ȼ�ȱ����Ŵ�

```
convert page200.png -resize 100 page100.png
```

����ָֻ���߶ȣ�

```
convert page200.png -resize x152 page100.png
```

�������������������һ���ġ�


������� identify ��������ʾͼ��ĳߴ��Լ�����һЩ��Ϣ��

```
identify page100.png
```
����Ϊ��

```
page100.png PNG 100x152 100x152+0+0 8-bit DirectClass 17.9kb
```

����㻹����ͨ��ָ���ٷֱ�������ͼ��

```
convert page200.png -resize 50% page100.png
convert page200.png -resize 150% page300.png
``` 

- ��������ͼ��

```
mogrify -path newdir -resize 200% *.png
```

����������˼�ǽ���ǰĿ¼�����е� png �ļ����Ŵ�һ��������ŵ� newdir Ŀ¼�С�

��ע�⣬���û�� -path ��䣬�����ɵ� png �ļ����Ḳ��ԭʼ�ļ�����ˣ���ʹ�� mogrify ����ʱ��-path ���������Ǳ���ġ�

���⣬����Ҳ����ע�⵽ mogrify �� convert ��������ʵ��������ͨ�õġ�ͨ�����ǿ������� convert �޸ĵ����ļ����Խ������Ļ����� mogrify ������������

 

## ����ͼ��ļ���

- ʹ�� -crop

```
convert page100.png -crop 50x50+10+10 crop1.png
convert page100.png -crop 50x50+10+10 +repage crop2.png
```

�������������˼������ 10,10 Ϊԭ�㣬��ͼ�ϼ�һ�� 50x50 ��Сͼ��
+repage ������������ͼ���ڲ�����Ϣ���������� identify ����鿴 crop1.png �� crop2.png �Ľ����

```
crop1.png PNG 50x50 100x152+10+10 8-bit DirectClass 4.6kb
crop2.png PNG 50x50 50x50+0+0 8-bit DirectClass 4.56kb
```

���������������Ȼÿ��ʹ�� -crop �����ʱ����Ӧ���� +repage��


- -gravity ���

��ȱʡ����£�ԭ����������ͼ������Ͻǣ�Ҳ������ν�� NorthWest��������� -gravity ������ı�����ķ���

���磺

```
convert page100.png -gravity west -crop 50x50+0+0 +repage crop3.png
convert page100.png -gravity east -crop 50x50+0+0 +repage crop4.png
```

-gravity �Ĳ������� NorthWest, North, NorthEast, West, Center, East, SouthWest, South, SouthEast����Сд���С�

�����������ɨ��ͼ��ʱ�������õ�

```
convert 2pages.png -crop 50%x100% +repage newpage.png
```

ϵͳ�Զ������� newpage-0.png �� newpage-2.png �����ļ���
��ע�⣬�� -crop ��������� 50%x100%�������� 50%x100%+0+0��
��仰����˼���������� 50%x100% �����Ĵ�С��һ�������ȥ�����м�����м��顣
���������� 50%x50%�������ͻ��г� 4 �顣

��������

```
convert page*.png -crop 50%x100% +repage newpaged.png
```

��ע������� d�������������Զ����� newpage001.png newpage002.png newpage003.png �����������ļ���ҳ��˳���ҡ�

- -trim �Զ��г��ױ�

```
convert page100.png -trim +repage trim.png
```

## �ġ���ת��У��

```
convert r90.png -rotate -90 page200.png
```

������ת:

```
mogrify -path newdir -rotate -90 *.png
```

�����ǰ���� -rotate �����ת�ָ�һ����λ��

```
convert r2pages.png -rotate -90 -crop 50%x100% +repage newpage.png
```

- -background ����

```
convert page200.png -background blue -rotate 10 r10.png
```

�� -background �趨��������ɫ����ʱ���õõ�

```
convert -list color
```

��������г����п�ֱ��ʹ�õ���ɫӢ������
IM ֧������ֱ�ʾ��ɫ�ķ������������Ժ��ٽ�����ֱ����Ӣ�������� black, white, red, blue �ȣ������ġ�

- -deskew

```
convert page100.png -background white -deskew 40% deskewed.png
```

-deskew ���������Զ���бУ���������һ���ٷ������ֲ����Ƽ����� 40% ���ֵ(A threshold of 40% works for most images)��

����У��:

```
mogrify -path newdir -background white -deskew 40% *.png
```

## �塢��ɫ����һ��

IM ������������ɫ�ķ������������ȴ������ĵĽ���

```
convert page.png -noop noop.png
```            

- -noop ����ʾʲôҲ������
���������Ȼ��ֻ��Ϊ�˴�����������Ϊ���ô����Ϥһ���м���Ǹ�����ͼ��
�����������꣬��ʾ�任ǰ������ߵ���ɫֵ��ȫһ���������ı䡣����γ���һ��45�ȵĶԽ��ߡ�

```
convert page.png -negate negated.png
```              

- -negate ���ࡣ�ڱ���˰ף��ױ���˺ڡ�
�γ� -45 �ȵ�ֱ�ߡ�
������ע���м�����ϵ��������������ߡ�

```
convert page.png -level 25%,75% p1585.png
convert page.png -level 25% p15.png
```

- -level �����������������������ö��ŷֿ�������1������ 25% ��ʾ��ԭͼ��ɫ����� 25% ��Ϊ�ڣ��ڶ����� 75% ���ʾ�������� 25% Ϊ�ס�ʣ�µ������Ա任��
��ʡ�Եڶ�������ʱ������ȡͬ����ֵ�����������������ʵ������һ�µġ�

```
convert page.png -level 0,85% p0-85.png
```
              
��Ҳ������ +level��

```
convert page.png +level 25% p+25.png
```
               

���⣬-level ���滹���Ը�������������

```
convert page.png -level 0,100%,2.0 p0-100-2.0.png
convert page.png -level 0,100%,0.5 p0-100-2.0.png
convert page.png -level 0,85%,0.5 p0-100-2.0.png
```       

�õ�3������������ gamma ֵ��ֱ�߱��������.


## ������ɫ��������

�����������������ʾ�� ImageMagick �ж��̬��

```
convert logo.png  -fx "(1/(1+exp(10*(.5-u)))-0.0066928509)*1.0092503" sigmoidal.png
```
     

��������
ף���㣬��������һ�������� sigmoidal �����ԶԱȶȱ任��
�ǵģ�ImageMagick ������ô��̬����������������Ĺ�ʽ����ԭʼͼ��������������ı任��
˳��˵һ�£�sigmoidal �任�Ǻ����õĹ��ߣ�����ɨ�����ļ��кܺõ�Ч����
���ǣ�˭�ּǵ�ס��ô���Ĺ�ʽ�أ�
���ģ�ImageMagick �Ѿ������뵽�ˡ�

```
convert logo.png  -sigmoidal-contrast 10,50% logo_sigmoidal.png
```

��������ǰ����һ������ʽ�ﵽ��Ч����һ���ģ����Һ�����졣

ImageMagick �ﻹ�в���������԰����Լʱ�䡣
��������ģ�

```
convert gray_range.jpg  -normalize  normalize_gray.jpg
```

-normalize �������ǰ�ԭͼ����Ĳ��ֱ�ɺڣ������Ĳ��ֱ�ɰף��ɴ�����ǿ�Աȶȡ�

``
convert gray_range.jpg  -contrast-stretch 15%  stretch_gray.jpg
```

-contrast-stretch �����ú� -normalize ��һ���ģ�ֻ�Ƕ��˸��ɵ��ڵĲ�����


## �ߡ���ɫ��������


����������ͼ���ʱ�򳣳�������������⣬ImageMagick ��ʲô�ð취��

```
convert logo.png -colors 64 logo64c.png
```

�����������ɫ����Ϊ 64���㿴�ó����ߵ������𣿷������ǿ�������
������ identify ��һ�����ߵ�����

```
identify *.png
logo.png PNG 202x152 202x152+0+0 8-bit DirectClass 17.4kb
logo64c.png[1] PNG 202x152 202x152+0+0 8-bit PseudoClass 64c 4.84kb
```

һ���� 17.4k��һ���� 4.84k��
����ɹ���

���Ƶ������ -monochrome��

```
convert  logo.png  -monochrome     monochrome.gif
```
 
��ͼƬ��ɺڰ���ɫ��

-threshold

```
convert logo.png     -threshold   -1   threshold_0.gif
convert logo.png     -threshold  25%   threshold_25.gif
convert logo.png     -threshold  50%   threshold_50.gif
convert logo.png     -threshold  75%   threshold_75.gif
convert logo.png     -threshold 100%   threshold_100.gif
```       

-threshold ������������ɫ���绮һ���ߣ����ϵ�Ϊ�ף����µ�Ϊ�ڡ�

 
## �ˡ���ͼ��д��

 

���潲һ�����������������塣

������������Щ������ã�

```
convert -list font > fonts.txt
```

����������ڵ�ǰĿ¼������ fonts.txt �ļ������������п��õ������б�

Ȼ���� label ָ�

```
convert -background lightblue -fill blue -font Candice -pointsize 72 label:Anthony label.gif
``` 

label ��������һ���֡���ע�⣬��ǰ��û�С�-���š������Ҫ����һ���־���˫���Ű������ϡ���������label:"Hello World!"��
-background �� -fill �ֱ��趨���������ֵ���ɫ��
-font �� -pointsize �趨����ʹ�С��

�����������ֱ��֧�����ģ�������Ȱ���Ҫд���ִ浽�ı��ļ�����У�

```
convert -background lightblue -fill blue -font ��������_GBK -pointsize 72 label:@gxsd-utf8.txt gxsd.gif
``` 

ð�ź���� `@` ����������ļ���gxsd-utf8.txt���������ַ�����
��ע�⣺����ļ������ǲ��� Unicode ��־λ�� utf-8 �ļ���

������� caption:

```
convert -background lightblue -fill blue -font Corsiva -pointsize 36 -size 320x caption:"This is a very long caption line." caption.gif
```
 
caption ���÷��� label ��࣬������������������С�

����ļ��ַ�������������ɵ�����ͼƬ�����Ҫ������ͼƬ��ӡ����ô���أ�
�Ǿ��� -annotate:

```
convert page200b.png -font ���� -fill white -undercolor #00000080 -gravity South -annotate 0x0+0+10 @anno-utf8.txt anno.png
```
 
-annotate �ĸ�ʽ�������ģ�

```
01.-annotate {SlewX}x{SlewY}+{X}+{Y} "�ַ���"
```

���� +X+Y�����ڵ����λ�á����븴ϰ�������� -gravity ���÷�����
�� {SlewX}x{SlewY} ���ʾ��б�ĽǶȡ�

 
## �š���ͼ

��ʼ֮ǰ���Ƚ�������� ImageMagick ���ɻ�����

```
convert -size 100x100 xc:blue canvas_blue.gif
convert -size 100x100 xc:rgb(0,0,255) canvas_blue.gif
``` 

xc: ����һ�鵥ɫ�Ļ�������ɫ��ð�ź���� blue �� rgb(0,0,255) ָ�����ߴ��� -size ָ����

```
convert -size 50x50 xc:red xc:blue +append red+blue.gif
convert -size 50x50 xc:red xc:blue -append red-blue.gif
```     

�� append �ϲ�ͼ����ע�� + �� - ������

�������� gradient�����䣺

```
convert  -size 100x100 gradient:  gradient.jpg
convert -size 100x100  gradient:blue gradient_blue.jpg
convert -size 100x100 gradient:red-blue gradient_red_to_blue.jpg
```     

-draw ��������Ļ�ͼָ�

```
convert -size 100x60 xc:skyblue -fill white -stroke black -draw "rectangle 20,10 80,50" draw_rect.gif
``` 

������������һ�� 100x60 ��С������ɫ�����ϣ���һ���׵׺ڱߵĳ����Σ����Ϊ (20,10)���յ�Ϊ (80,50)��

ͨ���Ӳ�ͬ�Ĳ�����-draw ��������Ի������Σ��������㡢ֱ�ߡ�Բ�������ߵȵȡ�������÷�������ĳ��������ƣ���ο�http://www.imagemagick.org/script/command-line-options.php?#draw��

```
convert -size 100x60 xc:skyblue -fill white -stroke black -draw "ellipse 50,30 40,20 0,360" draw_ellipse.gif
convert -size 100x60 xc:skyblue -fill white -stroke black -draw "polyline 40,10 20,50 90,10 70,40" draw_polyline.gif
convert -size 100x60 xc:skyblue -fill white -stroke black -draw "roundrectangle 20,10 80,50 20,15" draw_rrect.gif
convert -size 100x60 xc:skyblue -fill white -stroke black -draw "ellipse 50,30 40,20 45,270" draw_ellipse_partial.gif
convert -size 100x60 xc:skyblue -gravity center -draw "image over 0,0 0,0 'terminal.gif'" draw_image.gif
convert -size 100x60 xc:skyblue -fill white -stroke black -font Candice -pointsize 40 -gravity center -draw "text 0,0 'Hello'" draw_text.gif
```
 