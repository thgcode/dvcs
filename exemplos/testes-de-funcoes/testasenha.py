from dvcs import *
sintInic(0, "")
while True:
    sintWrite("Digite a senha:")
    senha = sintSenha()
    writeln("")
    if senha == "123":
        sintWriteln("Senha correta")
        break
    else:
        sintWriteln("Senha incorreta")
sintWriteln("Fim do programa")
sintFim()
