require 'console_splash'
require 'colorize'


def getboard(width, height)
    gameboard = Array.new
    for y in 0..height
        row = (0..width).map { [:red, :blue, :green, :yellow, :cyan, :magenta].sample }
        gameboard.push(row)
    end
    return gameboard
end

def clear_screen
    print "\e[H\e[2J"
end

def show_board
    $gameboard.each do |row|
        row.each do |box|
            print "  ".colorize(:background => box)
        end
        puts
    end
end

def game_start
    $gameboard = getboard($gameboard_x, $gameboard_y)
    turns = 0
    while true
        clear_screen
        puts
        show_board
        puts "No of turns: #{turns}"
        puts "Completion Status: #{game_status}%"
        print "Choose a color: "
        choice = gets.to_color
        if choice == :quit
            break
        end
        fillGameboard(0, 0, choice)
        turns += 1

        if game_status == 100
            if $score == nil || turns < $score
                $score = turns
            end
            clear_screen
            puts
            show_board
            puts "You won after #{turns} turns\n"
            break
        end
    end
end

def game_status
    current_color = $gameboard[0][0]
    block_count = $gameboard.flatten.length
    count = 0
    $gameboard.flatten.each do |block|
        if block == current_color
            count += 1
        end
    end
    return (count.to_f/block_count*100).to_i 
end

def fillGameboard(x, y, color)
    prev_color = $gameboard[y][x]
    $gameboard[y][x] = color

    if prev_color == color
        return
    end

    if y > 0 && $gameboard[y-1][x] == prev_color
        fillGameboard(x, y-1, color)
    end
    
    if y < $gameboard_y && $gameboard[y+1][x] == prev_color
        fillGameboard(x, y+1, color)
    end

    if x > 0 && $gameboard[y][x-1] == prev_color
        fillGameboard(x-1, y, color)
    end
    
    if x < $gameboard_x && $gameboard[y][x+1] == prev_color
        fillGameboard(x+1, y, color)
    end
end

class String
    def to_color
        case self.chomp.downcase
            when "r", "red"
                :red
            when "b", "blue"
                :blue
            when "g", "green"
                :green
            when "y", "yellow"
                :yellow
            when "c", "cyan"
                :cyan
            when "m", "magenta"
                :magenta
            when "q", "quit"
                :quit
            else
                :red
        end
    end
end

splash = ConsoleSplash.new
splash.write_header("Flixbus", "Soupam Mandal", "1.0")
splash.write_horizontal_pattern("=")
splash.write_vertical_pattern("=")
splash.splash()
gets 

clear_screen

$gameboard_x = 10
$gameboard_y = 6
$gameboard = [[]]
$score = nil

while true
    puts "Options:"
    puts "[s] Start Game"
    puts "[c] Change Default Size"
    puts "[q] Quit"
    
    if $score == nil
        puts "No games played..."
    else
        puts "Best score: #{$score} turns"
    end

    print "Please enter your choice: "
    case gets.chomp.downcase
        when "s"
            game_start
        when "c"
            print "Width [Currently #{$gameboard_x + 1}]: "
            $gameboard_x = gets.to_i - 1

            print "Height [Currently #{$gameboard_y + 1}]: "
            $gameboard_y = gets.to_i - 1

            $score = nil
        when "q"
            puts "Bye"
            break
        else
            puts "Option was not recognized"
    end
end