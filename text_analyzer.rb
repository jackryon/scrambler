require_relative "jumbler_funcs"

file_name = ARGV[0]
file = File.open(file_name)
clean_text = file.read

markov_orders = [2,3,4]
markov_states = Jumbler::string_to_markov_states(clean_text, markov_orders)
markov_state_distributions = []


markov_states.each do |state_str|
	hash = Jumbler::find_or_create_markov_distro_by_state(
		state_str, markov_state_distributions)
	hash[:count] += 1
end

markov_state_distributions.sort! do |a, b|
	comp = (a[:state] <=> b[:state])
  	comp.zero? ? (a[:count] <=> b[:count]) : comp
end

Jumbler::write_markov_distro_file(file_name, markov_state_distributions, false)

