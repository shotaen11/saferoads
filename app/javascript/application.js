// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// application.js
import "jquery"  // importmapからjQueryを読み込み
import "bootstrap"
import "@hotwired/turbo-rails"
import "controllers"
import { Turbo } from "@hotwired/turbo-rails";
import Rails from "@rails/ujs";  // Rails-ujsをインポート
Rails.start();  // 初期化


// ハンバーガーメニューをクリックしたときにナビゲーションを表示/非表示にする
// ハンバーガーメニューの初期化スクリプト
document.addEventListener("turbo:load", function () {
    const hamburgerMenu = document.getElementById("js-hamburger-menu");
    const navigation = document.querySelector(".navigation");
  
    hamburgerMenu.addEventListener("click", () => {
      // ハンバーガーメニューの状態を切り替える
      hamburgerMenu.classList.toggle("hamburger-menu--open");
      // ナビゲーションメニューの表示/非表示を切り替える
      navigation.classList.toggle("open");
  
      // ボディのスクロールを制御（モバイル向け）
      document.body.classList.toggle("menu-open");
        });
      });


      import "./follow";  // follow.jsをインポート