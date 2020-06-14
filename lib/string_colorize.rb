# String class methods to allow colored formatting of text.
class String
  # colorize some text!
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
  def black;          "\033[0;30m#{self}\033[0m"; end
  def black_bold;     "\033[1;30m#{self}\033[0m"; end
  def red;            "\033[0;31m#{self}\033[0m"; end
  def red_bold;       "\033[1;91m#{self}\033[0m"; end
  def RED;            red_bold; end
  def green;          "\033[0;32m#{self}\033[0m"; end
  def green_bold;     "\033[1;32m#{self}\033[0m"; end
  def GREEN;          "\033[1;92m#{self}\033[0m"; end
  def brown;          "\033[0;33m#{self}\033[0m"; end # yellow
  def brown_bold;     "\033[1;33m#{self}\033[0m"; end # yellow
  def yellow;         "\033[1;49;93m#{self}\033[0m"; end
  def YELLOW;         yellow; end
  def blue;           "\033[0;34m#{self}\033[0m"; end
  def blue_bold;      "\033[1;34m#{self}\033[0m"; end
  def magenta;        "\033[0;35m#{self}\033[0m"; end
  def magenta_bold;   "\033[1;35m#{self}\033[0m"; end
  def cyan;           "\033[0;36m#{self}\033[0m"; end
  def cyan_bold;      "\033[1;36m#{self}\033[0m"; end
  def CYAN;           "\033[1;96m#{self}\033[0m"; end
  def gray;           "\033[0;37m#{self}\033[0m"; end
  def gray_bold;      "\033[1;37m#{self}\033[0m"; end
  def bg_black;       "\033[0;40m#{self}\033[0m"; end
  def bg_black_bold;  "\033[1;40m#{self}\033[0m"; end
  def bg_red;        "\033[0;41m#{self}\033[0m"; end
  def bg_red_bold;     "\033[1;41m#{self}\033[0m"; end
  def bg_green;       "\033[0;42m#{self}\033[0m"; end
  def bg_green_bold;  "\033[1;42m#{self}\033[0m"; end
  def bg_brown;       "\033[0;43m#{self}\033[0m"; end
  def bg_brown_bold;  "\033[1;43m#{self}\033[0m"; end
  def bg_blue;        "\033[0;44m#{self}\033[0m"; end
  def bg_blue_bold;   "\033[1;44m#{self}\033[0m"; end
  def bg_magenta;     "\033[0;45m#{self}\033[0m"; end
  def bg_magenta_bold; "\033[1;45m#{self}\033[0m"; end
  def bg_cyan;        "\033[0;46m#{self}\033[0m"; end
  def bg_cyan_bold;   "\033[1;46m#{self}\033[0m"; end
  def bg_gray;        "\033[0;47m#{self}\033[0m"; end
  def bg_gray_bold;  "\033[1;47m#{self}\033[0m"; end
  def bold;           "\033[0;1m#{self}\033[22m"; end
  def reverse_color;  "\033[0;7m#{self}\033[27m"; end

  def self.showcolors
    puts 'black'.black
    puts 'black_bold'.black_bold
    puts 'red'.red
    puts 'red_bold'.red_bold
    puts 'RED'.RED
    puts 'green'.green
    puts 'green_bold'.green_bold
    puts 'GREEN'.GREEN
    puts 'brown'.brown
    puts 'brown_bold'.brown_bold
    puts 'yellow'.yellow
    puts 'YELLOW'.YELLOW
    puts 'blue'.blue
    puts 'blue_bold'.blue_bold
    puts 'magenta'.magenta
    puts 'magenta_bold'.magenta_bold
    puts 'cyan'.cyan
    puts 'cyan_bold'.cyan_bold
    puts 'CYAN'.CYAN
    puts 'gray'.gray
    puts 'gray_bold'.gray_bold
    puts 'bg_black'.bg_black
    puts 'bg_black_bold'.bg_black_bold
    puts 'bg_red'.bg_red
    puts 'bg_red_bold'.bg_red_bold
    puts 'bg_green'.bg_green
    puts 'bg_green_bold'.bg_green_bold
    puts 'bg_brown'.bg_brown
    puts 'bg_brown_bold'.bg_brown_bold
    puts 'bg_blue'.bg_blue
    puts 'bg_blue_bold'.bg_blue_bold
    puts 'bg_magenta'.bg_magenta
    puts 'bg_magenta_bold'.bg_magenta_bold
    puts 'bg_cyan'.bg_cyan
    puts 'bg_cyan_bold'.bg_cyan_bold
    puts 'bg_gray'.bg_gray
    puts 'bg_gray_bold'.bg_gray_bold
    puts 'bold'.bold
    puts 'reverse_color'.reverse_color
  end
end
