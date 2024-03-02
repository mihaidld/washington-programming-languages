# encounter-tests.rb

require_relative "./encounter-solution"

# Will print only if code has errors; prints nothing if all tests pass

# Variables for testing
k1 = Knight.new(15, 3)
k2 = Knight.new(10, 10)
k3 = Knight.new(0, 15)
w1 = Wizard.new(3, 50)
w2 = Wizard.new(8, 5)

# Constants for testing
D1 =  [Monster.new(1, 1),
    FloorTrap.new(3),
    Monster.new(5, 3),
    Potion.new(5, 5),
    Monster.new(1, 15),
    Armor.new(10),
    FloorTrap.new(5),
    Monster.new(10, 10)]

D2 = [
    Potion.new(3, 3),
    Monster.new(1, 1),
    Monster.new(2, 2),
    Monster.new(4, 4),
    FloorTrap.new(3),
    Potion.new(3, 3),
    Monster.new(4, 4),
    Monster.new(8, 8),
    Armor.new(5),
    Monster.new(3, 5),
    Monster.new(6, 6),
    FloorTrap.new(5)
]

c1 = Adventure.new(Null.new,k1,D1).play_out
if not ((c1.is_a? Knight) and c1.hp == 8 and c1.ap == 0) 
	puts "K1 on adventure D1 wrong result"
	puts c1.to_s
end

c2 = Adventure.new(Null.new,k2,D1).play_out
if not ((c2.is_a? Knight) and c2.hp == 10 and c2.ap == 0) 
	puts "K2 on adventure D1 wrong result"
	puts c2.to_s
end

c3 = Adventure.new(Null.new,k3,D1).play_out
if not ((c3.is_a? Knight) and c3.hp == 0 and c3.ap == 15) 
	puts "K3 on adventure D1 wrong result"
	puts c3.to_s
end

c4 = Adventure.new(Null.new,w1,D1).play_out
if not ((c4.is_a? Wizard) and c4.hp == 8 and c4.mp == 24) 
	puts "W1 on adventure D1 wrong result"
	puts c4.to_s
end

c5 = Adventure.new(Null.new,w2,D1).play_out
if not ((c5.is_a? Wizard) and c5.hp == 13 and c5.mp == -10) 
	puts "W2 on adventure D1 wrong result"
	puts c5.to_s
end

# re-assign since variables mutated
k1 = Knight.new(15, 3)
k2 = Knight.new(10, 10)
k3 = Knight.new(0, 15)
w1 = Wizard.new(3, 50)
w2 = Wizard.new(8, 5)

c6 = Adventure.new(Null.new,k1,D2).play_out
if not ((c6.is_a? Knight) and c6.hp == -2 and c6.ap == 0) 
	puts "K1 on adventure D2 wrong result"
	puts c6.to_s
end

c7 = Adventure.new(Null.new,k2,D2).play_out
if not ((c7.is_a? Knight) and c7.hp == 0 and c7.ap == 0) 
	puts "K2 on adventure D2 wrong result"
	puts c7.to_s
end

c8 = Adventure.new(Null.new,k3,D2).play_out
if not ((c8.is_a? Knight) and c8.hp == 0 and c8.ap == 15) 
	puts "K3 on adventure D2 wrong result"
	puts c8.to_s
end

c9 = Adventure.new(Null.new,w1,D2).play_out
if not ((c9.is_a? Wizard) and c9.hp == 9 and c9.mp == 24) 
	puts "W1 on adventure D2 wrong result"
	puts c9.to_s
end

c10 = Adventure.new(Null.new,w2,D2).play_out
if not ((c10.is_a? Wizard) and c10.hp == 14 and c10.mp == -1) 
	puts "W2 on adventure D2 wrong result"
	puts c10.to_s
end
