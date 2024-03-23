
unit wrapdvwin;

interface
procedure register;

implementation

uses dvWin, videovox, wrappers, windows, sysutils, pyapi;

var iniciou: boolean;

function pysintReadln(self: pPyObject): pPyobject;
cdecl;

var s: string;
begin
  sintReadln(s);
  pySintReadln := converteStringParaOPython(s);
end;

function pySintFalando(self_: pPyObject): pPyObject;
cdecl;
begin
  pySintFalando := retornaBool(sintFalando);
end;

function pySintWrite(self: pPyObject; args: pPyObject): pPyObject;
cdecl;
begin
  pySintWrite := pegaStringGenerica(self, args, sintWrite);
end;

function pySintWriteln(self: pPyObject; args: ppYobject): ppyObject;
cdecl;
begin
  pySintWriteln := pegaStringGenerica(self, args, sintWriteln);
end;

function pySintSoletra(self: pPyObject; args: ppYobject): ppyObject;
cdecl;
begin
  pySintSoletra := pegaStringGenerica(self, args, sintSoletra);
end;

function pySintSom(self: pPyObject; args: ppYobject): ppyObject;
cdecl;
begin
  pySintSom := pegaStringGenerica(self, args, sintSom);
end;

function pySintPara(self: pPyObject): pPyobject;
begin
  sintPara;
  Py_IncRef(Py_None);
  pySintPara := Py_None;
end;

function pySintCut(self: pPyObject): pPyobject;
begin
  sintCut;
  Py_IncRef(Py_None);
  pySintCut := Py_None;
end;

function pySintBip(self: pPyObject): pPyobject;
begin
  sintBip;
  Py_IncRef(Py_None);
  pySintBip := Py_None;
end;

function pySintClek(self: pPyObject): pPyobject;
begin
  sintClek;
  Py_IncRef(Py_None);
  pySintClek := Py_None;
end;

function pySintAmbiente(self: pPyobject; args: pPyobject): pPyObject;
cdecl;

var secao, item: pAnsiChar;
begin
  pySintAmbiente := nil;
  if pyArg_parseTuple(args, 'ss', @secao, @item) = 0 then exit;
  pySintAmbiente := converteStringParaOPython(sintAmbiente(converteStringDoPython(secao),
                    converteStringDoPython(item)));
end;

function pySintReadKey(self: pPyObject): pPyobject;
cdecl;

var s: char;
begin
  s := sintReadKey;
  pySintReadKey := pyBytes_fromStringAndSize(@s, 1);
end;

function pySintInic(self: pPyObject; args: pPyObject): pPyObject;
cdecl;

var veloc: integer;
  dirSons: pAnsiChar;
begin
  pySintInic := nil;
  if pyArg_ParseTuple(args, 'is', @veloc, @dirSons) = 0 then exit;
  if not iniciou then
    begin
      sintInic(veloc, converteStringDoPython(dirSons));
      iniciou := true;
    end;
  py_IncRef(Py_None);
  pySintInic := Py_None;
end;

function pySintFim(self: pPyObject): pPyObject;
cdecl;
begin
  sintFim;
  py_IncRef(Py_None);
  pySintFim := Py_None;
end;

function pyExisteArqSom(self: pPyObject; args: pPyObject): pPyObject;
cdecl;

var nomeSom: pAnsiChar;
begin
  if pyArg_ParseTuple(args, 's', @nomeSom) = 0 then exit;
  pyExisteArqSom := retornaBool(existeArqSom(converteStringDoPython(nomeSom)));
end;

function pySintReinic(self: pPyobject; args: pPyObject): pPyObject;
cdecl;

var veloc: integer;
  usaSapi: boolean;
  tipoSapi, vozSapi, velSapi, tomSapi: integer;
begin
  pySintReinic := nil;
  if pyArg_ParseTuple(args, 'ibiiii', @veloc, @usaSapi, @tiposapi, @vozsapi, @velSapi, @tomSapi) = 0
    then exit;
  sintReinic(veloc, usaSapi, tipoSapi, vozSapi, velSapi, tomSapi);
  py_IncRef(py_None);
  pySintReinic := Py_None;
end;

function pySintetiza(self: pPyObject; args: ppYobject): ppyObject;
cdecl;
begin
  pySintetiza := pegaStringGenerica(self, args, sintetiza);
end;

function pyExecutaArquivo(self: pPyObject; args: ppYobject): ppyObject;
cdecl;
begin
  pyExecutaArquivo := pegaStringGenerica(self, args, executaArquivo);
end;

function pySintFalaPont(self: pPyObject;args: pPyobject): pPyobject;
cdecl;

