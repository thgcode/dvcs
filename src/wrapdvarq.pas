
unit wrapdvarq;

interface
procedure register;

implementation

uses dvarq, pyapi, wrappers;

function pyObtemNomeArq(self: pPyobject; args: pPyObject): pPyobject;
cdecl;

var dy: integer;
  s: string;
begin
  if pyArg_ParseTuple(args, 'i', @dy) = 0 then exit;
  s := obtemNomeArq(dy);
  pyObtemNomeArq := converteStringParaOPython(s);
end;

var 
  methods: packed array[0..1] of PyMethodDef;

procedure register;
begin
  methods[0].name := 'obtemNomeArq';
  methods[0].meth := @pyObtemNomeArq;
  methods[0].flags := METH_VARARGS;
  methods[0].doc := 'Retorna o nome do arquivo selecionado pelo usuário';

  methods[1].name := nil;
  methods[1].meth := nil;
  methods[1].flags := 0;
  methods[1].doc := nil;

  copiaFuncoes(@methods[0]);
end;
end.
