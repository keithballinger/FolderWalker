# FolderWalker walks folders and calculates
# file and folder size.
#
# Author::    Keith Ballinger  (mailto:keith@gmail.com)
# Copyright:: Copyright (c) 2010 Keith Ballinger
# License::   Distributes under the same terms as Ruby

require "./FolderWalker"
require "./Reporter"

if __FILE__ == $0
	f = FolderWalker.new("C:/users/keith/downloads")
	f.run
	r = Reporter.new(f)
	r.print_tree_size
	r.print_file_sizes
	r.print_folder_sizes
	r.print_file_sizes(Format::CSV)
	r.print_folder_sizes(Format::CSV)
end
