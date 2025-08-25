import{a as y}from"./js.cookie-Cz0CWeBA.js";import{C as oe,a as ne,p as ie,S as re,b as ae,c as se,d as le,e as de,f as we}from"./sharedFrameEvents-0qZ2yOho.js";import{i as ce}from"./colorHelper-DkkSNPxc.js";import{g as ue}from"./_commonjsHelpers-BosuxZz1.js";import"./index-DN3rM4CW.js";const be=`
:root {
  --b-100: #F2F3F7;
  --s-700: #37546D;
}

.woot-widget-holder {
  box-shadow: 0 5px 40px rgba(0, 0, 0, .16);
  opacity: 1;
  will-change: transform, opacity;
  transform: translateY(0);
  overflow: hidden !important;
  position: fixed !important;
  transition: opacity 0.2s linear, transform 0.25s linear;
  z-index: 2147483000 !important;
}

.woot-widget-holder.woot-widget-holder--flat {
  box-shadow: none;
  border-radius: 0;
  border: 1px solid var(--b-100);
}

.woot-widget-holder iframe {
  border: 0;
  color-scheme: normal;
  height: 100% !important;
  width: 100% !important;
  max-height: 100vh !important;
}

.woot-widget-holder.has-unread-view {
  border-radius: 0 !important;
  min-height: 80px !important;
  height: auto;
  bottom: 94px;
  box-shadow: none !important;
  border: 0;
}

.woot-widget-bubble {
  background: #1f93ff;
  border-radius: 100px;
  border-width: 0px;
  bottom: 20px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, .16) !important;
  cursor: pointer;
  height: 64px;
  padding: 0px;
  position: fixed;
  user-select: none;
  width: 64px;
  z-index: 2147483000 !important;
  overflow: hidden;
}

.woot-widget-bubble.woot-widget-bubble--flat {
  border-radius: 0;
}

.woot-widget-holder.woot-widget-holder--flat {
  bottom: 90px;
}

.woot-widget-bubble.woot-widget-bubble--flat {
  height: 56px;
  width: 56px;
}

.woot-widget-bubble.woot-widget-bubble--flat svg {
  margin: 16px;
}

.woot-widget-bubble.woot-widget-bubble--flat.woot--close::before,
.woot-widget-bubble.woot-widget-bubble--flat.woot--close::after {
  left: 28px;
  top: 16px;
}

.woot-widget-bubble.unread-notification::after {
  content: '';
  position: absolute;
  width: 12px;
  height: 12px;
  background: #ff4040;
  border-radius: 100%;
  top: 0px;
  right: 0px;
  border: 2px solid #ffffff;
  transition: background 0.2s ease;
}

.woot-widget-bubble.woot-widget--expanded {
  bottom: 24px;
  display: flex;
  height: 48px !important;
  width: auto !important;
  align-items: center;
}

.woot-widget-bubble.woot-widget--expanded div {
  align-items: center;
  color: #fff;
  display: flex;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Oxygen-Sans, Ubuntu, Cantarell, Helvetica Neue, Arial, sans-serif;
  font-size: 16px;
  font-weight: 500;
  justify-content: center;
  padding-right: 20px;
  width: auto !important;
}

.woot-widget-bubble.woot-widget--expanded.woot-widget-bubble-color--lighter div{
  color: var(--s-700);
}

.woot-widget-bubble.woot-widget--expanded svg {
  height: 20px;
  margin: 14px 8px 14px 16px;
  width: 20px;
}

.woot-widget-bubble.woot-elements--left {
  left: 20px;
}

.woot-widget-bubble.woot-elements--right {
  right: 20px;
}

.woot-widget-bubble:hover {
  background: #1f93ff;
  box-shadow: 0 8px 32px rgba(0, 0, 0, .4) !important;
}

.woot-widget-bubble svg {
  all: revert;
  height: 24px;
  margin: 20px;
  width: 24px;
}

.woot-widget-bubble.woot-widget-bubble-color--lighter path{
  fill: var(--s-700);
}

@media only screen and (min-width: 667px) {
  .woot-widget-holder.woot-elements--left {
    left: 20px;
 }
  .woot-widget-holder.woot-elements--right {
    right: 20px;
 }
}

.woot--close:hover {
  opacity: 1;
}

.woot--close::before, .woot--close::after {
  background-color: #fff;
  content: ' ';
  display: inline;
  height: 24px;
  left: 32px;
  position: absolute;
  top: 20px;
  width: 2px;
}

.woot-widget-bubble-color--lighter.woot--close::before, .woot-widget-bubble-color--lighter.woot--close::after {
  background-color: var(--s-700);
}

.woot--close::before {
  transform: rotate(45deg);
}

.woot--close::after {
  transform: rotate(-45deg);
}

.woot--hide {
  bottom: -100vh !important;
  top: unset !important;
  opacity: 0;
  visibility: hidden !important;
  z-index: -1 !important;
}

.woot-widget--without-bubble {
  bottom: 20px !important;
}
.woot-widget-holder.woot--hide{
  transform: translateY(40px);
}
.woot-widget-bubble.woot--close {
  transform: translateX(0px) scale(1) rotate(0deg);
  transition: transform 300ms ease, opacity 100ms ease, visibility 0ms linear 0ms, bottom 0ms linear 0ms;
}
.woot-widget-bubble.woot--close.woot--hide {
  transform: translateX(8px) scale(.75) rotate(45deg);
  transition: transform 300ms ease, opacity 200ms ease, visibility 0ms linear 500ms, bottom 0ms ease 200ms;
}

.woot-widget-bubble {
  transform-origin: center;
  will-change: transform, opacity;
  transform: translateX(0) scale(1) rotate(0deg);
  transition: transform 300ms ease, opacity 100ms ease, visibility 0ms linear 0ms, bottom 0ms linear 0ms;
}
.woot-widget-bubble.woot--hide {
  transform: translateX(8px) scale(.75) rotate(-30deg);
  transition: transform 300ms ease, opacity 200ms ease, visibility 0ms linear 500ms, bottom 0ms ease 200ms;
}

.woot-widget-bubble.woot-widget--expanded {
  transform: translateX(0px);
  transition: transform 300ms ease, opacity 100ms ease, visibility 0ms linear 0ms, bottom 0ms linear 0ms;
}
.woot-widget-bubble.woot-widget--expanded.woot--hide {
  transform: translateX(8px);
  transition: transform 300ms ease, opacity 200ms ease, visibility 0ms linear 500ms, bottom 0ms ease 200ms;
}
.woot-widget-bubble.woot-widget-bubble--flat.woot--close {
  transform: translateX(0px);
  transition: transform 300ms ease, opacity 10ms ease, visibility 0ms linear 0ms, bottom 0ms linear 0ms;
}
.woot-widget-bubble.woot-widget-bubble--flat.woot--close.woot--hide {
  transform: translateX(8px);
  transition: transform 300ms ease, opacity 200ms ease, visibility 0ms linear 500ms, bottom 0ms ease 200ms;
}
.woot-widget-bubble.woot-widget--expanded.woot-widget-bubble--flat {
  transform: translateX(0px);
  transition: transform 300ms ease, opacity 200ms ease, visibility 0ms linear 0ms, bottom 0ms linear 0ms;
}
.woot-widget-bubble.woot-widget--expanded.woot-widget-bubble--flat.woot--hide {
  transform: translateX(8px);
  transition: transform 300ms ease, opacity 200ms ease, visibility 0ms linear 500ms, bottom 0ms ease 200ms;
}

@media only screen and (max-width: 667px) {
  .woot-widget-holder {
    height: 100%;
    right: 0;
    top: 0;
    width: 100%;
 }

 .woot-widget-holder iframe {
    min-height: 100% !important;
  }


 .woot-widget-holder.has-unread-view {
    height: auto;
    right: 0;
    width: auto;
    bottom: 0;
    top: auto;
    max-height: 100vh;
    padding: 0 8px;
  }

  .woot-widget-holder.has-unread-view iframe {
    min-height: unset !important;
  }

 .woot-widget-holder.has-unread-view.woot-elements--left {
    left: 0;
  }

  .woot-widget-bubble.woot--close {
    bottom: 60px;
    opacity: 0;
    visibility: hidden !important;
    z-index: -1 !important;
  }
}

@media only screen and (min-width: 667px) {
  .woot-widget-holder {
    border-radius: 16px;
    bottom: 104px;
    height: calc(90% - 64px - 20px);
    max-height: 640px !important;
    min-height: 250px !important;
    width: 400px !important;
 }
}

.woot-hidden {
  display: none !important;
}
`,ge=()=>{const e=document.createElement("style");e.innerHTML=`${be}`,e.id="cw-widget-styles",e.dataset.turboPermanent=!0,document.body.appendChild(e)},_=(e,o)=>{const t=document.getElementById(e),c=o.querySelector(`#${e}`);t&&!c&&o.appendChild(t)},M=e=>{_("cw-bubble-holder",e),_("cw-widget-holder",e),_("cw-widget-styles",e)},C=(e,o)=>{e.classList.add(...o.split(" "))},F=(e,o)=>{e.classList.toggle(o)},T=(e,o)=>{e.classList.remove(...o.split(" "))},O=({referrerURL:e,referrerHost:o})=>{u.events.onLocationChange({referrerURL:e,referrerHost:o})},he=()=>{let e=document.location.href;const o=document.location.host,t={childList:!0,subtree:!0};O({referrerURL:e,referrerHost:o});const c=document.querySelector("body");new MutationObserver(n=>{n.forEach(()=>{e!==document.location.href&&(e=document.location.href,O({referrerURL:e,referrerHost:o}))})}).observe(c,t)},A=["standard","expanded_bubble"],N=["standard","flat"],H=["light","auto","dark"],q=e=>A.includes(e)?e:A[0],K=e=>q(e)===A[1],me=e=>N.includes(e)?e:N[0],I=e=>e==="flat",R=e=>H.includes(e)?e:H[0],pe=({eventName:e,data:o=null})=>{let t;return typeof window.CustomEvent=="function"?t=new CustomEvent(e,{detail:o}):(t=document.createEvent("CustomEvent"),t.initCustomEvent(e,!1,!1,o)),t},E=({eventName:e,data:o})=>{const t=pe({eventName:e,data:o});window.dispatchEvent(t)},fe="M240.808 240.808H122.123C56.6994 240.808 3.45695 187.562 3.45695 122.122C3.45695 56.7031 56.6994 3.45697 122.124 3.45697C187.566 3.45697 240.808 56.7031 240.808 122.122V240.808Z",X=document.getElementsByTagName("body")[0],v=document.createElement("div"),x=document.createElement("div"),D=document.createElement("button"),$=document.createElement("button");document.createElement("span");const ve=e=>{if(K(window.$chatwoot.type)){const o=document.getElementById("woot-widget--expanded__text");o.innerText=e}},xe=({className:e,path:o,target:t})=>{let c=`${e} woot-elements--${window.$chatwoot.position}`;const w=document.createElementNS("http://www.w3.org/2000/svg","svg");w.setAttributeNS(null,"id","woot-widget-bubble-icon"),w.setAttributeNS(null,"width","24"),w.setAttributeNS(null,"height","24"),w.setAttributeNS(null,"viewBox","0 0 240 240"),w.setAttributeNS(null,"fill","none"),w.setAttribute("xmlns","http://www.w3.org/2000/svg");const n=document.createElementNS("http://www.w3.org/2000/svg","path");if(n.setAttributeNS(null,"d",o),n.setAttributeNS(null,"fill","#FFFFFF"),w.appendChild(n),t.appendChild(w),K(window.$chatwoot.type)){const b=document.createElement("div");b.id="woot-widget--expanded__text",b.innerText="",t.appendChild(b),c+=" woot-widget--expanded"}return t.className=c,t.title="Open chat window",t},ye=e=>{e&&C(x,"woot-hidden"),C(x,"woot--bubble-holder"),x.id="cw-bubble-holder",x.dataset.turboPermanent=!0,X.appendChild(x)},Ce=e=>{u.events.onBubbleToggle(e),e?E({eventName:oe}):(E({eventName:ne}),D.focus())},S=(e={})=>{const{toggleValue:o}=e,{isOpen:t}=window.$chatwoot;if(t===o)return;const c=o===void 0?!t:o;window.$chatwoot.isOpen=c,F(D,"woot--hide"),F($,"woot--hide"),F(v,"woot--hide"),Ce(c)},Ee=()=>{x.addEventListener("click",S)},Se=()=>{const e=document.querySelector(".woot-widget-holder");C(e,"has-unread-view")},W=()=>{const e=document.querySelector(".woot-widget-holder");T(e,"has-unread-view")};var Y={exports:{}},G={exports:{}};(function(){var e="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",o={rotl:function(t,c){return t<<c|t>>>32-c},rotr:function(t,c){return t<<32-c|t>>>c},endian:function(t){if(t.constructor==Number)return o.rotl(t,8)&16711935|o.rotl(t,24)&4278255360;for(var c=0;c<t.length;c++)t[c]=o.endian(t[c]);return t},randomBytes:function(t){for(var c=[];t>0;t--)c.push(Math.floor(Math.random()*256));return c},bytesToWords:function(t){for(var c=[],w=0,n=0;w<t.length;w++,n+=8)c[n>>>5]|=t[w]<<24-n%32;return c},wordsToBytes:function(t){for(var c=[],w=0;w<t.length*32;w+=8)c.push(t[w>>>5]>>>24-w%32&255);return c},bytesToHex:function(t){for(var c=[],w=0;w<t.length;w++)c.push((t[w]>>>4).toString(16)),c.push((t[w]&15).toString(16));return c.join("")},hexToBytes:function(t){for(var c=[],w=0;w<t.length;w+=2)c.push(parseInt(t.substr(w,2),16));return c},bytesToBase64:function(t){for(var c=[],w=0;w<t.length;w+=3)for(var n=t[w]<<16|t[w+1]<<8|t[w+2],b=0;b<4;b++)w*8+b*6<=t.length*8?c.push(e.charAt(n>>>6*(3-b)&63)):c.push("=");return c.join("")},base64ToBytes:function(t){t=t.replace(/[^A-Z0-9+\/]/ig,"");for(var c=[],w=0,n=0;w<t.length;n=++w%4)n!=0&&c.push((e.indexOf(t.charAt(w-1))&Math.pow(2,-2*n+8)-1)<<n*2|e.indexOf(t.charAt(w))>>>6-n*2);return c}};G.exports=o})();var Be=G.exports,L={utf8:{stringToBytes:function(e){return L.bin.stringToBytes(unescape(encodeURIComponent(e)))},bytesToString:function(e){return decodeURIComponent(escape(L.bin.bytesToString(e)))}},bin:{stringToBytes:function(e){for(var o=[],t=0;t<e.length;t++)o.push(e.charCodeAt(t)&255);return o},bytesToString:function(e){for(var o=[],t=0;t<e.length;t++)o.push(String.fromCharCode(e[t]));return o.join("")}}},P=L;/*!
 * Determine if an object is a Buffer
 *
 * @author   Feross Aboukhadijeh <https://feross.org>
 * @license  MIT
 */var $e=function(e){return e!=null&&(J(e)||Te(e)||!!e._isBuffer)};function J(e){return!!e.constructor&&typeof e.constructor.isBuffer=="function"&&e.constructor.isBuffer(e)}function Te(e){return typeof e.readFloatLE=="function"&&typeof e.slice=="function"&&J(e.slice(0,0))}(function(){var e=Be,o=P.utf8,t=$e,c=P.bin,w=function(n,b){n.constructor==String?b&&b.encoding==="binary"?n=c.stringToBytes(n):n=o.stringToBytes(n):t(n)?n=Array.prototype.slice.call(n,0):!Array.isArray(n)&&n.constructor!==Uint8Array&&(n=n.toString());for(var s=e.bytesToWords(n),g=n.length*8,i=1732584193,r=-271733879,l=-1732584194,a=271733878,d=0;d<s.length;d++)s[d]=(s[d]<<8|s[d]>>>24)&16711935|(s[d]<<24|s[d]>>>8)&4278255360;s[g>>>5]|=128<<g%32,s[(g+64>>>9<<4)+14]=g;for(var h=w._ff,m=w._gg,p=w._hh,f=w._ii,d=0;d<s.length;d+=16){var Z=i,Q=r,ee=l,te=a;i=h(i,r,l,a,s[d+0],7,-680876936),a=h(a,i,r,l,s[d+1],12,-389564586),l=h(l,a,i,r,s[d+2],17,606105819),r=h(r,l,a,i,s[d+3],22,-1044525330),i=h(i,r,l,a,s[d+4],7,-176418897),a=h(a,i,r,l,s[d+5],12,1200080426),l=h(l,a,i,r,s[d+6],17,-1473231341),r=h(r,l,a,i,s[d+7],22,-45705983),i=h(i,r,l,a,s[d+8],7,1770035416),a=h(a,i,r,l,s[d+9],12,-1958414417),l=h(l,a,i,r,s[d+10],17,-42063),r=h(r,l,a,i,s[d+11],22,-1990404162),i=h(i,r,l,a,s[d+12],7,1804603682),a=h(a,i,r,l,s[d+13],12,-40341101),l=h(l,a,i,r,s[d+14],17,-1502002290),r=h(r,l,a,i,s[d+15],22,1236535329),i=m(i,r,l,a,s[d+1],5,-165796510),a=m(a,i,r,l,s[d+6],9,-1069501632),l=m(l,a,i,r,s[d+11],14,643717713),r=m(r,l,a,i,s[d+0],20,-373897302),i=m(i,r,l,a,s[d+5],5,-701558691),a=m(a,i,r,l,s[d+10],9,38016083),l=m(l,a,i,r,s[d+15],14,-660478335),r=m(r,l,a,i,s[d+4],20,-405537848),i=m(i,r,l,a,s[d+9],5,568446438),a=m(a,i,r,l,s[d+14],9,-1019803690),l=m(l,a,i,r,s[d+3],14,-187363961),r=m(r,l,a,i,s[d+8],20,1163531501),i=m(i,r,l,a,s[d+13],5,-1444681467),a=m(a,i,r,l,s[d+2],9,-51403784),l=m(l,a,i,r,s[d+7],14,1735328473),r=m(r,l,a,i,s[d+12],20,-1926607734),i=p(i,r,l,a,s[d+5],4,-378558),a=p(a,i,r,l,s[d+8],11,-2022574463),l=p(l,a,i,r,s[d+11],16,1839030562),r=p(r,l,a,i,s[d+14],23,-35309556),i=p(i,r,l,a,s[d+1],4,-1530992060),a=p(a,i,r,l,s[d+4],11,1272893353),l=p(l,a,i,r,s[d+7],16,-155497632),r=p(r,l,a,i,s[d+10],23,-1094730640),i=p(i,r,l,a,s[d+13],4,681279174),a=p(a,i,r,l,s[d+0],11,-358537222),l=p(l,a,i,r,s[d+3],16,-722521979),r=p(r,l,a,i,s[d+6],23,76029189),i=p(i,r,l,a,s[d+9],4,-640364487),a=p(a,i,r,l,s[d+12],11,-421815835),l=p(l,a,i,r,s[d+15],16,530742520),r=p(r,l,a,i,s[d+2],23,-995338651),i=f(i,r,l,a,s[d+0],6,-198630844),a=f(a,i,r,l,s[d+7],10,1126891415),l=f(l,a,i,r,s[d+14],15,-1416354905),r=f(r,l,a,i,s[d+5],21,-57434055),i=f(i,r,l,a,s[d+12],6,1700485571),a=f(a,i,r,l,s[d+3],10,-1894986606),l=f(l,a,i,r,s[d+10],15,-1051523),r=f(r,l,a,i,s[d+1],21,-2054922799),i=f(i,r,l,a,s[d+8],6,1873313359),a=f(a,i,r,l,s[d+15],10,-30611744),l=f(l,a,i,r,s[d+6],15,-1560198380),r=f(r,l,a,i,s[d+13],21,1309151649),i=f(i,r,l,a,s[d+4],6,-145523070),a=f(a,i,r,l,s[d+11],10,-1120210379),l=f(l,a,i,r,s[d+2],15,718787259),r=f(r,l,a,i,s[d+9],21,-343485551),i=i+Z>>>0,r=r+Q>>>0,l=l+ee>>>0,a=a+te>>>0}return e.endian([i,r,l,a])};w._ff=function(n,b,s,g,i,r,l){var a=n+(b&s|~b&g)+(i>>>0)+l;return(a<<r|a>>>32-r)+b},w._gg=function(n,b,s,g,i,r,l){var a=n+(b&g|s&~g)+(i>>>0)+l;return(a<<r|a>>>32-r)+b},w._hh=function(n,b,s,g,i,r,l){var a=n+(b^s^g)+(i>>>0)+l;return(a<<r|a>>>32-r)+b},w._ii=function(n,b,s,g,i,r,l){var a=n+(s^(b|~g))+(i>>>0)+l;return(a<<r|a>>>32-r)+b},w._blocksize=16,w._digestsize=16,Y.exports=function(n,b){if(n==null)throw new Error("Illegal argument "+n);var s=e.wordsToBytes(w(n,b));return b&&b.asBytes?s:b&&b.asString?c.bytesToString(s):e.bytesToHex(s)}})();var _e=Y.exports;const Me=ue(_e),j=["avatar_url","email","name"],Fe=[...j,"identifier_hash"],k=()=>{const e="cw_user_",{websiteToken:o}=window.$chatwoot;return`${e}${o}`},Ae=({identifier:e="",user:o})=>`${Fe.reduce((c,w)=>`${c}${w}${o[w]||""}`,"")}identifier${e}`,Le=(...e)=>Me(Ae(...e)),ke=e=>j.reduce((o,t)=>o||!!e[t],!1),U=(e,o,{expires:t=365,baseDomain:c=void 0}={})=>{const w={expires:t,sameSite:"Lax",domain:c};typeof o=="object"&&(o=JSON.stringify(o)),y.set(e,o,w)},z=["click","touchstart","keypress","keydown"],De=()=>{let e;try{e=new(window.AudioContext||window.webkitAudioContext)}catch{}return e},Ue=async(e="",o)=>{const t=De(),c=w=>{window.playAudioAlert=()=>{if(t){const n=t.createBufferSource();n.buffer=w,n.connect(t.destination),n.loop=!1,n.start()}}};if(t){const{type:w="dashboard",alertTone:n="ding"}=o||{},b=`${e}/audio/${w}/${n}.mp3`,s=new Request(b);fetch(s).then(g=>g.arrayBuffer()).then(g=>(t.decodeAudioData(g).then(c),new Promise(i=>i()))).catch(()=>{})}},V=(e,o="")=>U("cw_conversation",e,{baseDomain:o}),Oe=e=>{const o=ae(new Date,1);U("cw_snooze_campaigns_till",Number(o),{expires:o,baseDomain:e})},B=e=>{if(e==="")return"";try{const o=new URL(e);if(!["https","http"].includes(o.protocol))throw new Error("Invalid Protocol")}catch(o){console.error("Invalid URL",o)}return"about:blank"},u={getUrl({baseUrl:e,websiteToken:o}){return e=B(e),`${e}/widget?website_token=${o}`},createFrame:({baseUrl:e,websiteToken:o})=>{if(e=B(e),u.getAppFrame())return;ge();const t=document.createElement("iframe"),c=y.get("cw_conversation");let w=u.getUrl({baseUrl:e,websiteToken:o});c&&(w=`${w}&cw_conversation=${c}`),t.src=w,t.allow="camera;microphone;fullscreen;display-capture;picture-in-picture;clipboard-write;",t.id="chatwoot_live_chat_widget",t.style.visibility="hidden";let n=`woot-widget-holder woot--hide woot-elements--${window.$chatwoot.position}`;window.$chatwoot.hideMessageBubble&&(n+=" woot-widget--without-bubble"),I(window.$chatwoot.widgetStyle)&&(n+=" woot-widget-holder--flat"),C(v,n),v.id="cw-widget-holder",v.dataset.turboPermanent=!0,v.appendChild(t),X.appendChild(v),u.initPostMessageCommunication(),u.initWindowSizeListener(),u.preventDefaultScroll()},getAppFrame:()=>document.getElementById("chatwoot_live_chat_widget"),getBubbleHolder:()=>document.getElementsByClassName("woot--bubble-holder"),sendMessage:(e,o)=>{u.getAppFrame().contentWindow.postMessage(`chatwoot-widget:${JSON.stringify({event:e,...o})}`,"*")},initPostMessageCommunication:()=>{window.onmessage=e=>{if(typeof e.data!="string"||e.data.indexOf("chatwoot-widget:")!==0||e.origin!==window.location.origin)return;const o=JSON.parse(e.data.replace("chatwoot-widget:",""));typeof u.events[o.event]=="function"&&u.events[o.event](o)}},initWindowSizeListener:()=>{window.addEventListener("resize",()=>u.toggleCloseButton())},preventDefaultScroll:()=>{v.addEventListener("wheel",e=>{const o=e.deltaY,t=v.scrollHeight,c=v.offsetHeight,w=v.scrollTop;(w===0&&o<0||c+w===t&&o>0)&&e.preventDefault()})},setFrameHeightToFitContent:(e,o)=>{const t=u.getAppFrame(),c=o?`${e}px`:"100%";t&&t.setAttribute("style",`height: ${c} !important`)},setupAudioListeners:()=>{let{baseUrl:e=""}=window.$chatwoot;e=B(e),Ue(e,{type:"widget",alertTone:"ding"}).then(()=>z.forEach(o=>{document.removeEventListener(o,u.setupAudioListeners,!1)}))},events:{loaded:e=>{V(e.config.authToken,window.$chatwoot.baseDomain),window.$chatwoot.hasLoaded=!0;const o=y.get("cw_snooze_campaigns_till");u.sendMessage("config-set",{locale:window.$chatwoot.locale,position:window.$chatwoot.position,hideMessageBubble:window.$chatwoot.hideMessageBubble,showPopoutButton:window.$chatwoot.showPopoutButton,widgetStyle:window.$chatwoot.widgetStyle,darkMode:window.$chatwoot.darkMode,showUnreadMessagesDialog:window.$chatwoot.showUnreadMessagesDialog,campaignsSnoozedTill:o,welcomeTitle:window.$chatwoot.welcomeTitle,welcomeDescription:window.$chatwoot.welcomeDescription,availableMessage:window.$chatwoot.availableMessage,unavailableMessage:window.$chatwoot.unavailableMessage,enableFileUpload:window.$chatwoot.enableFileUpload,enableEmojiPicker:window.$chatwoot.enableEmojiPicker,enableEndConversation:window.$chatwoot.enableEndConversation}),u.onLoad({widgetColor:e.config.channelConfig.widgetColor}),u.toggleCloseButton(),window.$chatwoot.user&&u.sendMessage("set-user",window.$chatwoot.user),window.playAudioAlert=()=>{},z.forEach(t=>{document.addEventListener(t,u.setupAudioListeners,!1)}),window.$chatwoot.resetTriggered||E({eventName:de})},error:({errorType:e,data:o})=>{E({eventName:le,data:o}),e===re&&y.remove(k())},onEvent({eventIdentifier:e,data:o}){E({eventName:e,data:o})},setBubbleLabel(e){ve(window.$chatwoot.launcherTitle||e.label)},setAuthCookie({data:{widgetAuthToken:e}}){V(e,window.$chatwoot.baseDomain)},setCampaignReadOn(){Oe(window.$chatwoot.baseDomain)},postback(e){E({eventName:se,data:e})},toggleBubble:e=>{let o={};e==="open"?o.toggleValue=!0:e==="close"&&(o.toggleValue=!1),S(o)},popoutChatWindow:({baseUrl:e,websiteToken:o,locale:t})=>{e=B(e);const c=y.get("cw_conversation");window.$chatwoot.toggle("close"),ie(e,o,t,c)},closeWindow:()=>{S({toggleValue:!1}),W()},onBubbleToggle:e=>{u.sendMessage("toggle-open",{isOpen:e}),e&&u.pushEvent("webwidget.triggered")},onLocationChange:({referrerURL:e,referrerHost:o})=>{u.sendMessage("change-url",{referrerURL:e,referrerHost:o})},updateIframeHeight:e=>{const{extraHeight:o=0,isFixedHeight:t}=e;u.setFrameHeightToFitContent(o,t)},setUnreadMode:()=>{Se(),S({toggleValue:!0})},resetUnreadMode:()=>W(),handleNotificationDot:e=>{if(window.$chatwoot.hideMessageBubble)return;const o=document.querySelector(".woot-widget-bubble");e.unreadMessageCount>0&&!o.classList.contains("unread-notification")?C(o,"unread-notification"):e.unreadMessageCount===0&&T(o,"unread-notification")},closeChat:()=>{S({toggleValue:!1})},playAudio:()=>{window.playAudioAlert()}},pushEvent:e=>{u.sendMessage("push-event",{eventName:e})},onLoad:({widgetColor:e})=>{const o=u.getAppFrame();if(o.style.visibility="",o.setAttribute("id","chatwoot_live_chat_widget"),u.getBubbleHolder().length)return;ye(window.$chatwoot.hideMessageBubble),he();let t="woot-widget-bubble",c=`woot-elements--${window.$chatwoot.position} woot-widget-bubble woot--close woot--hide`;I(window.$chatwoot.widgetStyle)&&(t+=" woot-widget-bubble--flat",c+=" woot-widget-bubble--flat"),ce(e)&&(t+=" woot-widget-bubble-color--lighter",c+=" woot-widget-bubble-color--lighter");const w=xe({className:t,path:fe,target:D});C($,c),w.style.background=e,$.style.background=e,x.appendChild(w),x.appendChild($),Ee()},toggleCloseButton:()=>{let e=!1;window.matchMedia("(max-width: 668px)").matches&&(e=!0),u.sendMessage("toggle-close-button",{isMobile:e})}},Ne=({baseUrl:e,websiteToken:o})=>{if(window.$chatwoot)return;document.addEventListener("turbo:before-render",n=>{n.detail.renderMethod!=="morph"&&M(n.detail.newBody)}),window.Turbolinks&&document.addEventListener("turbolinks:before-render",n=>{M(n.data.newBody)}),document.addEventListener("astro:before-swap",n=>M(n.newDocument.body));const t=window.chatwootSettings||{};let c=t.locale,w=t.baseDomain;t.useBrowserLanguage&&(c=window.navigator.language.replace("-","_")),window.$chatwoot={baseUrl:e,baseDomain:w,hasLoaded:!1,hideMessageBubble:t.hideMessageBubble||!1,isOpen:!1,position:t.position==="left"?"left":"right",websiteToken:o,locale:c,useBrowserLanguage:t.useBrowserLanguage||!1,type:q(t.type),launcherTitle:t.launcherTitle||"",showPopoutButton:t.showPopoutButton||!1,showUnreadMessagesDialog:t.showUnreadMessagesDialog??!0,widgetStyle:me(t.widgetStyle)||"standard",resetTriggered:!1,darkMode:R(t.darkMode),welcomeTitle:t.welcomeTitle||"",welcomeDescription:t.welcomeDescription||"",availableMessage:t.availableMessage||"",unavailableMessage:t.unavailableMessage||"",enableFileUpload:t.enableFileUpload??!0,enableEmojiPicker:t.enableEmojiPicker??!0,enableEndConversation:t.enableEndConversation??!0,toggle(n){u.events.toggleBubble(n)},toggleBubbleVisibility(n){let b=document.querySelector(".woot--bubble-holder"),s=document.querySelector(".woot-widget-holder");n==="hide"?(C(s,"woot-widget--without-bubble"),C(b,"woot-hidden"),window.$chatwoot.hideMessageBubble=!0):n==="show"&&(T(b,"woot-hidden"),T(s,"woot-widget--without-bubble"),window.$chatwoot.hideMessageBubble=!1),u.sendMessage(we,{hideMessageBubble:window.$chatwoot.hideMessageBubble})},popoutChatWindow(){u.events.popoutChatWindow({baseUrl:window.$chatwoot.baseUrl,websiteToken:window.$chatwoot.websiteToken,locale:c})},setUser(n,b){if(typeof n!="string"&&typeof n!="number")throw new Error("Identifier should be a string or a number");if(!ke(b))throw new Error("User object should have one of the keys [avatar_url, email, name]");const s=k(),g=y.get(s),i=Le({identifier:n,user:b});i!==g&&(window.$chatwoot.identifier=n,window.$chatwoot.user=b,u.sendMessage("set-user",{identifier:n,user:b}),U(s,i,{baseDomain:w}))},setCustomAttributes(n={}){if(!n||!Object.keys(n).length)throw new Error("Custom attributes should have atleast one key");u.sendMessage("set-custom-attributes",{customAttributes:n})},deleteCustomAttribute(n=""){if(n)u.sendMessage("delete-custom-attribute",{customAttribute:n});else throw new Error("Custom attribute is required")},setConversationCustomAttributes(n={}){if(!n||!Object.keys(n).length)throw new Error("Custom attributes should have atleast one key");u.sendMessage("set-conversation-custom-attributes",{customAttributes:n})},deleteConversationCustomAttribute(n=""){if(n)u.sendMessage("delete-conversation-custom-attribute",{customAttribute:n});else throw new Error("Custom attribute is required")},setLabel(n=""){u.sendMessage("set-label",{label:n})},removeLabel(n=""){u.sendMessage("remove-label",{label:n})},setLocale(n="en"){u.sendMessage("set-locale",{locale:n})},setColorScheme(n="light"){u.sendMessage("set-color-scheme",{darkMode:R(n)})},reset(){window.$chatwoot.isOpen&&u.events.toggleBubble(),y.remove("cw_conversation"),y.remove(k());const n=u.getAppFrame();n.src=u.getUrl({baseUrl:window.$chatwoot.baseUrl,websiteToken:window.$chatwoot.websiteToken}),window.$chatwoot.resetTriggered=!0}},u.createFrame({baseUrl:e,websiteToken:o})};window.chatwootSDK={run:Ne};
//# sourceMappingURL=sdk-DVNLWm3B.js.map
