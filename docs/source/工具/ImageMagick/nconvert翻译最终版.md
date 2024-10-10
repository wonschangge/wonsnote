Usage : nconvert [options] file ...

```
 Options :
-quiet            : ����ʾ���������Ϣ
-info             : ֻ��ʾ��Ϣ
-fullinfo         : ��ʾȫ����Ϣ�������������Ϣ
-v[.]             : �߳�ģʽ



          -in format        : ����ͼƬ��ʽ��jpg��bmp
          -page num         : ҳ��/ҳ��
          -xall             : ��ȡ����ͼ��
          -multi            : ������ҳ��ֻ����tiff��dcx��ldf��
          -npcd num         : PCD 0:192x128, 1:384x256, 2:768x512 (default) pcd��ʽ
          -ngrb npic        : HP-48 number of grey : 1, 2 or 4 (default : 1) �Ҷ�:��ֵ
          -no#              : # not used for numeric operator
          -clipboard        : �Ӽ��а嵼��


          -ctype type       : ͨ������ (Raw)
              grey  : �Ҷȣ�Ĭ�ϣ�
              rgb   : ��,��,��
              bgr   : ��,��,��
              rgba  : ��,��,��,͸��
              abgr  : ͸��,��,��,��
              cmy   : ����,���,��ɫ
              cmyk  : ����,���,��ɫ,��ɫ
          -corder order     : ͨ������(Raw) 
              inter : �����(default)
              seq   : ������
              sep   : ������
          -size geometry    : ��͸�(Raw/YUV)
                �����Ǹ�*��+ƫ��

          -i file :           ʹ���ļ���Ϊ�ļ��б�
             => nconvert -i test.txt ��test�ļ��ж�ȡͼƬ����dir /b *.jpg>test.txt���б�

          -n start end step :��ʼ��������������Ϊ��ͼ�����У�

          -o filename       : ����ļ���
              ʹ��#��ָ�����ּ�������λ��
-------------------------------------------------------------------------------------------------
                            => nconvert -o c:\#.jpg *.jpg ��ͼƬ�����ֵ�������
-------------------------------------------------------------------------------------------------
             ʹ��%��ָ��Դ�ļ���
-------------------------------------------------------------------------------------------------
                            => nconvert -o c:\%.jpg *.jpg  ԭ�����Ƶ�c:��
-------------------------------------------------------------------------------------------------
              ʹ��$��ָ��Դ�ļ���
-------------------------------------------------------------------------------------------------
��ʽת����
-------------------------------------------------------------------------------------------------
      -out format       : �����ʽ����
------------------------------------------------------------------------------------------------- 
     ������             => nconvert -out jpeg -truecolors in.bmp  ��bmp��ʽת��Ϊjpeg
-------------------------------------------------------------------------------------------------
          -D            : ɾ��Դ�ļ�
-------------------------------------------------------------------------------------------------  	 
                        => nconvert -D -out jpeg -truecolors in.bmp   ת����ɾ��Դ�ļ�
-------------------------------------------------------------------------------------------------

          -c value          : ѹ����(Ĭ��Ϊ0)
              PDF    : 1 (Fax), 2 (Rle), 3 (LZW), 4(ZIP), 5 (JPEG)
              TIFF   : 1 (Rle), 2 (LZW), 3 (LZW+Prediction)
                       4 (ZLIB)
                       5 (CCITT G3), 6 (CCITT G3-2D), 7 (CCITT G4) only B/W
                       8 (JPEG) only 24/32 bits
              TARGA, Softimage, SGI, PCX, IFF, BMP : 1 (Rle)
          -q value          : JPEG/PNG/FPX/WIC/PDF ������Ĭ��100��
          -clevel value     : pngѹ��ˮƽ��Ĭ��Ϊ6��
          -i                : �����gif/������jpeg
          -icc              : ʹ��icc����
          -keep_icc         : ����Դ�ļ���icc����
          -icc_in filename  : ������ɫ����
          -icc_out filename : �����ɫ����
          -icc_intent value : Ŀ��ֵ
          -icc_bcp          : �ڵ㲹��
          -icc_ie           : ����Ƕ���Icc����
          -merge_alpha      : ʹ��32λ��͸��ɫ���ϲ�͸����
          -transparent value: ͸��������(GIF/PNG) 
          -transpcolor red green blue: ͸������ɫ(GIF/PNG) 
          -opthuff          : �Ż���������
          -bgcolor red green blue: ����ɫ(��ת/��������ʱ�ı���ɫ)
-----------------------------------------------------------------------------------------
���÷ֱ��ʣ�
          -dpi res_dpi      : ����DPI�ֱ���
-----------------------------------------------------------------------------------------
                                  =>  nconvert  -dpi 10 in.jpg
-----------------------------------------------------------------------------------------

          -keepdocsize      : Resize bitmap function of the old and new DPI value
          -keepfiledate     : ����ԭ�ļ�������/ʱ��
          -keepcspace       : ����ԭ��ɫ�ʿռ�,������ܵĻ�


-----------------------------------------------------------------------------------------

          -jpegtrans op     : JPEG����ת��

              rot90  : ��ת90��
              rot180 : ��ת180��
              rot270 : ��ת270��
              exif   : ʹ�ö����exif��ǩ
              vflip  : ��ֱ��ת
              hflip  : ˮƽ��ת

          -jpegcrop x y w h : ������� x,y�����꣬w,h�ǿ��
-----------------------------------------------------------------------------------------
                      =>  nconvert -jpegcrop 600 500 300 450 in.jpg
-----------------------------------------------------------------------------------------

          -clean value : ���Ԫ����(EXIF/IPTC/...)
              1      : ע��
              2      : exif��Ϣ
              4      : XMP
              8      : exif����ͼ
              16     : IPTC
              32     : icc����
              64     : ������־
-----------------------------------------------------------------------------------------

          -rmeta              : �Ƴ�Ԫ���� �����Ƴ�ע�ͣ�
          -rexifthumb         : �Ƴ�exif����ͼ
          -buildexifthumb     : �����ؽ�exif����ͼ
          -thumb width height : ��ȡ����ͼ
----------------------------------------------------------------------------------------------------
                              => nconvert -thumb 160 150 in.jpg ����������ͼ��ԭͼ���ٻ�
----------------------------------------------------------------------------------------------------

          -use_cie   : ʹ��CIE��ɫ(PS/EPS/PDF ghostscript)
          -wflag flag: д���ǣ���־
              os2    : Write OS/2 bmp
              gif87  : Write GIF87a
              hp49   : Write HP49

          -high_res             : ����߷ֱ���(Camera RAW) 
          -ascii                : Ascii (PPM)
          -one_strip            : �ʹ�(TIFF) 
          -raw_autobalance      : �Զ�ƽ��(Camera RAW)
          -raw_camerabalance    : ���ƽ��(Camera RAW)
          -raw_autobright       : �Զ����ȵ���(Camera RAW)
          -raw_gamma value      : ��˹ģ��(Camera RAW)default=0.6
          -raw_brightness value : ����(Camera RAW)default=0.8 
          -raw_redscale value   : ������(Camera RAW)
          -raw_bluescale value  : ������(Camera RAW)
          -ilut file            : ����LUT�ļ�(DPX/Cineon) 
          -olut file            : ���lut�ļ�(DPX/Cineon)

-----------------------------------------------------------------------------------------
���ˮӡ��
-----------------------------------------------------------------------------------------
          -wmfile file      : ��Ϊˮӡ���ļ�
          -wmpos x y        : ˮӡλ��
          -wmflag flag      : ˮӡλ��
              top-left, top-center, top-right
              center-left, center, center-right
              bottom-left, bottom-center, bottom-right
          -wmopacity value  : ˮӡ͸���ȣ�0-100��
---------------------------------------------------------------------------------------------------------------------------------
                           => nconvert -wmpos 100 200 -wmflag center -wmopacity 30 -wmfile sample.jpg origin.jpg
---------------------------------------------------------------------------------------------------------------------------------
                              ��sample.jpg��Ϊˮӡ��ӵ� origin.jpg��������͸����Ϊ30

						   
---------------------------------------------------------------------------------------------------------------------------------			
        Process :
          -32bits             : 32����ת��
          -average size       : ƽ��(3,5,7,9,11,13)
          -autocrop tol r g b : �Զ�����
          -balance r g b      : ɫ��ƽ��
---------------------------------------------------------------------------------------------------------------------------------		  
       =>   nconvert -average 9 in.jpg                      ģ��
       =>   nconvert -balance 255 0 255 in.jpg              ��ɫ
       =>   nconvert -balance 20 65 255 in.jpg              ƫ��ɫ
---------------------------------------------------------------------------------------------------------------------------------
��ɫת����
---------------------------------------------------------------------------------------------------------------------------------
          -binary dither    : ������ת��
                         =>  nconvert -binary halft45   in.jpg
                         =>  nconvert -binary floyd     in.jpg    ��ɫת���ɻ�ɫ
                         =>  nconvert -binary nodither  in.jpg    ��ɫ��
ditherȡֵ��  
              pattern : ����ģʽ
              floyd   : 256ɫ����
              halft45 : �м�ɫ�� 45
              halft90 : �м�ɫ�� 90
              nodither: �޵�ɫ
          -blur percent:ģ���۵�(1...100)
-----------------------------------------------------------------------------------------
���ȵ�����
-----------------------------------------------------------------------------------------
          -brightness value : �޸����ȣ�-100..100��
                            => nconvert -brightness -100 in.jpg �������� 
          -conbright value  : �޸�����(-100...100) 
-----------------------------------------------------------------------------------------
����������
-----------------------------------------------------------------------------------------
          -canvas w h pos   : ���µ���������С��pos��λ�ò���
                            w h �����ǰٷ���(����: -resize 100% 200%)
              ���� #x #y ��Ϊƫ����  x��y��ƫ��ֵ

                  pos top-left, top-center, top-right
                  center-left, center, center-right
                  bottom-left, bottom-center, bottom-right
                  
         =>  nconvert -canvas 200% 200% center in.jpg  # ����������С��λ��
�������� =>��nconvert -canvas 200% 200% center  -bgcolor 255 0 225 in.jpg  # ����������С��λ�ã���������Ϊ��ɫ
����������                                                              
-----------------------------------------------------------------------------------------
          -colours num
          -colors num       : ��������ɫ��ת��(256, 216, 128, 64, 32, 16 or 8)
                            => nconvert -colours 32 in.gif # ��jpg��Ч����ת����gif�ɾ�̬
-----------------------------------------------------------------------------------------
          -contrast value   : �޸ĶԱȶ�(-100...100)
                            => nconvert -contrast 100 in.jpg      # �޸ĶԱȶ�
                            => nconvert -conbright -100 in.jpg    # ����ͼƬ����
          -crop x y w h     : ����ͼƬ
                            => nconvert -crop 20 50 10 20 in.jpg   # ����ͼƬ
                            => nconvert -crop 0 0  1000 800 in.jpg # x��y������
-----------------------------------------------------------------------------------------

          -dither           : Use dither for conversion (Colors and Grey only)

          -deinter k n      : De-interlace
              k : even or odd
              n : dup or int
                           => nconvert -deinter odd int in.jpg

          -edetail          : ���ϸ��

          -eedge percent    : ǿ����Ե (1...100)
                            => nconvert -eedge 100 in.jpg

          -edgedetect type  : ̽���Ե
                              typeֵΪ��light/medium/heavy
                            =>  nconvert -edgedetect medium in.jpg 

          -efocus           : ��߽���

          -emboss           : ����Ч��
                            =>  nconvert -emboss in.jpg

          -embossmore       : ��ǿ����Ч��
                            =>  nconvert -embossmore in.jpg

          -equalize         : ɫ�ʾ���
                            =>  nconvert -Equalize in.jpg
          -frestore         : ���㸴ԭ
          -gamma value      : Modify gamma (0.01<->5.0   �Ҷ�ϵ��
          -gammasat value   : Modify gamma (0.01<->5.0

          -gauss size       : ��˹ģ��(3,5,7,9,11,13..)��ֵԽ��ִ��ʱ��Խ��

          -grey num         : ת���ɻҽ�(256, 128, 64, 32, 16, 8 or 4) 
                            =>  nconvert -grey 256 in.jpg 

          -hls h l s        : �������ȱ��Ͷȣ�ɫ��
                            =>  nconvert -hls 10 12 10 in.jpg

          -lens percent     : ͸���Ŵ�Ч��(1...100)
                            =>  nconvert -lens 100 in.jpg

          -levels b w       : ɫ��
                            =>  nconvert -levels 100 200 in.jpg

          -log              : ���ö�������
                            =>  nconvert -log in.jpg

          -maximum size     : ������(3,5,7,9,11,13)
                            =>  nconvert -maximum 13 in.jpg
          -medianb size     : Median Box filter (3,5,7,9,11,13)      ƽ���й���(��ģ����)
          -medianc size     : Median Cross filter (3,5,7,9,11,13)    ƽ��������ˣ�ģ����
          -minimum size     : Minimum filter (3,5,7,9,11,13)          ��С���� 
                            =>  nconvert -minimum 13 in.jpg

          -mosaic size      : ������Ч��(1...64)   sizeԽ��Ч��Խ����
							=>  nconvert -mosaic 10 in.jpg

          -negate           : ��ƬЧ��
                            => nconvert -negate 64 in.jpg �����ɸ�����������Ч����
          -new bpp w h      : �����µ�λͼ
          -noise reduce     : ������ɫ
          -noise type value 
              uniform   : ����Ψһ��ɫ
              gaussian  : ���Ӹ�˹��ɫ
              laplacian : ����������˹��ɫ
              poisson   : ���Ӳ�����ɫ
                              =>   nconvert -noise poisson 5 in.jpg # ���Ӳ�����ɫ������ƬЧ����
          -normalize        : ʹ��̬��
          -oil size         : �ͻ�Ч��(1...16)
                              =>   nconvert -oil 5 in.jpg   �ͻ�Ч��
          -posterize count  : ɫ������(2...256) 
                              =>   nconvert -posterize 2  in.jpg

          -ratio            : ���ֱ�������
          -rtype            : ���²���
              quick    : ���ٵ���
              linear   : ���Ե���
              hermite  : ���ײ�ֵ����
              gaussian : ��˹
              bell     : ��״��
              bspline  : B����
              mitchell : ��Ъ��
              lanczos  : ����˹��
 
         -rflag      : �����־��С�ߴ�
              incr   : ֻ����
              decr   : ֻ����
              orient : ����Ӧ
-----------------------------------------------------------------------------------------
����ͼƬ��߱ȣ�
-----------------------------------------------------------------------------------------

          -resize w h      : Scale width-height  ��߱�
                             w h �����ǰٷ��� (example: -resize 100% 200%)
            =>  nconvert -resize 100% 200% 97.jpg in.jpg   ������߱�
-----------------------------------------------------------------------------------------

          -rotate_flag      : ��ת��־
              smooth : ʹ��ƽ������ת
-----------------------------------------------------------------------------------------
��תͼƬ��
-----------------------------------------------------------------------------------------

          -rotate degrees   : ˳ʱ����ת
                              => nconvert  -rotate 30 96.jpg  # ˳ʱ����ת30��
                              => nconvert -rotate 30 -bgcolor 255 0 245 in.jpg # ��תʱ����ɫ����Ϊ��ɫ
-----------------------------------------------------------------------------------------

          -sepia            : Sepia

          -sharpen percent  : ��(1...100)
                            =>  nconvert  -sharpen 100 in.jpg

          -shear            : ���˻�
          -slice            : ��ƬЧ��
          -soften percent   : �ữ(1...100)  

          -solarize value   : �ع���(1...255) 
                            => nconvert  -solarize 5  in.jpg

          -spread amount    : ��ɢ(1...32)
                            => nconvert  -spread  20  in.jpg
          -swap type        : ����ͨ��
              rbg   : RGB->RBG
              bgr   : RGB->BGR
              brg   : RGB->BRG
              grb   : RGB->GRB
              gbr   : RGB->GBR
                    => nconvert  -swap rbg in.jpg   # Ч������
                    => nconvert  -swap brg in.jpg   # ��ɫ����
-----------------------------------------------------------------------------------------
������ת��
-----------------------------------------------------------------------------------------

          -swirl degrees    : ������ת(1...360) 
                    => nconvert  -swirl 200 in.jpg   # ��ͼƬ����Ϊ����ת200��
-----------------------------------------------------------------------------------------
��ͼƬ��������֣�
-----------------------------------------------------------------------------------------
          -text string      :��ͼƬ���������
          -text_font name size  :�������ͺʹ�С
          -text_color r g b : ������ɫ
          -text_back r g b  : ���ֱ�����ɫ
          -text_flag pos    : ����λ��
                         top-left, top-center, top-right
                         center-left, center, center-right
                         bottom-left, bottom-center, bottom-right
          -text_pos x y     : λ�ƻ�ƫ����
          -text_rotation degrees : ������ת��

         => nconvert -text_pos 100 150 -text_rotation 30  -text_back 255 255 120 -text  ��ľ�ַ� in.jpg
		    # ��ͼƬ��˳ʱ��30�ȴ�������,���ֱ���Ϊ��ɫ

nconvert -text_font Verdana 72 -text_pos 90 100 -text_rotation 120  -text_flag center -text_color 255 0 255 -text_back 255 255 255 -text ��֪���� *.jpg

        

             
-----------------------------------------------------------------------------------------

          -tile size        : ��ƬЧ��(1...64)
                            => nconvert  -tile 10 in.jpg
          -truecolors������ : ���Ч��
          -truecolours      : ���Ч��

          -xflip            : ˮƽ��ת
                            => nconvert  -xflip   in.jpg

          -yflip            : ��ֱ��ת
                            => nconvert  -yflip   in.jpg

          -waves wavelength phase amount : Waves
              wavelength   : ����(1.0 50.0) 
              phase        : ��λ(0.0 360.0)
              amount       : ����(0.0 100.0)

-----------------------------------------------------------------------------------------

                      =>   nconvert    -waves 15 12 50   in.jpg

-----------------------------------------------------------------------------------------
```