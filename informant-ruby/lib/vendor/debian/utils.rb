#
# utils.rb - ruby utilities interface for debian.rb (gunzip, tar, ..)
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
# $Id: utils.rb,v 1.2 2003/10/07 17:07:02 ukai Exp $
#

module Debian
  module Utils
    GUNZIP = '/bin/gunzip'
    TAR = '/bin/tar'
    TAR_EXTRACT = '-x'
    TAR_LIST = '-t'
    
    def Utils.pipeline(io,progs,stderr = false)
      Signal.trap('CHLD', 'IGNORE')
      # wr0 -> rd0 [gunzip] wr -> rd
      rd,wr = IO.pipe
      rde,wre = IO.pipe
      pid = fork
      if pid
	# parent
	wr.close
	wre.close
	if block_given?
	  return yield(rd, rde)
	else
	  return rd, rde
	end
      else
	# child
	rd.close
	rd0, wr0 = IO.pipe
        pid2 = fork
	if pid2
	  # gunzip
	  wr0.close
          STDOUT.reopen(wr)
          STDERR.reopen(wre) if stderr
          STDIN.reopen(rd0)
          ENV["LANG"] = "C"
          ENV["LC_ALL"] = "C"
	  exec(*progs)
          # XXX: waitpid(pid2?)
	else
	  rd0.close
	  while ! io.eof?
	    wr0.write(io.read(4096))
	  end
	  exit 0
	end
      end
      Process.waitpid(pid, 0)
      Process.wait
    end

    def gunzip(io)
      Utils.pipeline(io, [GUNZIP]) {|fp,fpe|
        fpe.close
	if block_given?
	  return yield(fp)
	else
	  return fp
	end
      }
    end
    def tar(io,op,*pat)
      progs = [TAR, op, '--wildcards', '-f', '-']
      if pat[0]
	progs += ['--to-stdout', *pat]
      end
      Utils.pipeline(io,progs,op == "-t") {|fp,fpe|
        if op == "-t"
          pid = fork
          if pid
            # parent
          else
            while !fpe.eof? && str = fpe.readline
              unless str.match(/^\/bin\/tar: Record size = [0-9]+ blocks$/)
                STDERR.puts str
              end
            end
            exit
          end
        end
        fpe.close
	if block_given?
	  return yield(fp)
	else
	  return fp
	end
      }
    end

    module_function :gunzip, :tar
  end
end
