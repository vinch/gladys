module.exports = (grunt) ->
  grunt.initConfig {
    pkg: grunt.file.readJSON 'package.json'
    concat: {
      dist: {
        src: [
          'bower_components/jquery/jquery.js'
          'bower_components/modernizr/modernizr.js'
          'bower_components/handlebars/handlebars.js'
          'bower_components/underscore/underscore.js'
          'bower_components/underscore.string/dist/underscore.string.min.js'
        ]
        dest: 'public/js/dist/website.js'
      }
    }
    uglify: {
      options: {
        report: 'min'
      }
      build: {
        src: 'public/js/dist/website.js'
        dest: 'public/js/dist/website.min.js'
      }
    }
  }

  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.registerTask 'components', ['concat', 'uglify']