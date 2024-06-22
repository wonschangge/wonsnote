使用fopen
===========================================================

函数声明:

::

    #include <stdio.h>

    FILE *fopen(const char *restrict filename, const char *restrict mode);


mode参数:

* r or rb

    * Open file for reading.

* w or wb
    
    * Truncate to zero length or create file for writing.

* a or ab

  * Append; open or create file for writing at end-of-file.

* r+ or rb+ or r+b

  * Open file for update (reading and writing).

* w+ or wb+ or w+b

  * Truncate to zero length or create file for update.

* a+ or ab+ or a+b

  * Append; open or create file for update, writing at end-of-file.


.. important:: The character 'b' shall have no effect, but is allowed for ISO C standard conformance. 


参考：

* https://pubs.opengroup.org/onlinepubs/007904975/functions/fopen.html
