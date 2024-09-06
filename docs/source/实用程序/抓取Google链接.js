var a_elements = document.querySelectorAll('a[jsname="UWckNb"]');
var i;
var arialist = '';
var dir = "嵌入式系统联谊会";
for (i = 0; i < a_elements.length; i++) {
    var a = a_elements[i]
    href = a.href;
    out = a.querySelector('h3').textContent;
    out = out.replace(/'/g, '')
    out = out.replace(/\//g, '_')
    out = out.replace(/\s\.\.\./g, '')
    arialist += `${href}\n\tdir=${dir}\n\out=${out}.pdf\n`
}

