class Codebreaker 
    attr_accessor :input
    attr_accessor :turns
    @@turns = 1  
    def initialize
        puts "The codemaker is challenging you to break his 4 digit secret code,"
        puts "with numbers ranging from 1 to 6."
        puts "You have twelve turns to find the correct answer, and each time you"
        puts "enter a guess, the codemaker will give you a hint on how close you are."
        puts "The color Green indicates the right number in the right spot."
        puts "Red indicates that the number is in the code but in the wrong spot."
        puts "Black means the number is not part of the code."
        generatePegs 
        display_pegs
        user_input 
    end 
    def display_pegs
        @pegboard = ["#","#","#","#"]
        p @pegboard
    end 
    def user_input
        puts "Enter your guess: "
        @input = gets.chomp.split("").map {|entry| entry.to_i}
        check_input
        while check_input == false do 
            puts "\nInvalid value, enter a new one: "
            @input = gets.chomp.split("").map {|entry| entry.to_i}
            check_input
        end
        check_pegs(@input,@pegs)
    end

    protected 
    def guesses
        if @@turns == 12
            puts "\nThis is your last chance! Focus!"
        else
            puts "\nKeep trying! You still have #{12 - @@turns} chances left..."
        end
        @@turns += 1
        user_input
    end

    private
    def check_input
        valid_entries = 0
        @input.each do |entry|
            if entry > 0 && entry <= 6
                valid_entries += 1
            end
        end
        if valid_entries == 4 && @input.length == 4
            return true
        else
            return false 
        end
    end
 
    def generatePegs
        @pegs = []
        4.times do 
            peg = rand(1..6)
            @pegs.push(peg)
        end  
        return @pegs  
    end
    
    def check_pegs(input,pegs)
        feedback = []
        for i in 0..3
            if @pegs.include?(@input[i])
                if @pegs[i] == @input[i]
                    feedback.push("Green")
                else
                    feedback.push("Red")
                end
            else
                feedback.push("black")
            end
        end
        puts "Guess #{@@turns}: #{input} == " + feedback.join(" | ")
        if input == pegs
            puts pegs.join("  |  ")
            puts"\n Congratulations!, You broke the mastermind code!"
        elsif @@turns > 12
            puts "\n Too bad... the codemaker has outsmarted you!"
        else
            guesses
        end    
    end
end

class Codemaker
    attr_accessor :input
    attr_accessor :turns 
    @@turns = 1
    def initialize
        puts "You decided to challenge the A.I to break your mastermind code"
        user_input
    end

    def user_input
        puts "Enter your Code: "
        @input = gets.chomp.split("").map {|entry| entry.to_i}
        check_input
        while check_input == false do 
            puts "\nInvalid value, enter a new one: "
            @input = gets.chomp.split("").map {|entry| entry.to_i}
            check_input
        end
        decipher(@input)
    end

    def check_input
        valid_entries = 0
        @input.each do |entry|
            if entry.to_i > 0 && entry.to_i <= 6
                valid_entries += 1
            end
        end
        if valid_entries == 4 && @input.length == 4
            return true
        else
            return false 
        end
    end

    def compFeed(guess,feedback)
        guess.each_with_index do |num,index|
            if input.include?(num)
                if num == input[index]
                    feedback[index] = "Green"
                else
                    feedback[index] = "Red"
                end
            else
                feedback[index] = "black"
            end
        end
        return feedback
    end


    def decipher(input)
        @guess = []
        pegs = [1,2,3,4,5,6]
        4.times do
            peg = pegs.sample
            @guess.push(peg)
        end
        feedback = ["X","X","X","X"]
        compFeed(@guess,feedback)
        puts " Guess #{@@turns}: #{@guess} == " + feedback.join(" | ")
        sleep(1)
        while @guess != input && @@turns < 12 do 
            @@turns += 1
            @guess.each_with_index do |num,index|
                if input.include?(num)
                    if num == input[index]
                        @guess[index] = num
                    else
                        @guess[index] = pegs.sample
                        while @guess[index] == num
                            @guess[index] = pegs.sample
                        end    
                    end
                else
                    pegs.delete(num)
                    @guess[index] = pegs.sample
                end
            end
            compFeed(@guess,feedback)
            puts "\n Guess #{@@turns}: #{@guess} == " + feedback.join(" | ")
            sleep(1)
        end
        if @guess == input
            puts "\n The A.I has broken your code! Robot takeover incoming..."
        else
            puts "\n The A.I could not crack your code, humans are still safe, for now..."
        end
        @@turns = 1
    end

end

def main
    puts "Welcome to mastermind!"
    puts "Press 1 to be the codebreaker or 2 to be the codemaker."
    choice = gets.chomp.to_i
    while choice != 1 && choice != 2 do
        puts "Invalid choice, try again:"
        choice = gets.chomp.to_i
    end
    if choice == 1
        Codebreaker.new
    else
        Codemaker.new
    end
    playAgain
end

def playAgain
    puts "\n Would you like to play again?"
    puts "y/n"
    play = gets.chomp
    if play.upcase == "Y"
        main
    end
end

main

