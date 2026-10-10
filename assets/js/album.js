document.addEventListener("DOMContentLoaded", function () {
  var galleryEl = document.getElementById("album-gallery");
  if (!galleryEl || typeof PhotoSwipeLightbox === "undefined" || typeof PhotoSwipe === "undefined") return;

  var slides = galleryEl.querySelectorAll("a.gallery-slide");

  var lightbox = new PhotoSwipeLightbox({
    gallery: galleryEl,
    children: "a.gallery-slide",
    pswpModule: PhotoSwipe,
    bgOpacity: 1,
    showHideAnimationType: "fade",
    // 四周白色画框，照片如装裱；底部边框容纳 EXIF 与 caption
    paddingFn: function (viewportSize) {
      return viewportSize.x < 700
        ? { top: 16, bottom: 112, left: 12, right: 12 }
        : { top: 64, bottom: 140, left: 72, right: 72 };
    }
  });

  // Minimal Mistakes 会给指向 jpg 的链接自动绑 Magnific Popup，
  // 捕获阶段拦截点击，避免两个灯箱同时打开（Close 要点两次的根因）
  galleryEl.addEventListener("click", function (e) {
    if (e.button !== 0 || e.ctrlKey || e.metaKey || e.shiftKey || e.altKey) return;
    var slideEl = e.target.closest("a.gallery-slide");
    if (!slideEl || !galleryEl.contains(slideEl)) return;
    e.preventDefault();
    e.stopPropagation();
    lightbox.loadAndOpen(Array.prototype.indexOf.call(slides, slideEl));
  }, true);

  lightbox.on("uiRegister", function () {
    lightbox.pswp.ui.registerElement({
      name: "exif-text",
      order: 8,
      isButton: false,
      appendTo: "root",
      className: "pswp-exif",
      html: "",
      onInit: function (el, pswp) {
        pswp.on("change", update);
        pswp.on("resize", update);
        pswp.on("imageLoadComplete", update);

        function update() {
          if (!pswp.currSlide) return;
          var d = slides[pswp.currSlide.index].dataset;
          var parts = [];
          if (d.lens) parts.push(d.lens);
          if (d.fNumber) parts.push("f/" + d.fNumber);
          if (d.exposure) parts.push(d.exposure);
          if (d.iso) parts.push("ISO " + d.iso);
          el.textContent = parts.join("  ·  ");
          el.style.display = parts.length ? "block" : "none";
          alignToPhoto();
          setTimeout(alignToPhoto, 450); // 切换动画结束后图片位置才稳定
        }

        // 对齐照片实际左边缘并保持一行间距（照片比例不同，位置也不同）
        function alignToPhoto() {
          requestAnimationFrame(function () {
            var holder = pswp.currSlide && pswp.currSlide.holderElement;
            var img = holder && holder.querySelector(".pswp__img");
            if (img && img.complete) {
              var r = img.getBoundingClientRect();
              var gap = window.innerWidth < 700 ? 16 : 21;
              el.style.left = Math.round(r.left) + "px";
              el.style.top = Math.round(r.bottom + gap) + "px";
              el.style.bottom = "auto";
            }
          });
        }
      }
    });

    lightbox.pswp.ui.registerElement({
      name: "caption-text",
      order: 9,
      isButton: false,
      appendTo: "root",
      className: "pswp-caption",
      html: "",
      onInit: function (el, pswp) {
        pswp.on("change", function () {
          var caption = slides[pswp.currSlide.index].dataset.caption;
          el.textContent = caption || "";
          el.style.display = caption ? "block" : "none";
        });
      }
    });

  });

  function openFromHash() {
    var match = window.location.hash.match(/photo=(\d+)/);
    if (!match) return;
    if (lightbox.pswp) return;
    lightbox.loadAndOpen(parseInt(match[1], 10));
  }

  lightbox.on("close", function () {
    history.replaceState(null, "", window.location.pathname);
  });

  lightbox.init();
  openFromHash();
  window.addEventListener("hashchange", openFromHash);
});
