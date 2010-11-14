# FolderWalker walks folders and calculates
# file and folder size.
#
# Author::    Keith Ballinger  (mailto:keith@gmail.com)
# Copyright:: Copyright (c) 2010 Keith Ballinger
# License::   Distributes under the same terms as Ruby

require "./FolderWalker"
require "./ConsoleReporter"

if __FILE__ == $0
	f = FolderWalker.new("C:/users/keith/downloads")
	f.run
	r = ConsoleReporter.new(f)
	r.print_tree_size()
	#f.print_file_sizes
	#f.print_folder_sizes
end
