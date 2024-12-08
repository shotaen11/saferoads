// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// application.js
import "jquery"  // importmapからjQueryを読み込み
import "bootstrap"
import "@hotwired/turbo-rails"
import "controllers"

// ハンバーガーメニューをクリックしたときにナビゲーションを表示/非表示にする
document.addEventListener("DOMContentLoaded", function() {
    const hamburgerMenu = document.getElementById("js-hamburger-menu");
    const navigation = document.querySelector(".navigation");
  
    hamburgerMenu.addEventListener("click", function() {
      // メニューが開いている場合は閉じ、閉じている場合は開く
      navigation.classList.toggle("open");
    });
  });
  
