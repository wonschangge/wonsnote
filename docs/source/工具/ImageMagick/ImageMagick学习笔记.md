```
��ӭ��ͬ�о�ImageMagick
Email:sxw2k@sina.com
sxw
                                                        2011�����
```
 

## ImageMagickѧϰ�ʼ�

-------------------------------------------------------------------

ע�⣺ImageMagick������֧�ֲ��ã��ļ����У�һ����Ҫ�����ģ�����ᱨ���мǣ�

-��������  +�رտ��أ��ָ���ǰ��

convert

convert����˼����Ƕ�ͼ�����ת��������Ҫ������ͼ����и�ʽ��ת����ͬʱ�����������š����С�ģ������ת�Ȳ�����
��ʽת��

����� foo.jpg ת��Ϊ foo.png��ת�������ƻ�ԭͼ��

```
convert foo.jpg foo.png
```
 

Mogrify

```
mogrify -format png *.jpg
```

������jpg�ļ�ת����png��ʽ�����ƻ�Դ�ļ����൱������ת���ˣ�

ע�⣺

```
mogrify -format png *.gif
```

���gif�ļ���ÿһ֡��ת����png�ļ��������ɺܶ��ļ�

convert�����԰Ѷ�����Ƭת����pdf��ʽ��

```
convert *.jpg foo.pdf
convert test.gif test.jpg �����ɺܶ���test��ͷ��ͼƬ�ļ�
```
=>��С����

Ϊһ����ͨ��С��ͼƬ��һ������ͼ

```
convert -resize 100x100 foo.jpg thumbnail.jpg
```

Ҳ�����ðٷֱ�,��Ϊֱ�ۣ�

```
convert -resize 50%x50% foo.jpg thumbnail.jpg  ��50%x50%����ĸx��
```

convert���Զ��ؿ���������ͼ���Сʱͼ��ĸ߿�ı�����Ҳ����˵�µ�ͼ��ĸ߿����ԭͼ��ͬ�� 

������������ͼ��

```
mogrify -sample 80x60 *.jpg
```

ע�⣬�������Ḳ��ԭ����ͼƬ������������ڲ���ǰ���Ȱ����ͼƬ����һ�¡�

```
convert -sample 25%x25% input.jpg output.jpg
```

�ȱ�������
=>�ӱ߿�

��һ����Ƭ�����ܼ��ϱ߿򣬿����� -mattecolor ������

```
convert -mattecolor "#000000" -frame 60x60 yourname.jpg rememberyou.png
```
���У�"#000000"�Ǳ߿����ɫ���߿�Ĵ�СΪ60x60

=>��ͼƬ�ϼ�����

```
convert -fill green -pointsize 40 -draw "text 10,50 charry.org" 2.jpg 222.jpg
```

����������ھ���ͼƬ�����Ͻ�10x50��λ�ã�����ɫ����д��charry.org�������Ҫָ��������壬������-font������

���ߣ�

```
convert 1.png -fill white -pointsize 13 -draw "text 10,15 ��lifesinger 2006��" 2.png
```

=>ģ��


��˹ģ��:

```
convert -blur 80 foo.jpg blur.png
```

-blur��������������-blur 80x5��������Ǹ�5��ʾ����Sigma��ֵ�������ͼ�������Ҳ��̫�������֮������ֵ��ģ����Ч����ؼ������ã�Ч��������


=>��ת


���·�ת��

```
convert -flip foo.png bar.png
```

���ҷ�ת��

```
convert -flop foo.png bar.png
```

=>��ɫ
�γɵ�Ƭ�����ӣ�

```
convert -negate foo.png bar.png
```

��ɫ
��ͼƬ��Ϊ�ڰ���ɫ��

```
convert -monochrome foo.png bar.png
```

������

```
convert -noise 3 foo.png bar.png
```

�ͻ�Ч��
���ǿ���������ܣ���һ����ͨ��ͼƬ�����һ���ͻ���Ч���ǳ��ı���

```
convert -paint 4 foo.png bar.png
```
 
��ɫ��

