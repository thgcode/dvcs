{ DVCS - Funções base para a criação dos wrappers }
{ em Novembro/2017 }

unit wrappers;

interface

uses pyapi;

type 
  tfuncaoString = procedure (s: string);

var dvcs: pyModuleDef;

function retornaBool(valor: boolean): pPyobject;
function pegaStringGenerica(self_: pPyObject; args: ppYobject; func: tFuncaoString): pPyObject;
cdecl;
function converteStringDoPython(s: pAnsiChar): string;
function converteStringparaOPython(s: string): pPyObject;
procedure registerAll;
procedure copiaFuncoes(funcs: pPyMethodDef);
// TODO criar um módulo específico para cada unit do Dosvox e retirar essa função

implementation

uses wrapdvarq, wrapdvcrt, wrapdvform, wrapdvhora, wrapdvscript, wrapdvwin, sysutils;

const 
  MAX_FUNCOES = 100;

var cont: integer;
  metodos: packed array[0..MAX_FUNCOES] of PyMethodDef;

function retornaBool(valor: boolean): pPyobject;
begin
  if valor then
    begin
      py_IncRef(Py_True);
      retornaBool := Py_True;
    end
  else
    begin
      Py_IncRef(Py_False);
      retornaBool := Py_False;
    end;
end;

function pegaStringGenerica(self_: pPyObject; args: ppYobject; func: tFuncaoString): pPyObject;
cdecl;

var s: pAnsiChar;
begin
  pegaStringGenerica := nil;
  if PyArg_ParseTuple(Args, 's', @s) = 0 then exit;
  func(converteStringDoPython(s));
  py_IncRef(py_none);
  pegaStringGenerica := Py_None;
end;

function converteStringDoPython(s: pAnsiChar): string;
begin
  converteStringDoPython := UTF8ToAnsi(strPas(s));
end;

function converteStringparaOPython(s: string): pPyObject;
begin
  converteStringParaOPython := pyUnicode_fromString(@ansiToUTF8(s)[1]);
end;

procedure registerAll;
begin
  wrapdvarq.register;
  wrapdvCrt.register;
  wrapDvForm.register;
  wrapDvHora.register;
  wrapDvScript.register;
  wrapdvWin.register;

  with dvcs do
    begin
      m_name := 'dvcs';
      m_doc := 'Módulo que contém as funções internas do tradutor do Dosvox';
      m_size := -1;
      m_methods := @metodos[0];
    end;
end;

procedure copiaFuncoes(funcs: pPyMethodDef);

var m: pPyMethodDef;
begin
  m := funcs;
  while m^.name <> nil do
    begin
      with metodos[cont] do
        begin
          name := m^.name;
          meth := m^.meth;
          flags := m^.flags;
          doc := m^.doc;
        end;
      inc(m);
      inc(cont);
    end;
end;
end.
