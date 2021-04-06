import numpy as np
import random

# Processing of input
input_parameters = input()
N = int(input_parameters.split()[0])
K = int(input_parameters.split()[1])

item_weights_prices = np.zeros((N,2), dtype=np.int8)

# Here a matric
for i in range(N):
    item = input()
    item_weights_prices[i,0] = int(item.split()[0])
    item_weights_prices[i,1] = int(item.split()[1])

def fitness(member):
    # the following line is in the format of: [price, weight]
    price_weight = member.transpose() @ item_weights_prices

    # If individual doesn't fit in the bag, his fitness is 0, otherwise its his price
    return 0 if (price_weight[1] > K) else price_weight[0]

def breed(pair):
    # One point breeding
    splitLocation = random.randint(0,len(pair[0]))
    for i in range(splitLocation):
        pair[0][i], pair[1][i] = pair[1][i], pair[0][i]
    return pair[0]

def mutate(individual):
    # Mutation is a random bitflip
    bitFlip_location = random.choice(list(range(len(individual))))
    individual[bitFlip_location] = 1 - individual[bitFlip_location] 
    return individual

# Here all parameters of the simulation are instantiated
population = []
population_size = N
mutation_probability = 0.8

simulation_length = 30000

global_max_fitness = 0
global_max_individual = None

# Initialize a population with random individuals
for i in range(population_size):
    population.append(np.random.choice([0, 1], size=(N,), p=[1./3, 2./3]))

for epoch in range(simulation_length):
    # Evaluate fitness of all individuals
    fitnesses = np.zeros(population_size)
    for individual in range(population_size):
        fitnesses[individual] = fitness(population[individual])

    # Breed the most fit individuals, which are selected using roulette selection
    next_generation = []
    while (len(next_generation) != population_size):
        next_generation.append(breed(random.choices(population, weights = fitnesses, k = 2)))

    # Randomly mutate individuals
    for individual in next_generation:
        if (fitness(individual) > global_max_fitness):
            global_max_fitness = fitness(individual)
            global_max_individual = individual
            print(global_max_fitness, global_max_individual)
        
        if (random.uniform(0,1) <= mutation_probability):
            individual = mutate(individual)
    
    population = next_generation