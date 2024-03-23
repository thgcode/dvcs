# -*- coding: latin-1 -*-
from dvcs import *
sintInic(0, "")
sintWriteln("Teste das funções do ambiente")
dirdvcs = sintAmbiente("dvcs", "dirdvcs")
sintWriteln("O DVCS está instalado nesta pasta: %s. Vou remover o caminho dele do Dosvox.ini e adicionar de novo" % dirdvcs)
sintRemoveAmbiente("dvcs", "dirdvcs")
novodirdvcs = sintAmbiente("dvcs", "dirdvcs")
if not novodirdvcs:
    sintWriteln("O diretório do DVCS do dosvox.ini foi removido")
    sintWriteln("Adicionando novamente...")
    sintGravaAmbiente("dvcs", "dirdvcs", dirdvcs)
sintFim()
