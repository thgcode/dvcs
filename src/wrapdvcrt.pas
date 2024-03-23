
unit wrapdvcrt;

interface
procedure register;

implementation

uses dvcrt, pyapi, wrappers;

function pyKeyPressed(self: pPyObject): pPyobject;
cdecl;
begin
  pyKeyPressed := retornaBool(keyPressed);
end;

function pyReadKey(self: pPyObject): pPyobject;
cdecl;

var s: char;
begin
  s := readKey;
  pyReadKey := pyBytes_fromStringAndSize(@s, 1);
end;

function pyWhereX(self: pPyObject): pPyobject;
cdecl;
begin
  pyWhereX := pyLong_fromLong(whereX);
end;

function pyWherey(self: pPyObject): pPyobject;
cdecl;
begin
  pyWherey := pyLong_fromLong(wherey);
end;

function pyClrScr(self: pPyobject): pPyObject;
cdecl;
begin
  clrscr;
  Py_Incref(Py_None);
  pyClrScr := Py_None;
end;

function pyclrEol(self: pPyobject): pPyObject;
cdecl;
begin
  clrEol;
  Py_Incref(Py_None);
  pyClrEol := Py_None;
end;

function pyTextColor(self: pPyobject; args: pPyobject): pPyobject;
cdecl;

var color: integer;
begin
  if PyArg_ParseTuple(Args, 'i', @color) = 0 then exit;
  textColor(color);
  Py_Incref(Py_None);
  pyTextColor := Py_None;
end;

function pyTextBackground(self: pPyobject; args: pPyobject): pPyobject;
cdecl;

var background: integer;
begin
  if PyArg_ParseTuple(Args, 'i', @background) = 0 then exit;
  textBackground(background);
  Py_Incref(Py_None);
  pyTextBackground := Py_None;
end;

function pySetWindowTitle(self: pPyobject; args: pPyobject): pPyobject;
cdecl;
begin
  pySetWindowTitle := pegaStringGenerica(self, args, setWindowTitle);
end;

function pyGoToXY(self: pPyobject; args: pPyobject): pPyobject;
cdecl;

var x, y: integer;
begin
  if PyArg_ParseTuple(Args, 'ii', @x, @y) = 0 then exit;
  goToXy(x, y);
  Py_Incref(Py_None);
  pyGoToXy := Py_None;
end;

function pyReadln(self: pPyObject): pPyobject;
cdecl;

var s: string;
begin
  readln(s);
  pyReadln := converteStringParaOPython(s);
end;

procedure auxWriteln(s: string);
begin
  writeln(s);
end;

function pyWriteln(self: pPyobject; args: pPyobject): pPyobject;
cdecl;
begin
  pyWriteln := pegaStringGenerica(self, args, auxWriteln);
end;

procedure auxWrite(s: string);
begin
  write(s);
end;

function pyWrite(self: pPyobject; args: pPyobject): pPyobject;
cdecl;
begin
  pyWrite := pegaStringGenerica(self, args, auxWrite);
end;

var
  methods: packed array[0..13] of PyMethodDef;

procedure register;
begin
  methods[0].name := 'keyPressed';
  methods[0].meth := @pyKeyPressed;
  methods[0].flags := METH_NOARGS;
  methods[0].doc := 'Verifica se uma tecla foi pressionada';

  methods[1].name := 'readKey';
  methods[1].meth := @pyReadKey;
  methods[1].flags := METH_NOARGS;
  methods[1].doc := 'Retorna a tecla lida da janela do programa';

  methods[2].name := 'whereX';
  methods[2].meth := @pyWhereX;
  methods[2].flags := METH_NOARGS;
  methods[2].doc := 'Retorna a posição X do cursor da tela';

  methods[3].name := 'whereY';
  methods[3].meth := @pyWhereY;
  methods[3].flags := METH_NOARGS;
  methods[3].doc := 'Retorna a posição Y do cursor da tela';

  methods[4].name := 'clrScr';
  methods[4].meth := @pyclrScr;
  methods[4].flags := METH_NOARGS;
  methods[4].doc := 'Limpa a tela';

  methods[5].name := 'clrEol';
  methods[5].meth := @pyclrEol;
  methods[5].flags := METH_NOARGS;
  methods[5].doc := 'Limpa até a nova linha';

  methods[6].name := 'textColor';
  methods[6].meth := @pyTextColor;
  methods[6].flags := METH_VARARGS;
  methods[6].doc := 'Muda a cor das letras da janela';

  methods[7].name := 'textBackground';
  methods[7].meth := @pyTextBackground;
  methods[7].flags := METH_VARARGS;
  methods[7].doc := 'Muda a cor do fundo da janela';

  methods[8].name := 'setWindowTitle';
  methods[8].meth := @pySetWindowTitle;
  methods[8].flags := METH_VARARGS;
  methods[8].doc := 'Muda o título da janela';

  methods[9].name := 'goToXY';
  methods[9].meth := @pyGoToXy;
  methods[9].flags := METH_VARARGS;
  methods[9].doc := 'Vai para a posição X, Y com o cursor de escrita';

  methods[10].name := 'readln';
  methods[10].meth := @pyReadln;
  methods[10].flags := METH_NOARGS;
  methods[10].doc := 'Lê uma linha da janela';

  methods[11].name := 'writeln';
  methods[11].meth := @pyWriteln;
  methods[11].flags := METH_VARARGS;
  methods[11].doc := 'Escreve uma linha na janela';

  methods[12].name := 'write';
  methods[12].meth := @pyWrite;
  methods[12].flags := METH_VARARGS;
  methods[12].doc := 'Escreve na janela';

  methods[13].name := nil;
  methods[13].meth := nil;
  methods[13].flags := 0;
  methods[13].doc := nil;

  copiaFuncoes(@methods[0]);
end;
end.
