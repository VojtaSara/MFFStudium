import random
import copy
import math
import matplotlib.pyplot as plt
import numpy as np

# Processing of input
input_parameters = input()
N = int(input_parameters.split()[0])
K = int(input_parameters.split()[1])

item_weights_prices = np.zeros((N,2))

for i in range(N):
    item = input()
    item_weights_prices[i,0] = int(item.split()[0])
    item_weights_prices[i,1] = int(item.split()[1])


def fitness(member):
    # the following line is in the format of: [price, weight]
    price_weight = member.transpose() @ item_weights_prices

    # If individual doesn't fit in the bag, his fitness is 0, otherwise its his price
    return 0 if (price_weight[1] > K) else price_weight[0]

def random_population(population_size, individual_size):
    population = []
    # Na inicializaci zvlášť u velkých testů hodně záleží, takže si nejprve spočítám kolik průměrně jedniček chci do vektoru roznést,
    # abych nevytvářel přehršel příliš těžkých jedinců
    targetNumberOfOnes = (K/sum(item_weights_prices[0,:]))/N
    for i in range(population_size):
        individual = np.random.choice([0, 1], size=(N), p=[1 - targetNumberOfOnes, targetNumberOfOnes])
        population.append(individual)

    return population

def crossover_mean(population,cross_prob=0.5, alpha=0):
    new_population = []
    
    for i in range(0,len(population)//2):
        indiv1 = copy.deepcopy(population[2*i])
        indiv2 = copy.deepcopy(population[2*i+1])
                   
        if random.random()<cross_prob:
            # zvolime index krizeni nahodne
            crossover_point = random.randint(0, len(indiv1)) 
            end2 =  copy.deepcopy(indiv2[:crossover_point])
            indiv2[:crossover_point] = indiv1[:crossover_point]
            indiv1[:crossover_point] = end2
            
        new_population.append(indiv1)
        new_population.append(indiv2)
        
    return new_population
# Pro 100 je nejlepší 0.55, 0.008
# Pro 1000 je nejlepší 0.79, 0.001
def mutation_switch(population,individual_mutation_prob=0.79,value_mutation_prob=0.001):
    new_population = []
    for i in range(0,len(population)):
        individual = copy.deepcopy(population[i])
        if random.random()< individual_mutation_prob:
            for j in range(0,len(individual)):
                if random.random() < value_mutation_prob:
                    individual[j] = 1 - individual[j]
        new_population.append(individual)
    return new_population

def selection(population,fitness_value, x): 
    return copy.deepcopy(random.choices(population, weights=fitness_value, k=len(population)))

def evolution(population_size, individual_size, max_generations):
    max_fitness = []
    population = random_population(population_size,individual_size)
    
    for i in range(0,max_generations):
        fitness_value = list(map(fitness, population))
        max_fitness.append(max(fitness_value))
        parents = selection(population,fitness_value,2)
        children = crossover_mean(parents)
        mutated_children = mutation_switch(children)
        population = mutated_children
        
    # spocitame fitness i pro posledni populaci
    fitness_value = list(map(fitness, population))
    max_fitness.append(max(fitness_value))
    best_individual = population[np.argmax(fitness_value)]
    
    return best_individual, population, max_fitness


best, population, max_fitness = evolution(population_size=100,individual_size=N,max_generations= 3000)

print('best fitness: ', max(max_fitness))
print('best fitness from last gen: ', fitness(best))
print('best individual from last gen: ', best)


plt.plot(max_fitness)
plt.ylabel('Fitness')
plt.xlabel('Generace')
plt.show()