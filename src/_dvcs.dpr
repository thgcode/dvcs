{ DVCS }
{ M�dulo interno de comunica��o com o Python / M�dulo principal }
{ Autor: Thiago Seus }
{ Contribui��es para as fun��es de Fabiano Ferreira, Gustavo Fernandes e Gabriel Schuck }
{ Em 02/12/2018 }

library _dvcs;

uses pyapi, wrappers;

function PyInit__dvcs: pPyObject;
cdecl;
export;
begin
  wrappers.registerAll;
  pyInit__dvcs := pyModule_Create2(@wrappers.dvcs, PYTHON_API_VERSION);
end;

exports
pyInit__dvcs;
end.
