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
    @dpkg_list = []
    @rpm_list = []
    @unpackaged_files = []
  end

  def gather_facts
    determine_pkg_managers().each do |mgr|
      self.send(:"gather_#{mgr}_files")
      @log.debug "Found" + (eval "@#{mgr}_files.count").to_s + " dpkg files"
    end
    @log.info "Found #{@rpm_files.count} rpm files"
    all_files = [] #gather_all_files()
    @unpackaged_files = all_files -= @dpkg_files -= @rpm_files
    @log.debug "Found #{@unpackaged_files.count} unpackaged files"
    @log.debug "All files counted were #{all_files.count}"
    #gather_dpkg_files()
    #gather_rpm_files()
    #gather_unpackaged_files(pkg_managers)
  end

  def gather_all_files
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
    return found_files
  end

  def gather_dpkg_files
    @log.debug "Starting dpkg search"
    require 'vendor/debian'
    puts Debian::Dpkg::STATUS_FILE
    thr = Thread.new do
      @dpkg_list  = Debian::Packages.new(Debian::Dpkg::STATUS_FILE,   [".*"],[])
    end
    @log.debug "found #{@dpkg_list.count} debian packages"
  end

  def gather_rpm_files
    @log.debug "Starting rpm search"
    #require 'facts/rpm'
    #return Rpm.get_files()
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
