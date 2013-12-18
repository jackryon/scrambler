require_relative "jumbler_funcs"


# program input (first arg only) to array of chars
char_array = ARGV[0].split('')

# distribution model file
distribution_model_filename = "DISTRO_CLEAN_alice.txt"

# how many likely permutations we want to return (highest scores)
num_results = 3

# all permutations here
#puts "all permutations of input string:"
permutation_strings = []
perms_array = char_array.permutation.to_a
perms_array.each do |sub|
	joined = sub.join
	permutation_strings << joined
	#puts joined
end


# print out the possible combinations along with their markov states
#puts "all permutations and related markov states:"
permutations_with_markov_states = []
permutation_strings.each do |str|
	states = Jumbler::string_to_markov_states(str, [2,3,4])
	permutation_and_states = {:string => str, :states => states}
	permutations_with_markov_states << permutation_and_states
	#puts permutation_and_states
end


#puts "all permutations, markov states, and probability scores"
distribution_string = File.open(distribution_model_filename).read
distribution_data = YAML::load(distribution_string)
permutations_with_markov_states.each do |data|
	score = Jumbler::score_permutation_by_distribution_model(
		data[:states], distribution_data)
	data[:score] = score
	#puts data
end


puts "the #{num_results} most likely words are:"
permutations_with_markov_states.sort! do |a, b|
	b[:score] <=> a[:score]
end
permutations_with_markov_states.uniq!
results = permutations_with_markov_states[0..num_results-1]
results.each do |result|
	puts result.inspect
end








