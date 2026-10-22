// The lightbox (web/partials/lightbox.html): links marked data-lightbox open
// their large picture in it. The pictures of one group (the nearest
// [data-lightbox-group], else the page) can be paged through with the
// buttons, the arrow keys or a swipe, in their order on screen. The caption
// is the link's data-caption, else the alt text of its picture; the title is
// the group's data-lightbox-title. A click on the picture zooms to its full
// size and back; a click beside it, the close button or Escape closes.
// Taken over from the blog, where it began.
(() => {
  const dialog = document.querySelector(".hz-lightbox");
  if (!dialog || typeof dialog.showModal !== "function") return;
  const photo = dialog.querySelector("img");
  const prev = dialog.querySelector(".hz-lightbox-prev");
  const next = dialog.querySelector(".hz-lightbox-next");
  const count = dialog.querySelector(".hz-lightbox-count");
  const caption = dialog.querySelector(".hz-lightbox-caption");
  const title = dialog.querySelector(".hz-lightbox-title");
  const exifButton = dialog.querySelector(".hz-lightbox-exif-toggle");
  const exifPanel = dialog.querySelector(".hz-lightbox-exif");
  const exifList = exifPanel.querySelector("dl");
  const stage = dialog.querySelector(".hz-lightbox-stage");

  // The shooting data panel stays open while paging, and across visits.
  let exifOpen = false;
  try {
    exifOpen = localStorage.getItem("hz-lightbox-exif") === "1";
  } catch (e) {}
  const setExifOpen = (open) => {
    exifOpen = open;
    try {
      localStorage.setItem("hz-lightbox-exif", open ? "1" : "0");
    } catch (e) {}
    showExif();
  };

  // Rows come from the link, as JSON [{label, value}] in data-exif (the blog
  // writes them from the photo's EXIF). Pictures without any have no button
  // and no panel.
  let exifRows = [];
  const showExif = () => {
    const has = exifRows.length > 0;
    exifButton.style.visibility = has ? "visible" : "hidden";
    exifButton.setAttribute("aria-pressed", String(has && exifOpen));
    exifPanel.hidden = !(has && exifOpen);
    exifList.replaceChildren(
      ...exifRows.flatMap(({ label, value }) => {
        const dt = document.createElement("dt");
        const dd = document.createElement("dd");
        dt.textContent = label;
        dd.textContent = value;
        return [dt, dd];
      })
    );
  };

  let group = [];
  let index = 0;

  // Zoom: one click on the photo shows it at its full size, in a stage that
  // scrolls and can be dragged; the next click goes back. Photos that are not
  // larger than the view cannot be zoomed.
  let zoomed = false;
  const updateZoomable = () => {
    if (zoomed) return;
    dialog.classList.toggle("zoomable", photo.naturalWidth > photo.clientWidth + 2);
  };
  const zoomOut = () => {
    zoomed = false;
    dialog.classList.remove("zoomed");
    photo.style.removeProperty("width");
    updateZoomable();
  };
  const zoomIn = (event) => {
    if (!dialog.classList.contains("zoomable")) return;
    // The spot that was clicked ends up in the middle of the window.
    const box = photo.getBoundingClientRect();
    const fx = (event.clientX - box.left) / box.width;
    const fy = (event.clientY - box.top) / box.height;
    zoomed = true;
    dialog.classList.add("zoomed");
    photo.style.width = `${photo.naturalWidth}px`;
    const bar = parseFloat(getComputedStyle(stage).paddingTop) || 0;
    stage.scrollLeft = fx * photo.offsetWidth - stage.clientWidth / 2;
    stage.scrollTop = fy * photo.offsetHeight + bar - stage.clientHeight / 2;
  };
  photo.addEventListener("load", updateZoomable);
  window.addEventListener("resize", updateZoomable);

  const show = (i) => {
    zoomOut();
    index = (i + group.length) % group.length;
    const link = group[index];
    photo.src = link.href;
    photo.alt = link.querySelector("img")?.alt ?? "";
    caption.textContent = link.dataset.caption ?? photo.alt;
    try {
      exifRows = JSON.parse(link.dataset.exif ?? "[]");
    } catch (e) {
      exifRows = [];
    }
    showExif();
    count.textContent = `${index + 1} / ${group.length}`;
    // Load the neighbours ahead, so paging does not wait for the photo.
    [index - 1, index + 1].forEach((n) => {
      new Image().src = group[(n + group.length) % group.length].href;
    });
  };

  document.addEventListener("click", (event) => {
    const link = event.target.closest("a[data-lightbox]");
    // Leave modified clicks alone, so "open in new tab" keeps working.
    if (!link || event.metaKey || event.ctrlKey || event.shiftKey) return;
    const container = link.closest("[data-lightbox-group]") ?? document;
    group = Array.from(container.querySelectorAll("a[data-lightbox]"));
    title.textContent = container.dataset?.lightboxTitle ?? "";
    event.preventDefault();
    // A selection from before would show through the backdrop.
    window.getSelection()?.removeAllRanges();
    const single = group.length < 2;
    prev.hidden = next.hidden = count.hidden = single;
    show(group.indexOf(link));
    dialog.showModal();
  });

  // A second click in quick succession selects a word in most browsers, even
  // where user-select is off in some of them; the default of a double or
  // triple click in the open view is not wanted.
  dialog.addEventListener("mousedown", (event) => {
    if (event.detail > 1) event.preventDefault();
  });

  // A mouse drag in the zoomed view moves the photo; touch scrolls the stage
  // by itself. The pointer is only captured once the mouse really moves, so a
  // plain click still reaches the photo.
  let drag = null;
  let dragged = false;
  stage.addEventListener("pointerdown", (event) => {
    dragged = false;
    if (!zoomed || event.pointerType !== "mouse" || event.button !== 0) return;
    drag = { x: event.clientX, y: event.clientY, left: stage.scrollLeft, top: stage.scrollTop };
  });
  stage.addEventListener("pointermove", (event) => {
    if (!drag) return;
    const dx = event.clientX - drag.x;
    const dy = event.clientY - drag.y;
    if (!dragged && Math.abs(dx) + Math.abs(dy) > 5) {
      dragged = true;
      stage.setPointerCapture(event.pointerId);
    }
    if (dragged) {
      stage.scrollLeft = drag.left - dx;
      stage.scrollTop = drag.top - dy;
    }
  });
  const endDrag = () => {
    drag = null;
  };
  stage.addEventListener("pointerup", endDrag);
  stage.addEventListener("pointercancel", endDrag);

  // A click on the photo zooms in and out; a click on the empty space around
  // it closes the view, and so does the close button. The text in the bars and
  // the paging buttons do not.
  dialog.addEventListener("click", (event) => {
    // The end of a drag is not a click.
    if (dragged) {
      dragged = false;
      return;
    }
    if (event.target === photo) {
      if (zoomed) zoomOut();
      else zoomIn(event);
      return;
    }
    if (event.target.closest(".hz-lightbox-bar > *, .hz-lightbox-exif") && !event.target.closest(".hz-lightbox-close")) return;
    dialog.close();
  });
  exifButton.addEventListener("click", (event) => {
    event.stopPropagation();
    setExifOpen(!exifOpen);
  });
  [prev, next].forEach((button) =>
    button.addEventListener("click", (event) => {
      event.stopPropagation();
      show(index + (button === next ? 1 : -1));
    })
  );

  // Modal dialogs close on Escape natively, but browsers may skip that when
  // the dialog was not opened by a direct user gesture. Closing an already
  // closed dialog is a no-op, so handling it here as well is safe.
  document.addEventListener("keydown", (event) => {
    if (!dialog.open) return;
    if (event.key === "Escape") dialog.close();
    else if (group.length > 1 && event.key === "ArrowRight") show(index + 1);
    else if (group.length > 1 && event.key === "ArrowLeft") show(index - 1);
  });

  // A horizontal swipe pages through, a mostly vertical one is left alone.
  let startX = 0;
  let startY = 0;
  dialog.addEventListener("touchstart", (event) => {
    startX = event.changedTouches[0].clientX;
    startY = event.changedTouches[0].clientY;
  }, { passive: true });
  dialog.addEventListener("touchend", (event) => {
    if (group.length < 2 || zoomed) return;
    const dx = event.changedTouches[0].clientX - startX;
    const dy = event.changedTouches[0].clientY - startY;
    if (Math.abs(dx) > 50 && Math.abs(dx) > 2 * Math.abs(dy)) {
      show(index + (dx < 0 ? 1 : -1));
    }
  }, { passive: true });

  // The close event arrives a moment after closing; a view opened again in
  // between must keep its photo.
  dialog.addEventListener("close", () => {
    if (dialog.open) return;
    zoomOut();
    photo.removeAttribute("src");
    caption.textContent = "";
    title.textContent = "";
    exifRows = [];
  });
})();
