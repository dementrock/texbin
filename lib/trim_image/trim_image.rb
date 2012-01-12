require "rmagick"

module TrimImage

  class Trimmer

    WHITE = 250

    def initialize(filename)
      @filename = filename
      @image    = Magick::Image.read(filename).first
      @width    = @image.columns
      @height   = @image.rows
    end

    def white?(x, y)
      if x && y
        p = @image.pixel_color(x, y)
        %w( red green blue ).all? { |c| p.send(c) >= WHITE }
      elsif x
        (0 ... @height).all? { |y| white? x, y }
      elsif y
        (0 ... @width).all? { |x| white? x, y }
      end
    end

    # Determines and x and y that should be good to use for scanning the image.
    def calculate_center(x = nil, y = nil, width = nil, height = nil)
      x      ||= @width / 2
      y      ||= @height / 2
      width  ||= @width
      height ||= @height

      return @coords if @coords
      return (@coords = [x, y]) if !white?(x, y)
      return if width <= 2 || height <= 2

      if coords = calculate_center(x - width/2, y - height/2, width/2, height/2)
        return coords
      end

      if coords = calculate_center(x - width/2, y + height/2, width/2, height/2)
        return coords
      end

      if coords = calculate_center(x + width/2, y - height/2, width/2, height/2)
        return coords
      end

      if coords = calculate_center(x + width/2, y + height/2, width/2, height/2)
        return coords
      end
    end

    def nonwhite_top
      # Find a good x to use.
      x0 = calculate_center[0]

      # Start with a quick scan down to find the first y that is not white.
      y = 0
      y += 1 while (y < @height - 1) && white?(x0, y)

      # Now move back up until we find a row that is all white.
      y -= 1 while (y > 0) && !white?(nil, y)

      return y
    end

    def nonwhite_bottom
      # Find a good x to use.
      x0 = calculate_center[0]

      # Start with a quick scan up to find the first y that is not white.
      y = @height - 1
      y -= 1 while (y > 0) && white?(x0, y)

      # Now move back down until we find a row that is all white.
      y += 1 while (y < @height - 1) && !white?(nil, y)

      return y
    end

    def nonwhite_left
      # Find a good y to use.
      y0 = calculate_center[1]

      # Start with a quick scan right to find the first x that is not white.
      x = 0
      x += 1 while (x < @width - 1) && white?(x, y0)

      # Now move back left until we find a column that is all white.
      x -= 1 while (x > 0) && !white?(x, nil)

      return x
    end

    def nonwhite_right
      # Find a good y to use.
      y0 = calculate_center[1]

      # Start with a quick scan left to find the first x that is not white.
      x = @width - 1
      x -= 1 while (x > 0) && white?(x, y0)

      # Now move back right until we find a column that is all white.
      x += 1 while (x < @width - 1) && !white?(x, nil)

      return x
    end

    def write(output = nil)
      output ||= @filename

      x      = [nonwhite_left - 5, 0].max
      y      = [nonwhite_top - 5, 0].max
      width  = [nonwhite_right + 5, @width].min - x
      height = [nonwhite_bottom + 5, @height].min - y

      @image.crop(x, y, width, height).write(output)
    end

  end

end
