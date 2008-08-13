#!/usr/bin/env ruby

# Moebius: Simple comic book converter script.
#
# Things Prawn can do to make this script nicer:
#   * Allow :margins => [0,0,0,0] or :margins => :none (or something like that)  


require "rubygems"    
require "prawn"
require 'fileutils'
require 'tempfile'

# Check filename exists
if ARGV[0].nil?
  print "Please enter a comic filename\n"
  exit
end

basename = File.basename(ARGV[0], File.extname(ARGV[0]))
target = "/#{Dir::tmpdir}/#{basename}/"
                     
# Extract comic images      
FileUtils.mkdir_p target unless File.exists? target      
`unzip -j #{ARGV[0]} -d #{target}` if File.extname(ARGV[0]) =~ /cbz/i
`unrar e #{ARGV[0]} #{target}` if File.extname(ARGV[0]) =~ /cbr/i
comicFiles = Dir["#{target}*.jpg"]      

settings =  { :skip_page_creation => true,
                   :bottom_margin => 0,        
                      :top_margin => 0, 
                    :right_margin => 0, 
                     :left_margin => 0       }
 
# Generate PDF file            
Prawn::Document.generate("output/#{basename}.pdf", settings) do
  comicFiles.each do |file|
    start_new_page
    image file, :at => [0,802], :height => 842
  end
end

# Remove tmp files
FileUtils.rm_r target