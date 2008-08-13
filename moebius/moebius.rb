#!/usr/bin/ruby
$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'fileutils'
require 'prawn'

# Check filename exists
if ARGV[0].nil?
  echo "Please enter a comic filename"
  exit
end


basename = File.basename(ARGV[0], File.extname(ARGV[0]))
target = "/tmp/#{basename}/"

# Extract comic images
FileUtils.mkdir_p target unless File.exists? target
`unzip -j #{ARGV[0]} -d #{target}` if File.extname(ARGV[0]) == "cbz"
`unrar e #{ARGV[0]} #{target}` if File.extname(ARGV[0]) == "cbr"
comicFiles = Dir.new(target).entries.sort.delete_if { |x| ! (x =~ /jpg$/) }

Prawn::Document.generate("#{basename}.pdf",
                        :top_margin => 0, 
                        :right_margin => 0, 
                        :bottom_margin => 0, 
                        :left_margin => 0,
                        :skip_page_creation => true) do
  comicFiles.each do |file|
    #`mogrify -colorspace gray -resize 842x #{target}#{file}`
    start_new_page
    image "#{target}#{file}", :at => [0,802], :height => 842
  end
end

FileUtils.rm_r "/tmp/#{basename}/"