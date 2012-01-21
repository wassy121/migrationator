#
# filesystems.rb
#

require 'thread'
require 'facter'

if Facter.value(:kernel) == 'Linux'
  mutex = Mutex.new
  # We store our lists
  supported_file_systems = []
  unsupported_file_systems = []
  mtab_includes = []
  mtab_excludes = []
  mounted_devices = []
  excluded_paths = []
  # We don't need fuseblk
  exclude = %w(fuseblk)

  # Make regular expression form our patterns ...
  exclude = Regexp.union(*exclude.collect { |i| Regexp.new(i) })

  Facter::Util::Resolution.exec('cat /proc/filesystems 2> /dev/null').each_line do |line|
    line.strip!
    if (line.empty? or line.match(/^nodev/) or line.match(exclude))
      mutex.synchronize { unsupported_file_systems << line }
    else
      mutex.synchronize { supported_file_systems << line }
    end
  end

  Facter.add('fs_types') do
    confine :kernel => :linux
    setcode { file_systems.sort.join(',') }
  end

  # look for supported filesystems mounted
  fs_regexp = Regexp.union(supported_file_systems.collect { |i| Regexp.new(i) })

  Facter::Util::Resolution.exec('cat /etc/mtab 2>/dev/null').each_line do |mount|
    mount.strip
    next if mount.empty?
    if mount.match(fs_regexp) 
      mutex.synchronize { mtab_includes << mount}
    else
      mutex.synchronize { mtab_excludes << mount}
    end
  end

  mtab_includes.each do |fs|
    fs_line = fs.split
    mounted_devices << fs_line[0]
    Facter.add('fs_' + fs_line[0]) do
      setcode do
        fs_line[1]
      end
    end
  end

  mtab_excludes.each do |fs|
    excluded_paths << fs.split()[1]
  end
  
  Facter.add('excluded_devices') do
    setcode do
      excluded_paths.sort.join(',')
    end
  end

  Facter.add('mounted_devices') do
    setcode do
      mounted_devices.sort.join(',')
    end
  end
end
