# vytvoření automatu
m3= DFA()
# definice abecedy
m3.setSigma(['a','b'])
# vytvoření stavů
m3.addState('0')
m3.addState('a')
m3.addState('b')
m3.addState('ab')
m3.addState('abb')
m3.addState('abba')
m3.addState('ba')
m3.addState('bab')
# nastavení počátečního stavu
m3.setInitial(0)
# přidání přijímacích stavů
m3.addFinal(5)
m3.addFinal(7)
# přidání přechodů
m3.addTransition(0, 'a', 1)
m3.addTransition(0, 'b', 2)
m3.addTransition(2, 'a', 6)
m3.addTransition(6, 'b', 7)
m3.addTransition(7, 'b', 7)
m3.addTransition(7, 'a', 7)
m3.addTransition(1, 'a', 1)
m3.addTransition(1, 'b', 3)
m3.addTransition(3, 'a', 6)
m3.addTransition(6, 'a', 1)
m3.addTransition(3, 'b', 4)
m3.addTransition(4, 'a', 5)
m3.addTransition(4, 'b', 2)
m3.addTransition(2, 'b', 2)
m3.addTransition(5, 'b', 5)
m3.addTransition(5, 'a', 5)


# zobrazení
m3.display()
