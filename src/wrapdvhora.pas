
unit wrapdvhora;

interface
procedure register;

implementation

uses pyapi, wrappers, dvhora;
function pyFalaDia(self: pPyobject): pPyobject;
cdecl;
begin
  falaDia;
  Py_IncRef(Py_None);
  pyFalaDia := Py_None;
end;

function pyFalaHora(self: pPyobject): pPyobject;
cdecl;
begin
  falaHora;
  Py_IncRef(Py_None);
  pyFalaHora := Py_None;
end;

var 
  methods: packed array[0..2] of PyMethodDef;

procedure register;
begin
  methods[0].name := 'falaDia';
  methods[0].meth := @pyFalaDia;
  methods[0].flags := METH_NOARGS;
  methods[0].doc := 'Fala o dia por extenso, semelhantemente à função CONTROL+F8';

  methods[1].name := 'falaHora';
  methods[1].meth := @pyFalaHora;
  methods[1].flags := METH_NOARGS;
  methods[1].doc := 'Fala a hora, semelhantemente à função F8';

  methods[2].name := nil;
  methods[2].meth := nil;
  methods[2].flags := 0;
  methods[2].doc := nil;

  copiaFuncoes(@methods[0]);
end;
end.
