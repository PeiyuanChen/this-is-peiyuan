document.addEventListener("DOMContentLoaded", function () {
  var galleryEl = document.getElementById("album-gallery");
  if (!galleryEl || typeof PhotoSwipeLightbox === "undefined" || typeof PhotoSwipe === "undefined") return;

  var lightbox = new PhotoSwipeLightbox({
    gallery: galleryEl,
    children: "a.gallery-slide",
    pswpModule: PhotoSwipe,
    bgOpacity: 0.96,
    showHideAnimationType: "fade"
  });

  lightbox.on("uiRegister", function () {
    lightbox.pswp.ui.registerElement({
      name: "exif-text",
      order: 8,
      isButton: false,
      appendTo: "root",
      className: "pswp-exif",
      html: "",
      onInit: function (el, pswp) {
        var slides = galleryEl.querySelectorAll("a.gallery-slide");
        lightbox.pswp.on("change", function () {
          var d = slides[pswp.currSlide.index].dataset;
          var parts = [];
          if (d.fNumber) parts.push("f/" + d.fNumber);
          if (d.exposure) parts.push(d.exposure);
          if (d.iso) parts.push("ISO " + d.iso);
          el.textContent = parts.join("  ");
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
        var slides = galleryEl.querySelectorAll("a.gallery-slide");
        lightbox.pswp.on("change", function () {
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
