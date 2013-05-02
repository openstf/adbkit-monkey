module.exports = (grunt) ->

  grunt.initConfig
    pkg: require './package'
    coffee:
      src:
        expand: true
        cwd: 'src'
        src: '**/*.coffee'
        dest: 'lib'
        ext: '.js'
    coffeelint:
      src:
        src: '<%= coffee.src.cwd %>/<%= coffee.src.src %>'
      test:
        src: 'test/**/*.coffee'
      gruntfile:
        src: 'Gruntfile.coffee'
    jsonlint:
      packagejson:
        src: 'package.json'
    watch:
      src:
        files: '<%= coffee.src.cwd %>/<%= coffee.src.src %>'
        tasks: ['coffeelint:src', 'test']
      test:
        files: '<%= coffeelint.test.src %>',
        tasks: ['coffeelint:test', 'test']
      gruntfile:
        files: '<%= coffeelint.gruntfile.src %>'
        tasks: ['coffeelint:gruntfile']
      packagejson:
        files: '<%= jsonlint.packagejson.src %>'
        tasks: ['jsonlint:packagejson']
    exec:
      mocha:
        options: [
          '--compilers coffee:coffee-script'
          '--reporter spec'
          '--colors'
        ],
        cmd: './node_modules/.bin/mocha <%= exec.mocha.options.join(" ") %>'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-jsonlint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-exec'

  grunt.registerTask 'test', ['jsonlint', 'coffeelint', 'exec:mocha']
  grunt.registerTask 'build', ['coffee']
  grunt.registerTask 'default', ['test']
