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
    // 留白：横图在下方留两行信息区，竖图在右侧留信息栏
    paddingFn: function (viewportSize, itemData) {
      var narrow = viewportSize.x < 700;
      var side = narrow ? 16 : 40;
      var top = narrow ? 24 : 40;
      var portrait = !narrow && itemData.height > itemData.width;
      return portrait
        ? { top: top, bottom: top, left: side, right: 380 }
        : { top: top, bottom: narrow ? 104 : 118, left: side, right: side };
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
        pswp.on("change", function () {
          var d = slides[pswp.currSlide.index].dataset;
          var parts = [];
          if (d.lens) parts.push(d.lens);
          if (d.fNumber) parts.push("f/" + d.fNumber);
          if (d.exposure) parts.push(d.exposure);
          if (d.iso) parts.push("ISO " + d.iso);
          el.textContent = parts.join("  ·  ");
          el.style.display = parts.length ? "block" : "none";
        });
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

    pswpOrientation(lightbox.pswp);
  });

  function pswpOrientation(pswp) {
    pswp.on("change", function () {
      var d = slides[pswp.currSlide.index].dataset;
      var portrait = window.innerWidth >= 700 && Number(d.pswpHeight) > Number(d.pswpWidth);
      pswp.element.classList.toggle("pswp-portrait", portrait);
    });
  }

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
