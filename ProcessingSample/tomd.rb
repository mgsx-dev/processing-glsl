require 'date'
require 'fileutils'

module GLSLParser
	class Context
		attr_accessor :site, :dir, :group, :text, :code, :file
	end

	def self.empty?(line)
		line.strip.empty? 
	end

	def self.comment_begin?(line)
		line.strip.start_with?("/**") 
	end

	def self.comment_end?(line)
		line.strip.end_with?("*/") 
	end

	def self.add_code(context, line)
		context.code << line
		context.text << line
	end

	def self.add_text(context, line)
		context.text << line
	end

	def self.add_code_begin(context)
		context.text << ''
		context.text << '``` glsl'
	end
	def self.add_code_end(context)
		context.text << '```'
		context.text << ''
	end

	def self.filename_to_path(filename)
		filename.scan(/([0-9]+)-/).flatten.map{|s| s.to_i}
	end
	def self.path_to_filename(path)
		path.map{|i| "%03d" % i}.join("-")
	end
	def self.find_file(context, path)
		if not path.empty? then
			Dir.glob("#{context.dir}/*.glsl")
				.map{|file| File.basename(file)}
				.select{|file| filename_to_path(file) == path}
				.first
		else
			nil
		end
	end

	def self.remove_ext(filename)
		parts = filename.split(".")
		parts.first(parts.size-1)
	end

	def self.file_to_postfilename(file)
		date = date_from_file(file)
		"#{date.strftime("%Y-%m-%d")}-#{File.basename(file,File.extname(file))}"
	end

	def self.filename_to_postname(filename)
		name = File.basename(filename,File.extname(filename))
		path = filename_to_path(filename)
		names = name.split('-')
		words = names.last(names.size - path.size).map{|word| word[0].upcase + word[1..(word.size)]}.join(' ')
		return path.join('.') + ' - ' + words
	end

	def self.post_datetime(file)
		date = date_from_file(file)
		"#{date.strftime("%Y-%m-%d %H:%M:%S")}"
	end

	def self.date_from_file(file)
		Date.new(2015, 7, 21) # File.mtime(file)
	end

	def self.eof(context)

		# find previous and next tutorial

		# first parse filename
		filename = File.basename(context.file)

		basename = File.basename(filename,File.extname(filename))

		postname = filename_to_postname(filename)

		path = filename_to_path(filename)
		return if path.empty?
		parent_path = path.first(path.size-1)
		prev_path = parent_path + [path.last - 1]
		next_path = parent_path + [path.last + 1]
		child_path = path + [1]

		prev_file = find_file(context, prev_path)
		next_file = find_file(context, next_path)
		parent_file = find_file(context, parent_path)
		child_file = find_file(context, child_path)

		lines = []

		preview_ext = File.extname(Dir.glob("#{context.site}/img/blog/#{context.group}/thumb/#{basename}.*").first)

		# Jekyll header
		lines << "---"
		lines << "layout: glsl"
		lines << "name:  \"#{postname}\""
		lines << "date:   #{post_datetime(context.file)}"
		lines << "type: glsl"
		lines << "group: #{context.group}"
		lines << "preview: /img/blog/#{context.group}/thumb/#{basename}#{preview_ext}"
		lines << "screenshot: /img/blog/#{context.group}/#{basename}.png"
		lines << "excerpt: \"#{context.text.first}\"" unless context.text.empty?

		if prev_file and File.exists?("#{context.dir}/#{prev_file}") then
			lines << "before: #{filename_to_postname(prev_file)}"
		end
		if next_file and File.exists?("#{context.dir}/#{next_file}") then
			lines << "after: #{filename_to_postname(next_file)}"
		end
		if parent_file and File.exists?("#{context.dir}/#{parent_file}") then
			lines << "parent: #{filename_to_postname(parent_file)}"
		end
		if child_file and File.exists?("#{context.dir}/#{child_file}") then
			lines << "child: #{filename_to_postname(child_file)}"
		end

		lines << "---"

		# markdown layout
		lines << "## Explainations"
		lines << ""
		lines += context.text
		lines << ""
		lines << "## Full Code Source"
		lines << ""
		lines << "``` glsl"
		lines += context.code
		lines << "```"

		# make filename for jekyll

		folder = "#{context.site}/_posts/#{context.group}"

		FileUtils.makedirs(folder)

		File.write("#{folder}/#{file_to_postfilename(context.file)}.md", lines.join("\n"));
	end

	INIT = {
		file: lambda {|ctx, file|
			ctx.file = file
			ctx.code = []
			ctx.text = []
			FIRST
		},
		eof: lambda {|ctx|
			INIT
		}
	}

	FIRST = {
		line: lambda {|ctx, line|
			case
			when empty?(line) then FIRST
			when comment_begin?(line) then TEXT
			else add_code_begin(ctx); add_code(ctx, line); CODE
			end
		},
		eof: lambda {|ctx|
			eof(ctx)
			INIT
		}
	}

	CODE = {
		line: lambda {|ctx, line|
			case
			when comment_begin?(line) then add_code_end(ctx); TEXT
			else add_code(ctx, line); CODE
			end
		},
		eof: lambda {|ctx|
			add_code_end(ctx)
			eof(ctx)
			INIT
		}
	}

	TEXT = {
		line: lambda {|ctx, line|
			case
			when comment_end?(line) then FIRST
			else add_text(ctx, line); TEXT
			end
		},
		eof: lambda {|ctx|
			eof(ctx)
			INIT
		}
	}

end

context = GLSLParser::Context.new

root = ARGV[0]

context.site = ARGV[1]

state = GLSLParser::INIT

Dir.glob("#{root}/*").each do |group|
	if File.directory?(group) then
		context.dir = group
		context.group = File.basename(group)
		Dir.glob("#{group}/*.glsl").each do |file|
			content = File.read(file)
			state = state[:file].call(context, file)
			content.split("\n").each do |line|
				state = state[:line].call(context, line)
			end
			state = state[:eof].call(context)
		end
	end
end

