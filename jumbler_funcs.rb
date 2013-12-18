require 'yaml'

module Jumbler

	# takes a collection and a state and either returns the hash, 
	# or builds a new one from the state
	def self.find_or_create_markov_distro_by_state(state, st_collection)
		st_collection.each do |hash|
			if hash[:state] == state
				return hash
			end
		end
		new_hash = {:state => state, :count => 0}
		st_collection << new_hash
		new_hash
	end


	# takes in a string and creates an array of markov states 'markov_order' long
	def self.string_to_markov_states(str, markov_orders=[2])
		markov_states = []
		markov_orders.each do |m_order|
			i = 0
			begin
				markov_states << str[i, m_order]
				i += 1
			end until i >= (str.length - (m_order-1))
		end
		markov_states
	end


	# write out the markov state distributions file
	def self.write_markov_distro_file(filename, distributions_array, human_readable=false)
		output_file = File.open('DISTRO_'+filename, 'w')
		unless human_readable
			output_file.write(YAML::dump(distributions_array))
		else
			distributions_array.each do |hash|
				output_file.write(hash.inspect)
				output_file.write("\n")
			end
		end
	end


	# add up the scores from all states in the permutation
	def self.score_permutation_by_distribution_model(states_array, distro_model)
		score = 0
		states_array.each do |state|
			score += get_score_for_state_from_distro(state, distro_model)
			# here we apply modifiers for scores (the longer the state the more it is worth)
			# this is a really basic modification scheme..
			score *= (state.length-1)
		end
		score
	end


	# get the score from the distro model for a given state
	def self.get_score_for_state_from_distro(state, distro)
		score = 0
		distro.each do |d_state|
			if d_state[:state] == state
				score = d_state[:count]
			end
		end
		score
	end

end





