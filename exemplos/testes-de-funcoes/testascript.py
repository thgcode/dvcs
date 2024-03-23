# -*- coding: latin-1 -*-
from dvcs import *
import random
sintInic(0, "")
sintWriteln("Teste do interpretador de Scripvox dentro do Python")

def funcao_externa(comando):
    if comando.upper() == "RAND":
        return str(random.randint(1, 100))

linha, comando, erros = dvcsExecutaScript("olamundo.pro", funcao_externa)
sintWriteln("Voltando ao Python")
if erros:
    sintWriteln("Ocorreram erros")
else:
    x = scriptCalculaExpressao("$x")
    sintWriteln("O conteúdo de x é %s" % x)
sintFim()
