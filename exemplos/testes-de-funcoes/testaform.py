# -*- coding: latin-1 -*-
from dvcs import *
sintInic(0, "")
formCria()
formCampo("", "Nome", "", 20)
formCampo("", "Idade", "", 20)
formCampo("", "Outro", "", 20)
resultado = formEdita(True)
sintWriteln(resultado)
formCria()
formCampo("", "Teste", "", 20)
resultado = formEdita(True)
sintWriteln(resultado)
sintWriteln("Agora com o campo preenchido")
import os
nome = os.environ["USERNAME"]
formCria()
formCampo("", "Seu nome de usuário", nome, 20)
formEdita(False)
sintFim()
