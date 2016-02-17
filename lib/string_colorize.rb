# String class methods to allow colored formatting of text.
class String
  # colorize some text!
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
  def black;          "\033[0;30m#{self}\033[0m"; end
  def black_bold;    "\033[1;30m#{self}\033[0m"; end
  def red;            "\033[0;31m#{self}\033[0m"; end
  def red_bold;      "\033[1;91m#{self}\033[0m"; end
  def green;          "\033[0;32m#{self}\033[0m"; end
  def green_bold;    "\033[1;32m#{self}\033[0m"; end
  def brown;          "\033[0;33m#{self}\033[0m"; end
  def brown_bold;    "\033[1;33m#{self}\033[0m"; end
  def blue;           "\033[0;34m#{self}\033[0m"; end
  def blue_bold;     "\033[1;34m#{self}\033[0m"; end
  def magenta;        "\033[0;35m#{self}\033[0m"; end
  def magenta_bold;  "\033[1;35m#{self}\033[0m"; end
  def cyan;           "\033[0;36m#{self}\033[0m"; end
  def cyan_bold;     "\033[1;36m#{self}\033[0m"; end
  def gray;           "\033[0;37m#{self}\033[0m"; end
  def gray_bold;     "\033[1;37m#{self}\033[0m"; end
  def bg_black;       "\033[0;40m#{self}\033[0m"; end
  def bg_red;         "\033[1;41m#{self}\033[0m"; end
  def bg_green;       "\033[0;42m#{self}\033[0m"; end
  def bg_brown;       "\033[1;43m#{self}\033[0m"; end
  def bg_blue;        "\033[0;44m#{self}\033[0m"; end
  def bg_magenta;     "\033[1;45m#{self}\033[0m"; end
  def bg_cyan;        "\033[0;46m#{self}\033[0m"; end
  def bg_gray;        "\033[1;47m#{self}\033[0m"; end
  def bold;           "\033[0;1m#{self}\033[22m"; end
  def reverse_color;  "\033[0;7m#{self}\033[27m"; end

  # rubocop:disable Metrics/MethodLength
  def self.showcolors
    puts 'black'.black
    puts 'black bold'.black_bold
    puts 'red'.red
    puts 'red bold'.red_bold
    puts 'green'.green
    puts 'green bold'.green_bold
    puts 'brown'.brown
    puts 'brown bold'.brown_bold
    puts 'blue'.blue
    puts 'blue bold'.blue_bold
    puts 'magenta'.magenta
    puts 'magenta bold'.magenta_bold
    puts 'cyan'.cyan
    puts 'cyan bold'.cyan_bold
    puts 'gray'.gray
    puts 'gray bold'.gray_bold
    puts 'bg_black'.bg_black
    puts 'bg_black bold'.bg_black_bold
    puts 'bg_red'.bg_red
    puts 'bg_red bold'.bg_red_bold
    puts 'bg_green'.bg_green
    puts 'bg_green bold'.bg_green_bold
    puts 'bg_brown'.bg_brown
    puts 'bg_brown bold'.bg_brown_bold
    puts 'bg_blue'.bg_blue
    puts 'bg_blue bold'.bg_blue_bold
    puts 'bg_magenta'.bg_magenta
    puts 'bg_magenta bold'.bg_magenta_bold
    puts 'bg_cyan'.bg_cyan
    puts 'bg_cyan bold'.bg_cyan_bold
    puts 'bg_gray'.bg_gray
    puts 'bg_gray bold'.bg_gray_bold
    puts 'bold'.bold
    puts 'reverse_color'.reverse_color
  end
end
