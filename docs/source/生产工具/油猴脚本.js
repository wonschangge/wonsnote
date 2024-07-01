// ==UserScript==
// @name         常用站点无效信息清除脚本
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  包含站点: CSDN/掘金/脚本之家
// @author       hencins(github - 892108131@qq.com)
// @connect      www.csdn.net
// @connect      www.juejin.cn
// @connect      www.jb51.net
// @connect      www.51cto.com
// @connect      www.zhihu.com
// @match        *://*.csdn.net/*
// @match        *://csdnnews.blog.csdn.net/*
// @match        *://*.juejin.cn/*
// @match        *://*.jb51.net/*
// @match        *://*.51cto.com/*
// @match        *://*.zhihu.com/*
// @match        *://*.cloud.tencent.com/*
// @match        *://www.photopea.com/*
// @icon         https://blog-static.cnblogs.com/files/hencins/focus-app-icon.ico
// @grant        none
// @run-at       document-start
// @license      MIT
// ==/UserScript==

/**
 *
 * @param host {string} location.host
 * @returns {Object}
 *  eg. {
 *          name: ...,
 *          css: ...,
 *      }
 */
function judgeSite(host) {
    switch (host) {
        case 'blog.csdn.net':
        case 'link.csdn.net':
        case 'csdnnews.blog.csdn.net':
            return {
                name: 'CSDN',
                css: `
                    .blog-footer-bottom,
                    .recommend-box,
                    .recommend-nps-box,
                    .csdn-side-toolbar,
                    .box-shadow.mb8,
                    .toolbar-btn.toolbar-btn-vip,
                    .aside-box-footer,
                    .tool-active-list,
                    .data-info.item-tiling,
                    .user-profile-head-banner,
                    .programmer1Box,
                    .aside-box.kind_person, #分类专栏,
                    .hljs-button.signin,
                    .more-toolbox-new,
                    .passport-login-container,
                    .blog-banner,
                    .blog-slide-ad-box,
                    .blog-rank-footer,
                    .csdn-copyright-footer,
                    .blog-nps,
                    .blog-top-banner,
                    .blogTree,
                    .operation .feedback,
                    .weixin-shadowbox, #phone,
                    .csdn-toolbar-box, #phone,
                    .article_info, #phone,
                    .feed-Sign-weixin, #phone,
                    #operate, #phone,
                    #recommend, #phone,
                    .open_app_channelCode.app_abtest_btn_open, #phone,
                    .adsbygoogle,
                    .passport-login-tip-container, #登录弹窗,
                    #toolbarBox,
                    #asideNewNps,
                    #asideWriteGuide,
                    #footerRightAds,
                    #google-center-div,
                    #recommendAdBox,
                    #asideNewComments, #最新评论,
                    #asideHotArticle, #热门文章,
                    #asideArchive, #asideArchive>*, #最新文章,
                    #asideProfile, #博主信息,
                    #asideSearchArticle, #搜索文章,
                    .blog_container_aside, #整个左边aside
                    #blogHuaweiyunAdvert,
                    #blogColumnPayAdvert,
                    #articleSearchTip,
                    #asideCategory,
                    #treeSkill,
                    #dmp_ad_58
                    {
                        display: none !important;
                        visibility: hidden !important;
                    }

                    #userSkin {
                        background: unset !important;
                    }

                    #code,
                    #content_views pre,
                    #content_views pre code {
                        user-select: text !important;
                    }
                `
            }
        case 'juejin.cn':
        case 'link.juejin.cn':
            return {
                name: '掘金',
                css: `
                    .main-header-box, #顶部Tab,
                    .article-suspended-panel, #左侧悬浮按钮,
                     #sidebar-container>*>*:not(.article-catalog), #sidebar中除了article-catalog,
                    .bottom-login-guide, #底部登录,
                    .global-component-box, #全局组件,
                    div[data-jj-helper="comment-container"], #评论,
                    .recommended-area, #建议趋势,
                    .global-float-banner,
                    div#sidebar-container div.sidebar-block.author-block,
                    .content, #无效链接
                    {
                        display: none !important;
                        visibility: hidden !important;
                    }
                `
            }
        case 'www.jb51.net':
            return {
                name: '脚本之家',
                css: `
                   #topbar, #顶部导航,
                   #footer, #尾部信息,
                   #codetool, #弹窗,
                   #comments, #评论,
                   #header > *:not(#logo), #header除了logo,
                   #clearfix:not(#main), #大幅广告,
                   iframe,
                   .clearfix.mtb10,
                   .clearfix.pt10,
                   .clearfix.main,
                   .clearfix.xgcomm,
                   div.main.mt10 .clearfix,
                   .main-right, #大幅广告,
                   #ewm,
                   #shengming,
                   #right-share,
                   #jb51-softs-下载页,
                   #wrapper .tonglan,
                   #xzbtn, #乱七八糟下载按钮,
                   #down1,
                   #da-download .da-download,
                   #download:nth-child(2),
                   #recomc
                   {
                        display: none !important;
                        visibility: hidden !important;
                   }
                   #wrapper, #wrapper #main, .main-left {
                         background: unset !important;
                   }
                   .main-left {
                         width: unset !important;
                   }
                `
            }
        case 'blog.51cto.com':
            return {
                name: '51CTO',
                css: `
                    header, .Header, .minmenu, .Footer,
                    .action-aside-left,
                    .action-box,
                    .comment-box,
                    .copytext2,
                    .detail-content-left > section,
                    .detail-content-right > *:not(.common-fix),
                    .common-fix > *:not(.table-contents),
                    .fixtitle .messbox,
                    #login_iframe_mask,
                    .recommended-area, #建议趋势
                    {
                        display: none !important;
                        visibility: hidden !important;
                    }
                    .detail-content-new {
                        padding: unset !important;
                        background: unset !important;
                    }
                `
            }
        case 'www.zhihu.com':
            return {
                name: '知乎',
                css: `
                .Pc-card.Card, #广告,
                footer[role="contentinfo"], #右侧无用内容,
                div[aria-label="创作中心卡片"],
                div[aria-label="分类入口"],
                div.Card.css-173vipd, #推荐关注,
                div.RichContent button[aria-label="更多"],
                div.ContentItem-actions, #底部删除,
                div.Card.TopstoryItem--advertCard, #广告,
                li.GlobalSideBar-navItem:not(.GlobalSideBar-starItem, .GlobalSideBar-questionListItem), #除了 starItem 和 questionListItem,
                .Reward, #赞赏 {
                        display: none !important;
                        visibility: hidden !important;
                }
                img {
                        opacity: 0.1 !important;
                }
                img:hover {
                        opacity: unset !important;
                }
                `
            }
        case 'cloud.tencent.com':
            return {
                name: "腾讯云",
                css: `
                .com-event-panel,
                .layout-side,
                .cdc-header__capsule,
                .com-widget-operations,
                .com-widget-global2,
                .cdc-widget-global,
                .cdc-layout__side,
                .cdc-widget-global__bubble,
                .cdc-answer-recommend,
                .cdc-footer,
                .cdc-activation-bar,
                .mod-action-bar,
                .cdc-crumb
                {
                        display: none !important;
                        visibility: hidden !important;
                }
                `
            }
        case 'www.photopea.com':
            return {
                name: "photopea",
                css: `
                body > div.flexrow.app > div:nth-child(2)
                {
                        display: none !important;
                        visibility: hidden !important;
                }
                .body, .body .flexrow, div.cmanager + div {
                    width: unset !important;
                }
                div.body > div > div:nth-child(1) {
                    width: calc(200 / 1700 * 100vw) !important;
                }
                div.body > div > div:nth-child(2) > div {
                    width: calc(1500 / 1700 * 100vw) !important;
                }
                .pbody canvas, .panelhead {
                    max-width: unset !important;
                    width: calc(100vw - 38px - 311px) !important;
                }
                `
            }

        default:
            throw new Error('未匹配host:' + host)
    }
}

