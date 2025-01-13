const { environment } = require('@rails/webpacker')

environment.config.merge({
    entry: {
      application: './app/javascript/application.js'  // エントリーポイントのファイルを指定
    }
  })

module.exports = environment