// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// application.js
import "jquery"  // importmapからjQueryを読み込み
import "bootstrap"
import "@hotwired/turbo-rails"
import "controllers"

// ハンバーガーメニューをクリックしたときにナビゲーションを表示/非表示にする
// ハンバーガーメニューの初期化スクリプト
document.addEventListener("turbo:load", function () {
        const hamburger = document.getElementById("js-hamburger-menu");
        const navigation = document.querySelector(".navigation");
      
        hamburger.addEventListener("click", function () {
          const isOpen = navigation.classList.toggle("open");
          document.body.classList.toggle("menu-open", isOpen);
        });
      });
