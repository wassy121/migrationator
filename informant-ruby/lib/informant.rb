require 'facter'
require 'facts/filesystem'
require 'logger'
require 'thread'
require 'find'

class Informant

  SUPPORTED_PKG_MANAGERS = ["rpm", "dpkg"]

  def initialize
    @log = Logger.new('log/output.log')
    @log.level = Logger::DEBUG
    @dpkg_files = []
    @rpm_files = []
  end

  def gather_facts
    determine_pkg_managers().each do |mgr|
      puts mgr
      self.send(:"gather_#{mgr}_files")
    end
    #gather_dpkg_files()
    #gather_rpm_files()
    #gather_unpackaged_files(pkg_managers)
  end

  def gather_unpackaged_files
    mutex = Mutex.new
    found_files = []

    Facter.value(:mounted_devices).split(',').each do |device|
      thr = Thread.new do
      @log.info "Starting find on " + device
        Find.find(Facter.value(:"fs_#{device}")) do |line|
          if Facter.value(:excluded_devices).split(',').include? line
            Find.prune
          else
            mutex.synchronize { found_files << line }
          end
        end
      end
      thr.join
    end

    found_files -= @dpkg_files
    found_files -= @rpm_files
    return found_files
  end

  def gather_dpkg_files
    @log.info "Starting dpkg search"
    require 'debian'
  end

  def gather_rpm_files
    @log.info "Starting rpm search"
  end

  def determine_pkg_managers()
    package_managers = []
    ENV['PATH'].split(':').each do |loc|
      SUPPORTED_PKG_MANAGERS.each do |mgr|
        package_managers << mgr if File.exists?(File.join(loc,mgr))
      end
    end
    return package_managers
  end
end
