
unit wrapdvform;

interface
procedure register;

implementation

uses pyapi, wrappers, dvform;

const 
  MAX_CAMPOS = 100;

type 
  tCampo = record
    nomecampo: string;
    valor: shortString;
  end;

var 
  campos: array [0..MAX_CAMPOS] of tCampo;
  contagem_campos: integer;

function pyFormCria(self: pPyobject): pPyobject;
cdecl;

var i: integer;
begin
  for i := 0 to contagem_campos - 1 do
    begin
      campos[i].nomecampo := '';
      campos[i].valor := '';
    end;
  formCria;
  contagem_campos := 0;
  py_IncRef(py_None);
  pyFormCria := Py_None;
end;

function pyFormCampo(self: pPyobject; args: pPyobject): pPyobject;
cdecl;

var nomeArqSom, nome, padrao: pAnsiChar;
  tamanho: integer;
begin
  pyFormCampo := nil;
  if contagem_campos >= max_campos then
    begin
      py_IncRef(py_None);
      pyFormCampo := Py_None;
      exit;
    end;
  if pyArg_ParseTuple(args, 'sssi', @nomeArqSom, @nome, @padrao, @tamanho) = 0 then exit;
  campos[contagem_campos].valor := converteStringDoPython(padrao);
  formCampo(converteStringDoPython(nomeArqSom), converteStringDoPython(nome), campos[contagem_campos
  ].valor, tamanho);
  campos[contagem_campos].nomeCampo := converteStringDoPython(nome);
  inc(contagem_campos);
  py_IncRef(py_None);
  pyFormCampo := Py_None;
end;

function pyFormEdita(self: pPyobject; args: pPyobject): pPyobject;
cdecl;

var altera, i: integer;
  dicCampos: pPyObject;
  res: char;
begin
  pyFormEdita := nil;
  if pyArg_ParseTuple(args, 'i', @altera) = 0 then exit;
  res := formEdita(altera > 0);
  dicCampos := pyDict_New;
  if dicCampos = nil then exit;
  py_IncRef(dicCampos);
  for i := 0 to contagem_campos - 1 do
    begin
      if pyDict_setItem(dicCampos,
         converteStringParaOPython(campos[i].nomeCampo), converteStringParaOPython(campos[i].valor))
         =
         -1 then exit;
    end;
  pyFormEdita := py_BuildValue('OO', dicCampos,
                 pyBytes_fromStringAndSize(@res, 1));
end;

function pyPopupMenuCria(self: pPyObject; args: pPyObject): pPyObject;
cdecl;

var x, y, tam, nopcoestela, corFundo: integer;
begin
  if pyArg_ParseTuple(args, 'iiiii', @x, @y, @tam, @nopcoesTela, @corFundo) = 0 then exit;
  popupMenuCria(x, y, tam, nopcoesTela, corFundo);
  py_IncRef(py_None);
  pyPopupMenuCria := Py_None;
end;

function pyPopupMenuAdiciona(self: pPyObject; args: pPyObject): pPyObject;
cdecl;

var nomeArqSom, nome: pAnsiChar;
begin
  pyPopupMenuAdiciona := nil;
  if pyArg_ParseTuple(args, 'ss', @nomeArqSom, @nome) = 0 then exit;
  popupMenuAdiciona(converteStringDoPython(nomeArqSom), converteStringDoPython(nome));
  py_IncRef(py_None);
  pyPopupMenuAdiciona := py_None;
end;

function pyPopupMenuSeleciona(self: pPyObject): pPyObject;
cdecl;
begin
  pyPopupMenuSeleciona := pyLong_fromLong(popupMenuSeleciona);
end;

var 
  methods: packed array [0..6] of pyMethodDef;

procedure register;
begin
  methods[0].name := 'popupMenuCria';
  methods[0].meth := @pyPopupMenuCria;
  methods[0].flags := METH_VARARGS;
  methods[0].doc := 'Cria um menu vazio na tela';

  methods[1].name := 'popupMenuAdiciona';
  methods[1].meth := @pyPopupMenuAdiciona;
  methods[1].flags := METH_VARARGS;
  methods[1].doc := 'Adiciona um item com som e nome ao menu';

  methods[2].name := 'popupMenuSeleciona';
  methods[2].meth := @pyPopupMenuSeleciona;
  methods[2].flags := METH_NOARGS;
  methods[2].doc := 'Deixa o usuário selecionar um item do menu e retorna a opção escolhida';

  methods[3].name := 'formCria';
  methods[3].meth := @pyFormCria;
  methods[3].flags := METH_NOARGS;
  methods[3].doc := 'Cria um formulário';

  methods[4].name := 'formCampo';
  methods[4].meth := @pyFormCampo;
  methods[4].flags := METH_VARARGS;
  methods[4].doc := 'Adiciona um campo ao formulário';

  methods[5].name := 'formEdita';
  methods[5].meth := @pyFormEdita;
  methods[5].flags := METH_VARARGS;
  methods[5].doc := 'Edita ou visualiza o formulário';

  methods[6].name := nil;
  methods[6].meth := nil;
  methods[6].flags := 0;
  methods[6].doc := nil;

  copiaFuncoes(@methods[0]);
end;
end.
