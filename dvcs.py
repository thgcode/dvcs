# -*- coding: latin-1 -*-
# Reimplementa algumas funções do tradutor para serem mais flexíveis
import _dvcs
import functools
def _qualquer_valor(funcao):
    """Um decorador que possibilita passar quase qualquer valor para uma função."""
    @functools.wraps(funcao)
    def f(valor=None):
        if valor is None:
            return funcao("")
        elif not isinstance(valor, str):
            return funcao(str(valor))
        else:
            return funcao(valor)
    return f

_dvcs.sintWrite = _qualquer_valor(_dvcs.sintWrite)
_dvcs.sintWriteln = _qualquer_valor(_dvcs.sintWriteln)
_dvcs.write = _qualquer_valor(_dvcs.write)
_dvcs.writeln = _qualquer_valor(_dvcs.writeln)

del _qualquer_valor
del functools

def dvcsLeTecla(falar=True):
    if falar:
        tecla = sintReadKey()
    else:
        tecla = readKey()
    if tecla == b"\0":
        tecla += readKey()
    return tecla

_dvcs.dvcsLeTecla = dvcsLeTecla
del dvcsLeTecla

chr_velho = chr
def chr(x):
    return bytes([x])

_dvcs.ENTER = b"\r"

# Mapeia as teclas de F1 a F12
def _cria_efes(prefixo, inicio):
    for i in range(1, 13):
        setattr(_dvcs, "%s%d" % (prefixo, i), chr(0) + chr((i - 1) + inicio))

_cria_efes("F", 59)
_dvcs.ALT_F1 = chr(0) + chr(104)
_cria_efes("CONTROL_F", 94)
_dvcs.INSERT = chr(0) + chr(82)
_dvcs.DELETE = chr(0) + chr(83)
_dvcs.HOME = chr(0) + chr(71)
_dvcs.END = chr(0) + chr(79)
_dvcs.PAGEUP = chr(0) + chr(73)
_dvcs.PAGEDOWN = chr(0) + chr(81)
_dvcs.CIMA = chr(0) + chr(72)
_dvcs.BAIXO = chr(0) + chr(80)
_dvcs.ESQUERDA = chr(0) + chr(75)
_dvcs.DIREITA = chr(0) + chr(77)
_dvcs.BACKSPACE = b"\x08"
_dvcs.ESC = chr(27)
_dvcs.TAB = b"\t"
chr = chr_velho
del _cria_efes, chr_velho, chr

# Adiciona as constantes das cores
BLACK = 0
BLUE = 1
GREEN = 2
CYAN = 3
RED = 4
MAGENTA = 5
BROWN = 6
LIGHTGRAY = 7

# Foreground color constants
DARKGRAY = 8
LIGHTBLUE = 9
LIGHTGREEN = 10
LIGHTCYAN = 11
LIGHTRED = 12
LIGHTMAGENTA = 13
YELLOW = 14
WHITE = 15

def dvcsExecutaScript(nomeArq, funcao_externa=None):
    """Interface simplificada para executar um script."""
    return executaScript(nomeArq, "", funcao_externa, 1, "")

from _dvcs import *

# Gustavo: proporcionar um atalho da função clrScr para clrscr
clrscr = clrScr
