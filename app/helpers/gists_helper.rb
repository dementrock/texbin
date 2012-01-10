require 'rdiscount'

module GistsHelper
  def process x
    latex_marker = "TEXBINTOREPLACE"
    latex_list = []
    while true
      exists, start_id, end_id = false, 0, 0
      (0...x.length).each do |i|
        if x[i..i] == "$"
          puts "yeah"
          (i+1...x.length).each do |j|
            if x[j..j] == "$"
              exists, start_id, end_id = true, i, j
              break
            end
          end
          break
        end
      end
      if not exists
        break
      end
      puts "exists"
      latex_list.push(x[start_id..end_id])
      x = x[0...start_id] + latex_marker + x[end_id+1..-1]
    end
    puts x
    x = RDiscount.new(h(x)).to_html
    latex_list.each do |latex|
      (0...x.length).each do |i|
        if x[i...i+latex_marker.length] == latex_marker
          x = x[0...i] + latex + x[i+latex_marker.length..-1]
          break
        end
      end
    end
    x
  end
end
