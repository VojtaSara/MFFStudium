import random

def experiment_pairs(m, a):
    seznam_lidi = [0 for i in range(m)]
    for i in range(a):
        seznam_lidi[i] = 1

    random.shuffle(seznam_lidi)

    number_of_live_pairs = 0

    for i in range(0,m-1,2):
        if seznam_lidi[i] == 1 == seznam_lidi[i+1]:
            number_of_live_pairs += 1
    return number_of_live_pairs

m = 10
a = 10
experiment_count = 10000
experiment_results = []
for i in range(experiment_count):
    experiment_results.append(experiment_pairs(2*m,a))

print("Experimentální výsledek: ", sum(experiment_results)/experiment_count)
print("Výpočet podle vzorce: ", (a*(a-1))/(4*m - 2))