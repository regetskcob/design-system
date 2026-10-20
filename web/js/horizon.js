/* Horizont: the horizon line (partials/nav/horizon.html).
 *
 * Places every chapter mark at the position of its chapter on the page,
 * lets the page's mark walk along the line as you read, keeps the title of
 * the current chapter whole below its mark, opens the Flurkarte as a
 * dialog, and on touch lets the thumb swipe along the line to jump. No
 * dependencies; without it the page keeps anchor links and a link to the
 * map page. With reduced motion the mark stands still at the start and
 * only the line fills.
 */
(function () {
  "use strict";
  var nav = document.querySelector("[data-hz-horizon]");
  if (!nav) return;

  var reduce = matchMedia("(prefers-reduced-motion: reduce)");
  var touch = matchMedia("(hover: none) and (pointer: coarse)");
  var walker = nav.querySelector(".hz-walker");
  var done = nav.querySelector(".hz-horizon-done");
  var list = nav.querySelector(".hz-ticks");
  var dialog = document.querySelector("[data-hz-karte]");
  var ticks = list ? [].slice.call(list.querySelectorAll(".hz-tick")) : [];
  // A mark whose chapter is not on this page (a year on another page of a
  // list) leaves the line.
  var marks = ticks.map(function (a) {
    var id = decodeURIComponent(a.hash.slice(1));
    return { a: a, label: a.querySelector("span"), target: document.getElementById(id), x: 0 };
  }).filter(function (m) {
    if (!m.target) m.a.parentNode.hidden = true;
    return m.target;
  });
  var current = -1;
  var frame = 0;

  nav.classList.add("is-live");

  function offsetTop(el) {
    return el.getBoundingClientRect().top + window.scrollY;
  }

  function range() {
    return Math.max(1, document.documentElement.scrollHeight - window.innerHeight);
  }

  // Each mark sits where its chapter begins, as a share of the scroll range;
  // a title may use the room up to the next mark.
  function layout() {
    var max = range();
    var width = list ? list.getBoundingClientRect().width : 0;
    var head = touch.matches ? 0 : nav.offsetHeight;
    marks.forEach(function (m) {
      m.x = Math.min(1, Math.max(0, (offsetTop(m.target) - head - 8) / max));
    });
    marks.forEach(function (m, i) {
      var next = i + 1 < marks.length ? marks[i + 1].x : 1;
      var prev = i > 0 ? marks[i - 1].x : 0;
      var li = m.a.parentNode;
      // Near the end a title hangs to the left of its mark; it shares the gap
      // to the mark before with that mark's title.
      var end = m.x > 0.82;
      var nextEnd = i + 1 < marks.length && marks[i + 1].x > 0.82;
      var gap = end ? (m.x - prev) / 2 : (nextEnd ? (next - m.x) / 2 : next - m.x);
      m.room = Math.max(14, gap * width - 12);
      li.style.left = (m.x * 100) + "%";
      li.style.setProperty("--room", m.room + "px");
      m.a.classList.toggle("is-end", end);
    });
    current = -2;
    update();
  }

  function update() {
    frame = 0;
    var p = Math.min(1, Math.max(0, window.scrollY / range()));
    var width = nav.querySelector(".hz-horizon-line").getBoundingClientRect().width;
    done.style.width = (p * width) + "px";
    walker.style.setProperty("--walk", (reduce.matches ? 0 : p * width) + "px");

    var head = touch.matches ? window.innerHeight * 0.4 : nav.offsetHeight + 80;
    var at = -1;
    marks.forEach(function (m, i) {
      if (m.target.getBoundingClientRect().top < head) at = i;
    });
    if (at === current) return;
    current = at;
    marks.forEach(function (m, i) {
      var on = i === at;
      m.a.classList.toggle("is-current", on);
      if (on) m.a.setAttribute("aria-current", "location");
      else m.a.removeAttribute("aria-current");
      // A title where it has room; where chapters lie close, only its number.
      // Too close for even the number: the mark stays, its words are in the title.
      m.label.textContent = on || (!touch.matches && m.room >= 72) ? m.a.dataset.full : (m.room >= 22 ? m.a.dataset.short : "");
    });
  }

  function schedule() {
    if (!frame) frame = requestAnimationFrame(update);
  }

  // The map as a dialog: focus moves in, Escape and the backdrop close it.
  if (dialog && typeof dialog.showModal === "function") {
    walker.addEventListener("click", function (e) {
      e.preventDefault();
      dialog.showModal();
      var here = dialog.querySelector("[aria-current]");
      if (here) here.focus({ preventScroll: true });
    });
    dialog.addEventListener("click", function (e) {
      if (e.target === dialog) dialog.close();
    });
  }

  // On touch: swipe along the line, the nearest chapter shows above the
  // thumb and the page follows; letting go stays there.
  var bubble = null;
  var swiping = false;
  function nearest(clientX) {
    var box = list.getBoundingClientRect();
    var r = (clientX - box.left) / box.width;
    var best = 0;
    var gap = 2;
    marks.forEach(function (m, i) {
      var d = Math.abs(m.x - r);
      if (d < gap) { gap = d; best = i; }
    });
    return best;
  }
  function swipeTo(clientX) {
    var i = nearest(clientX);
    var m = marks[i];
    bubble.textContent = m.a.title || m.a.dataset.full;
    window.scrollTo(0, offsetTop(m.target) - 16);
  }
  if (list && marks.length) {
    nav.addEventListener("pointerdown", function (e) {
      if (!touch.matches || e.pointerType === "mouse" || e.target.closest(".hz-walker, .hz-horizon-lang")) return;
      swiping = true;
      nav.setPointerCapture(e.pointerId);
      if (!bubble) {
        bubble = document.createElement("div");
        bubble.className = "hz-horizon-bubble";
        bubble.setAttribute("aria-hidden", "true");
        nav.appendChild(bubble);
      }
      bubble.hidden = false;
      swipeTo(e.clientX);
      e.preventDefault();
    });
    nav.addEventListener("pointermove", function (e) { if (swiping) swipeTo(e.clientX); });
    var stop = function () { swiping = false; if (bubble) bubble.hidden = true; };
    nav.addEventListener("pointerup", stop);
    nav.addEventListener("pointercancel", stop);
  }

  window.addEventListener("scroll", schedule, { passive: true });
  window.addEventListener("resize", layout);
  touch.addEventListener("change", layout);
  reduce.addEventListener("change", update);
  // Images and fonts move the chapters after load.
  if ("ResizeObserver" in window) new ResizeObserver(layout).observe(document.body);
  else window.addEventListener("load", layout);
  layout();
})();
