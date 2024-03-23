# Pequeno telnet que se conecta no servidor da Intervox
from dvcs import *
from telnetlib import Telnet
sintInic(0, "")
sintWriteln("Entrando")
t = Telnet("intervox.nce.ufrj.br", 1963)
sintWriteln("Conectado")
while True:
    if keyPressed():
        dado = sintReadln()
        t.write(dado.encode("iso8859_1") + b"\r\n")
        sintClek()
    if t.sock_avail() or t.cookedq or t.rawq:
        try:
            msg = t.read_until(b"\n").strip().decode("iso8859_1")
        except EOFError:
            break
        sintWriteln(msg)
sintWriteln("Programa terminado")
sintFim()