var valor: longint;
begin
  if pyArg_parseTuple(args, 'i', @valor) = 0 then
    begin
      pyErr_Clear;
      pySintFalaPont := retornaBool(sintFalaPont);
    end
  else
    begin
      sintFalaPont := valor > 0;
      Py_IncRef(Py_None);
      pySintFalaPont := Py_None;
    end;
end;

function pySintEdita(self: pPyobject; args: pPyobject): pPyobject;
cdecl;

var 
  campo: string;
  campoPython: pAnsiChar;
  x, y, tamanho, altera: integer;
  resultado: char;
  resultadoPython: pPyObject;
begin
  pySintEdita := nil;
  if pyArg_ParseTuple(args, 'siiii', @campoPython, @x, @y, @tamanho, @altera) = 0 then exit;
  campo := converteStringDoPython(campoPython);
  resultado := sintEdita(campo, x, y, tamanho, altera > 0);
  resultadoPython := pyBytes_fromStringAndSize(@resultado, 1);
  pySintEdita := py_BuildValue('OO', converteStringParaOPython(campo), resultadoPython);
end;

function pyWaitMessage(self: pPyobject; args: pPyobject): pPyobject;
cdecl;
begin
  waitMessage;
  py_IncRef(Py_None);
  pyWaitMessage := Py_None;
end;

function pysintSenha(self: pPyObject): pPyobject;
cdecl;

var s: string;
begin
  sintSenha(s);
  pySintSenha := converteStringParaOPython(s);
end;

function pySintGravaAmbiente(self: pPyobject; args: pPyobject): pPyObject;
cdecl;

var secao, item, valor: pAnsiChar;
begin
  pySintGravaAmbiente := nil;
  if pyArg_parseTuple(args, 'sss', @secao, @item, @valor) = 0 then exit;
  sintGravaAmbiente(converteStringDoPython(secao), converteStringDoPython(item),
  converteStringDoPython(valor));
  py_IncRef(py_None);
  pySintGravaAmbiente := py_None;
end;

function pySintRemoveAmbiente(self: pPyobject; args: pPyobject): pPyObject;
cdecl;

var secao, item: pAnsiChar;
begin
  pySintRemoveAmbiente := nil;
  if pyArg_parseTuple(args, 'ss', @secao, @item) = 0 then exit;
  sintRemoveAmbiente(converteStringDoPython(secao), converteStringDoPython(item));
  py_IncRef(py_None);
  pySintRemoveAmbiente := py_None;
end;

function pySAPIPresente(self_: pPyObject): pPyObject;
cdecl;
begin
  pySAPIPresente := retornaBool(SAPIPresente);
end;

function pyLeitorDeTela(self: pPyObject): pPyobject;
begin
  leitorDeTela;
  Py_IncRef(Py_None);
  pyLeitorDeTela := Py_None;
end;

var 
  Methods : packed array [0..26] of PyMethodDef;

procedure register;
begin
  Methods[0].name := 'sintReadln';
  Methods[0].meth := @pySintReadln;
  Methods[0].flags := METH_NOARGS;
  Methods[0].doc := 'Lê uma string do teclado';

  Methods[1].name := 'sintWrite';
  Methods[1].meth := @pySintWrite;
  Methods[1].flags := METH_VARARGS;
  Methods[1].doc := 'Escreve e fala uma string na tela';

  Methods[2].name := 'sintWriteln';
  Methods[2].meth := @pySintWriteln;
  Methods[2].flags := METH_VARARGS;
  Methods[2].doc := 'Escreve e fala uma string na tela, pulando linha';

  Methods[3].name := 'sintFalando';
  Methods[3].meth := @pySintFalando;
  Methods[3].flags := METH_NOARGS;
  Methods[3].doc := 'Checa se o sintetizador está falando';

  Methods[4].name := 'sintSoletra';
  Methods[4].meth := @pySintSoletra;
  Methods[4].flags := METH_VARARGS;
  Methods[4].doc := 'Soletra a string passada';

  Methods[5].name := 'sintSom';
  Methods[5].meth := @pySintSom;
  Methods[5].flags := METH_VARARGS;
  Methods[5].doc := 'Toca um arquivo de som';

  Methods[6].name := 'sintPara';
  Methods[6].meth := @pySintPara;
  Methods[6].flags := METH_NOARGS;
  Methods[6].doc := 'Para o sintetizador';

  Methods[7].name := 'sintBip';
  Methods[7].meth := @pySintBip;
  Methods[7].flags := METH_NOARGS;
  Methods[7].doc := 'Emite um bip no computador do usuário';

  Methods[8].name := 'sintClek';
  Methods[8].meth := @pySintClek;
  Methods[8].flags := METH_NOARGS;
  Methods[8].doc := 'Emite um clek no computador do usuário';

  Methods[9].name := 'sintAmbiente';
  Methods[9].meth := @pySintAmbiente;
  Methods[9].flags := METH_VARARGS;
  Methods[9].doc := 'Pega uma variável do arquivo de configuração';

  Methods[10].name := 'sintReadKey';
  Methods[10].meth := @pySintReadKey;
  Methods[10].flags := METH_NOARGS;
  Methods[10].doc := 'Lê uma tecla da janela ecoando';

  Methods[11].name := 'sintInic';
  Methods[11].meth := @pySintInic;
  Methods[11].flags := METH_VARARGS;;
  Methods[11].doc := 

