#!/home/boris/.rvm/rubies/ruby-2.1.0/bin/ruby

class MazeChar < String
end

class Maze

  WALL = "#" 
  FREE = " " 
  FROM = "A" 
  DEST = "B" 
  PATH = "+" 

  MAX = 100000
  attr_reader :content
  class EndOfExpansion < Exception
    attr_reader :i, :j, :n
    def initialize i,j,n
      @i, @j, @n = i, j, n
    end
  end

  def initialize filename=nil
    if filename
      f = File.open filename
    else
      f = $stdin
    end

    load_f f
    check

    class << @content
      def [](*args)
        super || :just_a_symbol
      end

      def inc_at_if i,j,n
        raise EndOfExpansion.new(i,j,n) if self[i][j] == :dest
         if self[i][j] == :free
           self[i][j] = n
         else
           nil
         end
      end

      def replaceall from, to
        if from.is_a? Symbol
          each_with_indexes {|i,j,v| self[i][j] = to if v  == from }
        elsif from.is_a? Class
          each_with_indexes {|i,j,v| self[i][j] = to if v.is_a? from }
        else
          raise ArgumentError.new
        end
      end

      def each_with_indexes
        each_index do |i|
          self[i].each_with_index do |v, j|
            yield i, j, self[i][j]
          end
        end
      end
    end
  end

  def solve
    n = 0
    begin
      while n < MAX
        expanded = nil
        @content.each_with_indexes do |i, j, v|
          if v == :from or  v == n-1
            get_neig(i,j) do |a| 
              e = @content.inc_at_if(a[0],a[1],n)
              expanded ||= e
            end
          end
        end
        return false unless expanded
      n += 1
      end
    rescue EndOfExpansion => e
      i,j,n = e.i,e.j,e.n
      steps = n
      while n >= 0 do
        n -= 1
        get_neig i,j do |a|
          if @content[a[0]][a[1]] == n
            @content[a[0]][a[1]] = :path
            i, j = a[0], a[1]
            break
          end
        end
      end
      @content.replaceall Fixnum, :free
    end
    steps || false
  end

  def to_s
    string = ""
    @content.each_index do |i|
      @content[i].each do |v|
        char = case v
               when :wall then WALL
               when :free then FREE
               when :from then FROM
               when :dest then DEST
               when :path then PATH
               when Fixnum then (v%10).to_s
               else raise StandardError.new "invalid char in the maze: <#{v}>"
               end
        string <<  char
      end
      string <<  "\n"
    end
    string
  end

  private

  def check
  end

  def get_neig i,j, &block
    [[i,j+1],[i,j-1],[i+1,j],[i-1,j]].shuffle.each {|x| yield x}
  end

  def load_f f
    @content = [[]]
    row = -1
    f.each_line do |l|
      l.strip!
      row += 1
      @content << []
      l.each_char do |c|
        sym = case c
              when WALL then :wall
              when FREE then :free
              when FROM then :from
              when DEST then :dest
              else raise StandardError.new "invalid char in the maze: <#{c}>"
              end
        @content[row] << sym
      end
    end
    @content.pop
  end

end

  m = Maze.new("spec/hard.maze")
  puts m
  m.solve
  puts m