��ɫ�ǽ�ÿ�����ص���ɫ��ָ����ɫ��ϵĹ��̡���Ч���Ĳ�������Ҫ������ϵ���ɫ��������һ���ٷ����������ֱ����ں�ɫ����ɫ����ɫ����Ҳ�����������ٷ�����ָ�����������Ҳ�����ṩ����ʵ��ֵ�е�һ����Ҫָ������ֵ��ÿ��ֵ�ֱ�����ɫ����ɫ����ɫ����������ʹ�� red/green/blue ��ʽ�Ĳ��������磬 10/20/30 ��ζ�ź�ɫ��ֵ�� 10����ɫֵΪ 20 ����ɫֵΪ 30����Ҳ���������������ʹ�ðٷ���

```
convert -colorize 255 input.jpg output.jpg
convert -colorize 100/0/125 input.jpg output.jpg
```
 
�ڱ�Ч��

�ڱ�Ч��ģ������ͼ������ı���������ڶ������Ρ����õĲ����������������ڱ�Ч������

```
convert -implode 1 input.jpg output.jpg
```
 
�ع⣬ģ�⽺Ƭ�ع�

```
convert -solarize 42 input.jpg output.jpg
```
 
��ɢ

spread ��ͼ��֮��������������ƶ����ء����õĲ����Ǳ��Ƶ���ѡ���λ�õ���������Ĵ�С��������ָ�����������������Ƴ̶�

```
convert -spread 5 input.jpg output.jpg
```
 
������Ч����`convert -sample 10% -sample 1000% input.jpg output.jpg`


�������ҽ�ͼƬˮƽ������

```
convert +append *.jpg result.jpg
```
 
��

```
convert -size 350x500 xc:black composite.jpg
composite -geometry +0+0 composite.jpg image1.gif composite.jpg
composite -geometry +100+0 composite.jpg image2.gif composite.jpg
composite -geometry +0+300 composite.jpg image3.gif composite.jpg
composite -geometry +0+375 composite.jpg image4.gif composite.jpg
```

��ת
��һ��ͼƬ����תһ���ĽǶȣ�

```
convert -rotate 30 foo.png bar.png
```
  
�����30����ʾ������ת30�ȣ����Ҫ������ת���������Ǹ�����

̿��Ч��:

```
convert -charcoal 2 foo.png bar.png
```

�γ�̿�ʻ���˵��Ǧ�ʻ���Ч�������� -charcoal ѡ��Ĳ�������ֵ������Ӧ���ڸ�ͼ��ġ�̿�ʡ���������Ҳ���ӻ�����ͼ��Ĺ��̡�


ɢ��
ë����Ч����

```
convert -spread 30 foo.png bar.png
```

����
��ͼƬ��������Ϊ���գ���ͼƬŤת���γ����е�Ч����

```
convert -swirl 67 foo.png bar.png
```

͹��Ч��
��-raise������͹�ߣ�

```
convert -raise 5x5 foo.png bar.png
```

ִ�к���ῴ������Ƭ�����ܻ�һ��5x5�ıߣ������Ҫһ������ȥ�ıߣ���-raise��Ϊ+raise�Ϳ����ˡ���ʵ͹�ߺͰ��߿��������𲢲��Ǻܴ� 
ΪͼƬ���һЩע����Ϣ��

```
convert -font Arial -stroke green -fill red -draw "text 50,60 www.hist.edu.cn" -pointsize 14 07.jpg hist.png
```
 
���ͣ�

```
-draw ��text 10,10  String"  ����ͼƬ���Ͻ�Ϊԭ�������10,10λ�ô��������
-font ָ������
-stroke ����õ���ɫ��
-fill ����õ���ɫ��������none�Ϳ��Ի����������ˣ�
-pointsize �������ش�С��
-font Arial ��ע�͵���������ΪArial��Ҳ�����ڴ˴�ָ�������ļ���·����������ʹ��λ�ڷǱ�׼λ�õ���������ɸ�����ģ�
```

```
convert -font c:\windows\fonts\1900805.ttf -fill white -pointsize 36 -draw ��text 10,475 ��ylmf.com���� floriade.jpg stillhq.jpg
```

```
-fill white �ð�ɫ�����Ǳ�׼�ĺ�ɫ�������ĸ��
-pointsize 36 �Ե�Ϊ��λָ����ĸ�Ĵ�С��һӢ����� 72 �㡣
```
 