'Se o sintetizador já estiver iniciado, nada faz. Senão Inicia o sintetizador com a velocidade e o diretório especificados'
  ;

  Methods[12].name := 'sintFim';
  Methods[12].meth := @pySintFim;
  Methods[12].flags := METH_NOARGS;;
  Methods[12].doc := 'Finaliza o sintetizador';

  Methods[13].name := 'existeArqSom';
  Methods[13].meth := @pyExisteArqSom;
  Methods[13].flags := METH_VARARGS;;
  Methods[13].doc := 'Verifica se um arquivo de som existe no diretório do aplicativo';

  Methods[14].name := 'sintReinic';
  Methods[14].meth := @pySintReinic;
  Methods[14].flags := METH_VARARGS;
  Methods[14].doc := 'Reinicia o sintetizador';

  Methods[15].name := 'sintetiza';
  Methods[15].meth := @pySintetiza;
  Methods[15].flags := METH_VARARGS;
  Methods[15].doc := 'Apenas sintetiza uma frase';

  Methods[16].name := 'executaArquivo';
  Methods[16].meth := @pyExecutaArquivo;
  Methods[16].flags := METH_VARARGS;
  Methods[16].doc := 'Executa um arquivo pelo dosvox';

  Methods[17].name := 'sintFalaPont';
  Methods[17].meth := @pySintFalaPont;;
  Methods[17].flags := METH_VARARGS;
  Methods[17].doc := 

'Se usado com nenhum argumento, retorna se o sintetizador fala pontuação ou não. Se usado com um argumento, configura se o sintetizador deve '
                     + 'falar pontuação';

  Methods[18].name := 'sintEdita';
  Methods[18].meth := @pySintEdita;
  Methods[18].flags := METH_VARARGS;
  Methods[18].doc := 'Edita um campo de texto';

  Methods[19].name := 'waitMessage';
  Methods[19].meth := @pyWaitMessage;
  Methods[19].flags := METH_NOARGS;
  Methods[19].doc := 'Espera algum evento acontecer';

  Methods[20].name := 'sintSenha';
  Methods[20].meth := @pysintSenha;
  Methods[20].flags := METH_VARARGS;
  Methods[20].doc := 'Lê uma senha do usuário';

  Methods[21].name := 'sintGravaAmbiente';
  Methods[21].meth := @pySintGravaAmbiente;
  Methods[21].flags := METH_VARARGS;
  Methods[21].doc := 'Escreve uma variável no arquivo de configuração (dosvox.ini)';;

  Methods[22].name := 'sintRemoveAmbiente';
  Methods[22].meth := @pySintRemoveAmbiente;;
  Methods[22].flags := METH_VARARGS;;
  Methods[22].doc := 'Remove uma variável do arquivo de configuração';

  Methods[23].name := 'SAPIPresente';
  Methods[23].meth := @pySAPIPresente;
  Methods[23].flags := METH_NOARGS;
  Methods[23].doc := 'Retorna true se o sintetizador estiver usando SAPI, senão false';

  Methods[24].name := 'leitorDeTela';
  Methods[24].meth := @pyLeitorDeTela;
  Methods[24].flags := METH_NOARGS;
  Methods[24].doc := 

                  'Ativa o leitor de tela, usado na opção CONTROL+ALT+F9 na maioria dos programas'
  ;

  Methods[25].name := 'sintCut';
  Methods[25].meth := @pySintCut;
  Methods[25].flags := METH_NOARGS;
  Methods[25].doc := 'Corta o sintetizador';

  Methods[26].name := nil;
  Methods[26].meth := nil;
  Methods[26].flags := 0;
  Methods[26].doc := nil;

  copiaFuncoes(@methods[0]);
end;
end.
