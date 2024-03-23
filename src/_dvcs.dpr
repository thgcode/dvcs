{ DVCS }
{ Módulo interno de comunicação com o Python / Módulo principal }
{ Autor: Thiago Seus }
{ Contribuições para as funções de Fabiano Ferreira, Gustavo Fernandes e Gabriel Schuck }
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
