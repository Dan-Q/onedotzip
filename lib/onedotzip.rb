require 'bundler/setup'
require 'yaml'
require 'fileutils'
require 'zip'

class Passage
	def initialize(content)
		parts = content.split(/\r?\n-{3}\r?\n/, 2)
		@meta = (2 == parts.length) ? YAML.load(parts[0]) : {}
		@content = parts.last.strip
	end

	def compile(outputfile)
		puts "#{outputfile}.zip"
		encrypter = @meta['password'] ? Zip::TraditionalEncrypter.new(@meta['password']) : nil
		inner_files = ["#{outputfile.to_i + 1}.zip"].select{|f|File.exist?(f)}
		buffer = Zip::OutputStream.write_buffer(StringIO.new(''), encrypter) do |zip|
			zip.put_next_entry("#{outputfile}.txt")
			zip.write "#{@content.strip}\n"
			inner_files.each do |inner_file|
				zip.put_next_entry inner_file
				zip.write File.read(inner_file)
			end
		end
		File.open("#{outputfile}.zip", 'wb') {|f| f.write(buffer.string) }
	end
end

class Story
	def initialize(storyfile)
		raise "Storyfile doesn't exist: #{storyfile}" unless File.exist?(storyfile)
		@story = File.read(storyfile)
	end

	def parse
		return if @passages
		@passages = @story.split(/\r?\n-{8}\r?\n/).map(&:strip).reject{|p|p==''}.map{|p|Passage.new(p)}
	end

	def build(outputfile)
		outputfile ||= 1 # default story file = 1.zip
		parse
		tmpdir = Dir.mktmpdir('buildtmp', './')
		FileUtils.cd(tmpdir) do
			num_passages = @passages.length
			@passages.reverse.each_with_index do |passage, i|
				passagefile = ((num_passages - 1) == i) ? outputfile : (num_passages - i)
				puts passagefile
				passage.compile(passagefile)
			end			
		end
		# FileUtils.rm_rf tmpdir
	end
end
