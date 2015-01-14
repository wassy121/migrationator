#
# ar.rb - ar(1) ruby interface (for debian.rb)
# Copyright (c) 2001 Fumitoshi UKAI <ukai@debian.or.jp>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# $Id: ar.rb,v 1.3 2003/10/07 17:07:02 ukai Exp $
#

# struct ar_hdr
#  {
#   char ar_name[16];           /* Member file name, sometimes / terminated. */
#   char ar_date[12];           /* File date, decimal seconds since Epoch.  */
#   char ar_uid[6], ar_gid[6];  /* User and group IDs, in ASCII decimal.  */
#   char ar_mode[8];            /* File mode, in ASCII octal.  */
#   char ar_size[10];           /* File size, in ASCII decimal.  */
#   char ar_fmag[2];            /* Always contains ARFMAG.  */
# };

module Debian
  class ArError < StandardError; end
  class Ar
    ARMAG = "!<arch>\n"
    SARMAG = 8
    ARFMAG = "`\n"
    AR_HDR_SIZE = (16+12+6+6+8+10+2)
    class ArFile
      class Stat
	def initialize(time,uid,gid,mode,size,dev)
	  @time, @uid, @gid, @mode, @size, @dev = time,uid,gid,mode,size,dev
	end
	def <=>(s) @time <=> s.atime; end
	def atime; @time; end
	def blksize; 0; end
	def blockdev?; false; end
	def blocks; 0; end
	def chardev?; false; end
	def ctime; @time; end
	def dev; @dev; end
	def directory?; false; end
	def executable?; false; end
	def executable_real?; false; end
	def file?; true; end
	def ftype; 'file'; end
	def gid; @gid; end
	def grpowned?; false; end
	def ino; @dev; end
	def mode; @mode; end
	def mtime; @time; end
	def nlink; 1; end
	def owned?; false; end
	def pipe?; false; end
	def rdev; @dev; end
	def readable?; true; end
	def readable_real?; true; end
	def setgid?; false; end
	def setuid?; false; end
	def size; @size; end
	def size?; @size == 0 ? nil : @size; end
	def socket?; false; end
	def sticky?; false; end
	def symlink?; false; end
	def uid; @uid; end
	def writable?; false; end
	def writable_real?; false; end
	def zero?; @size == 0; end
      end

      def initialize(fp,name,date,uid,gid,mode,size,pos)
	@fp,@name = fp,name
	@stat = Stat.new(date,uid,gid,mode,size,pos)
	@size = size
	@pos = pos
	@cur = 0
      end
      attr_reader :name, :size, :pos, :cur, :stat

      def read(size = -1)
	if size < 0
	  size = @size - @cur
	end
	if @cur + size > @size
	  size = @size - @cur
	end
	@fp.seek(@pos + @cur, IO::SEEK_SET)
	r = @fp.read(size)
	@cur += r.size
	return r
      end

      def eof?; @cur == @size; end
      def rewind; @cur = 0; end
    end
    
    def initialize(file)
      @fp = File.open(file)
      magic = @fp.gets
      unless magic == ARMAG
	raise ArError, "archive broken"
      end
      @ofs = []
    end

    def close
      @fp.close
    end

    def list
      @fp.seek(SARMAG, IO::SEEK_SET)
      while ! @fp.eof?
	hdr = @fp.read(AR_HDR_SIZE)
	name,date,uid,gid,mode,size,fmag = hdr.unpack('a16a12a6a6a8a10a2')
	unless fmag == ARFMAG
	  raise ArError, "invalid archive field magic #{fmag} @ #{@fp.pos} [#{hdr}]"
	end
	name.strip!
	size = size.to_i
	@ofs.push(ArFile.new(@fp,
			     name,Time.at(date.to_i), uid.to_i, gid.to_i,
			     mode.oct, size, @fp.pos))
	# puts "hdr=[#{hdr}] pos=#{@fp.pos}, size=#{size} #{(size + 1)&~1}"
	@fp.seek((size + 1)&~1, IO::SEEK_CUR)
      end
      @ofs
    end
    def each_file
      if @ofs.empty?; list; end
      @ofs.each {|file|
	yield file.name, file
      }
    end

    def open(name)
      if @ofs.empty?; list; end
      @ofs.each {|file|
	if file.name == name
	  if block_given?
	    return yield(file)
	  else
	    return file
	  end
	end
      }
    end
  end

end
