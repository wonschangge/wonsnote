// ==UserScript==
// @name         显示单个元素
// @namespace    http://tampermonkey.net/
// @version      0.0.1
// @description  显示单个元素，净化心灵
// @author       Chanj Wons(hencins@gmail.com)

// @match        https://www.eet-china.com/mp/a61493.html

// @icon         https://blog-static.cnblogs.com/files/hencins/focus-app-icon.ico
// @grant        none
// @run-at       document-start
// @license      MIT
// ==/UserScript==

"use strict";

function judgeSite(host) {
  switch (host) {
    case "www.eet-china.com":
      return {
        name: "面包板",
        css: `
          body > :not(:nth-child(1)) {
            display: none !important;
          }
          body > :nth-child(1) {
            display: none;
          }
          * {
            animation: none !important;
          }
        `,
        csspost: `
          body > :nth-child(1) {
            display: block;
            margin: 0 !important;
            margin: 5vh 10vw !important;
            list-style: none;
          }
        `,
      };
    default:
      throw new Error("未匹配host:" + host);
  }
}

function hideUselessElementByCssEl(css) {
  const style = document.createElement("style");
  style.innerHTML = css;
  style.id = "hencins_css";
  return style;
}

function embedKeyboardCopy() {
  // 闭包运行
  (() => {
    let keydownList = [];
    onkeydown = (e) => {
      console.log("监听到:", e.key);
      keydownList.push(e.key);
      if (
        keydownList.indexOf("Control") > -1 &&
        keydownList.indexOf("c") > -1
      ) {
        const copytext = getSelectionText();
        console.log("执行拷贝操作", copytext, keydownList);
        navigator.clipboard.writeText(copytext).then(() => {
          console.log("拷贝成功");
        });
      }
    };
    onkeyup = (e) => {
      console.log(keydownList);
      if (e.key === "Control") {
        keydownList = [];
      } else {
        keydownList.splice(keydownList.indexOf(e.key), 1);
      }
    };
  })();

  function getSelectionText() {
    var text = "";
    if (window.getSelection) {
      text = window.getSelection().toString();
    } else if (document.selection && document.selection.type != "Control") {
      text = document.selection.createRange().text;
    }
    return text;
  }
}

function main() {
    console.info("Chanj Wons' purify script loaded");
    const siteinfo = judgeSite(location.host);
    console.info(siteinfo);

    // Style El
    const el = hideUselessElementByCssEl(siteinfo.css);

    const preObserver = new MutationObserver((mutationsList, observer) => {
      if (document.head && document.body) {
        observer.disconnect();
        // 隐藏无用信息元素
        document.head.appendChild(el);
        // 键盘复制粘贴
        embedKeyboardCopy();
      }
    });
    preObserver.observe(document, { subtree: true, childList: true });

    const postObserver = new MutationObserver((mutationsList, observer) => {
      if (
        document.head &&
        document.body &&
        document.querySelector('section[data-tool="mdnice编辑器"][data-website="https://www.mdnice.com"]')
      ) {
        observer.disconnect();

        const el = hideUselessElementByCssEl(siteinfo.csspost);
        document.head.appendChild(el);

        document.body.insertBefore(
          document.querySelector('section[data-tool="mdnice编辑器"][data-website="https://www.mdnice.com"]'),
          document.body.firstChild
        );

        document.body.firstChild.removeChild(document.body.firstChild.firstChild);
        document.body.firstChild.insertBefore(
          document.querySelector("h1.detail-title"),
          document.body.firstChild.firstChild
        );
      }
    });
    postObserver.observe(document, { subtree: true, childList: true });
}

main();
