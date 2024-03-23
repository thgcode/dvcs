
unit wrapdvscript;

interface
procedure register;

implementation

uses dvscript, interp, pyapi, wrappers;

var funcaoExterna: pPyobject;

function scriptRotinaExterna(s: string): string;

var resultado, t: pPyObject;
begin
  scriptRotinaExterna := '';
  if (funcaoExterna <> nil) and (funcaoExterna <> Py_None) then
    begin
      t := pyTuple_Pack(1, converteStringParaOPython(s));
      if t = nil then exit;
      resultado := pyObject_CallObject(funcaoExterna, t);
      if resultado = nil then exit;
      scriptRotinaExterna := converteStringDoPython(pyUnicode_asUtf8String(resultado));
    end;
end;

function pyExecutaScript(self: pPyobject; args: pPyobject): pPyobject;
cdecl;

var nomeArq, rotulo, ultLinha: pAnsiChar;
  numUltLinha : integer;
  linha: string;
  res: resultado_script;
begin
  pyExecutaScript := nil;
  if pyArg_ParseTuple(args, 'ssOis', @nomeArq, @rotulo, @funcaoExterna, @numUltLinha, @ultLinha) = 0
    then exit;
  linha := converteStringDoPython(ultLinha);
  py_IncRef(funcaoExterna);
  res := dvScript.execScript(interp.loadScript(converteStringDoPython(nomeArq)),
         converteStringDoPython(rotulo), false, numUltlinha, linha, @scriptRotinaExterna);
  pyExecutaScript := py_buildValue('iOi', numUltLinha, converteStringParaOPython(ultLinha), res);
  py_xDecRef(funcaoExterna);
end;

function pyScriptCalculaExpressao(self: pPyobject; args: pPyobject): pPyobject;
cdecl;

var res: string;
  s: pAnsiChar;
begin
  pyScriptCalculaExpressao := nil;
  if pyArg_ParseTuple(args, 's', @s) = 0 then exit;
  res := dvscript.calculaExpressao(converteStringDoPython(s));
  pyScriptCalculaExpressao := converteStringParaOPython(res);
end;

var
  methods: packed array[0..2] of PyMethodDef;

procedure register;
begin
  methods[0].name := 'executaScript';
  methods[0].meth := @pyExecutaScript;
  methods[0].flags := METH_VARARGS;
  methods[0].doc := 'Executa um script';

  methods[1].name := 'scriptCalculaExpressao';
  methods[1].meth := @pyScriptCalculaExpressao;
  methods[1].flags := METH_VARARGS;
  methods[1].doc := 'Pega um valor do script';

  methods[2].name := nil;
  methods[2].meth := nil;
  methods[2].flags := 0;
  methods[2].doc := nil;

  copiaFuncoes(@methods[0]);
end;
end.
