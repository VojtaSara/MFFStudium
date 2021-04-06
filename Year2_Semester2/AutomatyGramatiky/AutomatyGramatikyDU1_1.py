# vytvoření automatu
m3= DFA()
# definice abecedy
m3.setSigma(['a','b'])
# vytvoření stavů
m3.addState('0')
m3.addState('a')
m3.addState('b')
m3.addState('A')
m3.addState('B')
# nastavení počátečního stavu
m3.setInitial(0)
# přidání přijímacích stavů
m3.addFinal(3)
m3.addFinal(4)
# přidání přechodů
m3.addTransition(0, 'a', 1)
m3.addTransition(1, 'a', 3)
m3.addTransition(3, 'b', 1)
m3.addTransition(3, 'a', 3)
m3.addTransition(2, 'b', 4)
m3.addTransition(4, 'a', 2)
m3.addTransition(4, 'b', 4)
m3.addTransition(0, 'b', 2)



# zobrazení
m3.display()
