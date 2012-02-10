require 'mkmf'

# backport from 1.9.x
unless defined?(have_framework) == "method"
  def have_framework(fw, &b)
    checking_for fw do
      src = cpp_include("#{fw}/#{fw}.h") << "\n" "int main(void){return 0;}"
      if try_link(src, opt = "-ObjC -framework #{fw}", &b)
        $defs.push(format("-DHAVE_FRAMEWORK_%s", fw.tr_cpp))
        $LDFLAGS << " " << opt
        true
      else
        false
      end
    end
  end
end

# Ensure that we can actually set the -std flag
$CFLAGS = $CFLAGS.sub('$(cflags) ', '')
$CFLAGS += ' ' + ENV['CFLAGS'] if ENV['CFLAGS']

checking_for "-std=c99 option to compiler" do
  $CFLAGS += " -std=c99" if try_compile '', '-std=c99'
end

unless have_framework('CoreFoundation')
  unless have_library('CoreFoundation')
    $stderr.puts "CoreFoundation is needed to build the Xcodeproj C extension."
    exit -1
  end
end

have_header 'CoreFoundation/CoreFoundation.h'
have_header 'CoreFoundation/CFStream.h'
have_header 'CoreFoundation/CFPropertyList.h'

create_makefile 'xcodeproj_ext'