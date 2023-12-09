# encoding: UTF-8


def jpeg2html()
    
    puts "<html>"
    puts "<head>"
    puts "	<title>PhysNote</title>"
    puts "</head>"
    puts "<body>"
    
    jpeg_file_list = Dir.glob(["./*.jpg", "./*.jpeg"])

    for  jpeg_file in jpeg_file_list 
        #puts "		<h5>#{jpeg_file}</h5>"
        puts "		<img src=\"#{jpeg_file}\">"
    end

    puts "</body>"
    puts "</html>"
end

jpeg2html()