# Warbler web application assembly configuration file
Warbler::Config.new do |config|
  # Application directories to be included in the webapp.
  config.dirs = %w(app config lib bin log)

  # Additional files/directories to include, above those in config.dirs
  # config.includes = FileList["db"]
  # config.excludes = FileList["lib/tasks/*"]
  # config.java_libs += FileList["opt/java/*.jar"]
  # config.java_classes = FileList["target/classes/**.*"]

  # An array of Bundler groups to avoid including in the war file.
  # Defaults to ["development", "test"].
  # config.bundle_without = []

  # Jar file name. Defaults to the basename of the project directory.
  config.jar_name = "informant"
end
