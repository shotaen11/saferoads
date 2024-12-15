// Import and register all your controllers from the importmap via controllers/**/*_controller
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Stimulusアプリケーションを開始
const application = Application.start()

// Controllersを読み込み
eagerLoadControllersFrom("controllers", application)