```
convert -font fonts\1900805.ttf -fill white -pointsize 36 -draw 'text 10,475 "stillhq.com"' floriade.jpg stillhq.jpg
```

�����ǽ����

����ǵ�ͼ��


-fill white �ð�ɫ�����Ǳ�׼�ĺ�ɫ�������ĸ��

��ɢ��Ӧ��̿��Ч����

```
convert -sample 50%x50% -spread 4 -charcoal 4 input.jpg output.jpg
```
 

����5�����ؿ�ĺ�ɫ�߿�

```
convert -bordercolor red -border 5x5 input.jpg output.jpg
convert -list color �г���߿��õ���ɫ
```

������ʹ�����·�����ָ�����Լ�����ɫ�ˣ����� R ��ʾ��ɫֵ��G ��ʾ��ɫֵ��B ��ʾ��ɫֵ��A �� alpha��͸���ȣ�ֵ��

```
#RGB - (R,G,B ��ʮ����������ÿ�� 4 λ) 
#RRGGBB - (ÿ�� 8 λ) 
#RRRGGGBBB - (ÿ�� 12 λ) 
#RRRRGGGGBBBB - (ÿ�� 16 λ) 
#RGBA - (ÿ�� 4 λ) 
#RRGGBBAA - (ÿ�� 8 λ) 
#RRRGGGBBBAAA - (ÿ�� 12 λ) 
#RRRRGGGGBBBBAAAA - (ÿ�� 16 λ) 
rgb(r,g,b) - (r,g,b ��ʮ������) 
rgba(r,g,b,a) - (r,g,b,a ��ʮ������) 
```

```
convert -mattecolor rgba(255,91,191,1) -frame 2x2 input.jpg out.jpg
```
 
���һЩ�������� -raise ����õ�����Ӱ

```
convert -mattecolor rgb(255,181,197) -frame 5x5+2 input.jpg out.jpg
```
 
��������Σ�

```
convert -mattecolor rgb(255,181,197) -frame 5x5+2+2    input.jpg out.jpg
convert -mattecolor rgb(255,181,197) -frame 25x25+0+25 input.jpg out.jpg
convert -mattecolor rgb(255,181,197) -frame 25x25+25+0 input.jpg out.jpg
```
 
�о��߿�������о���-frame����

composite ���һ��ͼ����ӵ���һ��ͼ����

```
composite -gravity NorthEast w.jpg input.jpg out.jpg
composite -gravity NorthWest w.jpg input.jpg Northwest.jpg
composite -gravity SouthWest w.jpg input.jpg southwest.jpg
composite -gravity SouthEast w.jpg input.jpg southEast.jpg
```
 
���Ե���һ��͸���Ľǣ����ɴ���Բ�ǵ�ͼ��

��ͼƬת����pdf�ļ�

```
convert *.jpg  test.pdf
```

�� `convert  test.pdf  test.png` �ǽ�pdf�е��ļ�������������Ҫ Ghostscript

 

���ɷ�������ͼ��

```
convert -size 20x40 xc:red xc:white xc:blue +append flag.png
```
 
�����ִ������˳��ģ����մ������ҵ�˳������ִ��

```
convert 1.jpg -crop 300x300+0+0 -resize 200x200 -colors 100 +profile "*" 1.png
```

��ʾ����1.jpg�ȴ����Ͻ�(0,0)�ü�һ��300x300�Ĳ��֣�Ȼ����ⲿ����С��200x200��Ȼ�����ɫ������100ɫ���������1.png��"+profile "*""��ζ����ͼƬ�ļ��ﲻ�洢������Ϣ���Լ�СͼƬ�����

ע�⣬-resize����ͼ����ԭͼ���Ӿ���������˲�һ�����ɵ�ͼƬ����ָ���ĳߴ�һ��ƥ�䣬���磬���2.jpg��С��400x200����ô�������������

```
convert 2.jpg -resize 100x100 2.png
```

��ô���ɵ�ͼƬ2.png��ʵ�ʴ�С��100x50��

���õ������У�

```
-crop ��x��+��������+��������꣺�ü�ͼ
-resize ��x��[!]���ı�ߴ磬���ʹ�þ�̾�ţ���ʾ�������Ӿ�������ǿ�иı�ߴ�ƥ������Ŀ�͸�
-colors ��ɫ�����趨ͼƬ���õ���ɫ�������������png��gifͼƬӦָ���������
-quality �������趨jpegͼƬ����������Ƽ�����80������������������ʽ��jpg���������Ӧʡ�ԣ�ʡ�ԵĻ�Ĭ��������95������ͼƬ����
+profile "*"��ͼƬ�в��洢������Ϣ������ʹ�ã���������ͼƬ����
```

����������

```
montage -bordercolor red -borderwidth 3 -label "%f" -tile 5x3 *.jpg montage.jpg
```

```
mogrify -format gif *.jpg
```

������jpg�ļ�ת����gif��ʽ

```
identify -verbose 001.jpg
```

��ʾͼƬ��ϸ��Ϣ

```
identify -format "%wx%h"  001.jpg
```

��ʾͼƬ�Ŀ�͸����������640x480������-format�������������Ҫ�������Ϣ��%w ��ʾͼ���ȣ��� %h ��ʾͼ��߶�

ͼƬĿ¼��visual image directory ��VID���Ĵ�����

```
montage *.jpg directory.vid
```

����

```
convert 'vid:*.jpg' directory.vid
```
 
��ν�gif�ļ�����Ϊһϵ�еĵ���ͼƬ��

```
convert animation.gif framed.gif
```
 
��δ�ͼƬ�ļ��г�ȡ��һ��ͼƬ

```
convert "Image.gif[0]" first.gif 
```
 
��δ���һ�ſհ�ͼƬ

```
convert -size 80x60 xc:"#ddddff" ss.jpg
convert -size 80x60 null:white white.jpg
convert 017.jpg -threshold 100% black.jpg  ����һ����017.jpgͬ��С��ͼƬ����ɫ
convert 017.jpg -threshold 65% black.jpg
```
 

 
```
identify -format "%wx%h" sample.png
```

��ʾͼƬ��͸�

```
convert +adjoin *.jpg frames%d.gif  ����jpgͼƬת����gif��ʽ
```

�������gif����

```
1��convert -delay 20 *.jpg animation.gif
2��convert -delay 20 001.jpg -delay 10 006.jpg -delay 5 007.jpg animation.gif
3��convert 010.jpg -page +50+100 007.jpg -page +0+100 008.jpg animation.gif
4��convert -loop 50 *.jpg animation.gif
```

Imagick�����������и�ʽ��

```
command  [options]  input_image   output_image
command  [options] image1 [options] image2 [options]  output_image
```
 

```
convert -size 40x20 xc:red  xc:blue  -append  -rotate 90  append_rotate.gif
```
 

����һ��һ��2��ͼƬ�����ӵ�һ��Ȼ��������ת90��

```
convert -size 40x20 xc:red  xc:blue -rotate 90  -append   append_rotate.gif
convert -size 40x20 xc:red  xc:blue  -append   append_rotate.gif
convert -size 40x20 xc:red  xc:blue -rotate 90  append_rotate.gif
```

ע������һ����������2��ͼƬ���ᶯ�ģ���

```
convert 06.jpg 07.jpg -append 08.jpg 09.jpg -background skyblue +append temp.jpg
```
 
06.jpg��07.jpg��ֱ���ӣ�08.jpg��09.jpgˮƽ�����ڱ���Ϊ����ɫ��ͼƬ��

 
```
convert -list gravity
```

- None
- Center
- East
- Forget
- NorthEast
- North
- NorthWest
- SouthEast

 
```
identify -ping 000.jpg

# 000.jpg JPEG 670x448 670x448+0+0 DirectClass 8-bit 46.2891kb


identify -format "%k" 000.jpg
# 34426

identify -ping -format "double_width=%[fx:w*2] PI=%[fx:atan(1)*4]" 000.jpg
# double_width=1340 PI=3.14159

convert null: -print "(50 + 25)/5  ==>  %[fx: (50+25)/5 ]\n" null:
# (50 + 25)/5  ==>  15 
```

 