/**
 *
 * @param location {Object} location
 */
function ignoreOutlinkTransferPage(location) {
    switch (location.host) {
        case "link.csdn.net":
        case "link.juejin.cn":
            location.href = decodeURIComponent(location.search.replace('?target=', ''));
            return true;
        case "cloud.tencent.com":
            if (location.pathname !== "/developer/tools/blog-entry") return false;
            location.href = decodeURIComponent(location.search.replace('?target=', ''));
            return true;
        case "blog.51cto.com":
            if (location.pathname !== "/transfer") return false;
            location.href = decodeURIComponent(location.search.replace('?', ''));
            return true;
        default:
            return false;
    }
}

/**
 *
 * @param document {Object} HTMLElement
 */
function hideUselessElementByCssEl(css) {
    const style = document.createElement('style');
    style.innerHTML = css;
    style.id = 'hencins_css'
    return style;
}

function embedKeyboardCopy() {
    // 闭包运行
    (() => {
        let keydownList = [];
        onkeydown = (e) => {
            console.log('监听到:', e.key)
            keydownList.push(e.key);
            if (keydownList.indexOf('Control') > -1 && keydownList.indexOf('c') > -1) {
                const copytext = getSelectionText();
                console.log('执行拷贝操作', copytext, keydownList)
                navigator.clipboard.writeText(copytext).then(() => {
                    console.log('拷贝成功')
                })
            }
        }
        onkeyup = (e) => {
            console.log(keydownList)
            if (e.key === 'Control') {
                keydownList = [];
            } else {
                keydownList.splice(keydownList.indexOf(e.key), 1);
            }
        }
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

/**
 *
 * @param document {Object} HTMLElement
 */
function redrawSimpleWatermarkBackground(element, words) {
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');
    const width = 200;
    const height = 200;
    canvas.width = width;
    canvas.height = height;

    ctx.fillStyle = 'white'; // 'rgba(144, 238, 144, 44)';
    ctx.fillStyle = '#96C79E'; // 苹果绿
    ctx.fillRect(0,0,width,height);
    ctx.font="20px Georgia";
    ctx.fillStyle = '#00000010'; // 灰白色

    // 网格线辅助
    // ctx.beginPath()
    // ctx.moveTo(0, height/2);//移动到某个点；
    // ctx.lineTo(width, height/2);//中点坐标；
    // ctx.moveTo(width/2,0);
    // ctx.lineTo(width/2,height);
    // ctx.lineWidth = '1';//线条 宽度
    // ctx.strokeStyle = 'blue';//rgba(0,222,255,.5)
    // ctx.stroke();//描边
    // ctx.moveTo(0,0);

    // 水印站点ID
    ctx.rotate(-45 * Math.PI / 180);
    ctx.fillText(words, -115, 79); // 左 - 右
    ctx.fillText(words, 26.5, 221); // 右 - 左
    ctx.fillText(words, 26.5, 79); // 上
    ctx.fillText(words, -115, 221); // 下
    var blob = canvas.toDataURL('image/png')
    if (element instanceof Array) {
        for (const el of element)
            element.style = `background: url(${blob}) repeat !important;`;
    } else {
        element.style = `background: url(${blob}) repeat !important;`;
    }
    // document.body.appendChild(canvas);
    // element.style = `background: #fff !important;`;
    // canvas.toBlob(function(blob) {
    //     element.style = `background: url(${URL.createObjectURL(blob)}) repeat !important;`;
    // }, 'image/png', 0.8);
}

(function() {
    'use strict';

    // Your code here...
    console.info('汪淼的常用站点无效信息清除脚本 loaded');
    const siteinfo = judgeSite(location.host)
    console.info(siteinfo)

    // 避开外链中转页
    if (ignoreOutlinkTransferPage(location)) return;

    // Style El
    const el = hideUselessElementByCssEl(siteinfo.css);


    //window.addEventListener('load', () => console.log(1, document.children[0].children));
    //document.addEventListener('DOMContentLoaded', () => console.log(2, document.children[0].children));
    //document.addEventListener('readystatechange', () => console.log(3, document.children[0].children));

    const observer = new MutationObserver((mutationsList, observer) => {
        console.log(mutationsList)
        if (document.head && document.body) {
            observer.disconnect();

            // 隐藏无用信息元素
            document.head.appendChild(el);

            // 键盘复制粘贴
            embedKeyboardCopy();

            // 重绘简易带水印背景
            redrawSimpleWatermarkBackground(document.body, siteinfo.name);
        }
    });
    observer.observe(document, { subtree: true, childList: true });
})();