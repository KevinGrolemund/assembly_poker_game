play_poker: main.o shuffle.o deal_cards.o print_cards.o user_input.o replace_card.o print_poker.o count_poker_runs.o check_flush.o check_straight.o
	gcc -o play_poker main.o shuffle.o deal_cards.o print_cards.o user_input.o replace_card.o print_poker.o count_poker_runs.o check_flush.o check_straight.o -L /home/scg/csci212_fall2024/Lab5 -lmylib

main.o: main.s
	gcc -g -c main.s

shuffle.o: shuffle.s
	gcc -g -c shuffle.s

deal_cards.o: deal_cards.s
	gcc -g -c deal_cards.s
	
print_cards.o: print_cards.s
	gcc -g -c print_cards.s

user_input.o: user_input.s
	gcc -g -c user_input.s

replace_card.o: replace_card.s
	gcc -g -c replace_card.s
	
print_poker.o: print_poker.s
	gcc -g -c print_poker.s
	
count_poker_runs.o: count_poker_runs.s
	gcc -g -c count_poker_runs.s	

check_flush.o: check_flush.s
	gcc -g -c check_flush.s

check_straight.o: check_straight.s
	gcc -g -c check_straight.s

clean:
	rm *.o play_poker
	