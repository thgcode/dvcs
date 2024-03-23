
unit PyAPI;

{

  Minimum set of Python function declarations for module libraries.

  Author: Phil (MacPgmr at fastermac.net).

  To add other Python function declarations, see the Python header
   files (.h) included with every Python distribution.

}

{$IFDEF FPC}
 {$MODE Delphi}
{$ENDIF}

interface

const 
  PythonLib = 'python3.dll';

type 
  c_long = LongInt;
  c_ulong = LongWord;
  c_int  = longInt;

  ppyTypeObject = ^pyTypeObject;
  tPyObject = packed record
    ob_refcnt: c_int;
    ob_type: ppyTypeObject;
  end;
  pPyObject = ^tPyobject;

  PyMethodDef = packed record
    name : PAnsiChar;
    //Python function name
    meth : Pointer;
    //Address of function that implements it
    flags: c_int;
    //METH_xxx flags; describe function's arguments
    doc  : PAnsiChar;
    //Description of funtion
  end;
  pPyMethodDef = ^PyMethodDef;

  pydestructor      = procedure (ob: PPyObject);
  cdecl;
  printfunc         = function ( ob: PPyObject; var f: file; i: integer): integer;
  cdecl;
  getattrfunc       = function ( ob1: PPyObject; name: PAnsiChar): PPyObject;
  cdecl;
  setattrfunc       = function ( ob1: PPyObject; name: PAnsiChar; ob2: PPyObject): integer;
  cdecl;
  cmpfunc           = function ( ob1,ob2: PPyObject): integer;
  cdecl;
  reprfunc          = function ( ob: PPyObject): PPyObject;
  cdecl;
  hashfunc          = function ( ob: PPyObject): c_int;
  cdecl;
  // !! in 2.x it is still a LongInt
  getattrofunc      = function ( ob1,ob2: PPyObject): PPyObject;
  cdecl;
  setattrofunc      = function ( ob1,ob2,ob3: PPyObject): integer;
  cdecl;

  /// jah 29-sep-2000: updated for python 2.0
  ///                   added from object.h
  getreadbufferproc = function ( ob1: PPyObject; i: c_int; ptr: Pointer): c_int;
  cdecl;
  getwritebufferproc = function ( ob1: PPyObject; i: c_int; ptr: Pointer): c_int;
  cdecl;
  getsegcountproc   = function ( ob1: PPyObject; i: c_int): c_int;
  cdecl;
  getcharbufferproc = function ( ob1: PPyObject; i: c_int; const pstr: PAnsiChar): c_int;
  cdecl;
  objobjproc        = function ( ob1, ob2: PPyObject): integer;
  cdecl;
  visitproc         = function ( ob1: PPyObject; ptr: Pointer): integer;
  cdecl;
  traverseproc      = function ( ob1: PPyObject; proc: visitproc; ptr: Pointer): integer;
  cdecl;

  richcmpfunc       = function ( ob1, ob2: PPyObject; i: Integer): PPyObject;
  cdecl;
  getiterfunc       = function ( ob1: PPyObject): PPyObject;
  cdecl;
  iternextfunc      = function ( ob1: PPyObject): PPyObject;
  cdecl;
  descrgetfunc      = function ( ob1, ob2, ob3: PPyObject): PPyObject;
  cdecl;
  descrsetfunc      = function ( ob1, ob2, ob3: PPyObject): Integer;
  cdecl;
  initproc          = function ( self, args, kwds: PPyObject): Integer;
  cdecl;
  newfunc           = function ( subtype: PPyTypeObject; args, kwds: PPyObject): PPyObject;
  cdecl;
  allocfunc         = function ( self: PPyTypeObject; nitems: c_int): PPyObject;
  cdecl;

  PyTypeObject = packed record
    ob_refcnt: c_int;
    ob_type:        PPyTypeObject;
    ob_size:        c_int;
    // Number of items in variable part
    tp_name:        PAnsiChar;
    // For printing
    tp_basicsize, tp_itemsize: c_int;
    // For allocation

    // Methods to implement standard operations

    tp_dealloc:     pydestructor;
    tp_print:       printfunc;
    tp_getattr:     getattrfunc;
    tp_setattr:     setattrfunc;
    tp_compare:     cmpfunc;
    tp_repr:        reprfunc;

    // Method suites for standard classes

    tp_as_number:   pointer;
    tp_as_sequence: pointer;
    tp_as_mapping:  pointer;

    // More standard operations (here for binary compatibility)

    tp_hash:        hashfunc;
    tp_call:        pointer;
    tp_str:         reprfunc;
    tp_getattro:    getattrofunc;
    tp_setattro:    setattrofunc;

    /// jah 29-sep-2000: updated for python 2.0

    // Functions to access object as input/output buffer
    tp_as_buffer:   pointer;
    // Flags to define presence of optional/expanded features
    tp_flags:       LongInt;

    tp_doc:         PAnsiChar;
    // Documentation string

    // call function for all accessible objects
    tp_traverse:    traverseproc;

    // delete references to contained objects
    tp_clear:       pointer;

    // rich comparisons
    tp_richcompare: richcmpfunc;

    // weak reference enabler
    tp_weaklistoffset: c_int;
    // Iterators
    tp_iter: getiterfunc;
    tp_iternext: iternextfunc;

    // Attribute descriptor and subclassing stuff
    tp_methods         : PPyMethodDef;
    tp_members         : Ppointer;
    tp_getset          : pointer;
    tp_base            : PPyTypeObject;
    tp_dict            : PPyObject;
    tp_descr_get       : descrgetfunc;
    tp_descr_set       : descrsetfunc;
    tp_dictoffset      : c_int;
    tp_init            : initproc;
    tp_alloc           : allocfunc;
    tp_new             : newfunc;
    tp_free            : pydestructor;
    // Low-level free-memory routine
    tp_is_gc           : pointer;
    // For PyObject_IS_GC
    tp_bases           : PPyObject;
    tp_mro             : PPyObject;
    // method resolution order
    tp_cache           : PPyObject;
    tp_subclasses      : PPyObject;
    tp_weaklist        : PPyObject;
    //More spares
    tp_xxx7            : c_int;
    tp_xxx8            : LongInt;
  end;

const 
  METH_VARARGS = 1;
  METH_NOARGS = 4;

procedure Py_Initialize;
cdecl;
external PythonLib;
procedure Py_Finalize;
cdecl;
external PythonLib;

function PyRun_SimpleStringFlags(aString: pChar; flags: c_int): c_int;
cdecl;
external PythonLib;

function PyImport_ImportModule(moduleName: pAnsiChar): pPyObject;
cdecl;
external PythonLib;
function PyModule_AddFunctions(module: pPyObject; functions: pPyMethodDef): c_int;
cdecl;
external PythonLib;

procedure PyErr_Clear;
cdecl;
external PythonLib;
function PyErr_Occurred: pPyObject;
cdecl;
external PythonLib;

function PyArg_ParseTuple(args  : pPyObject;
                          format: PAnsiChar): c_int;
cdecl;
varargs;
external PythonLib;
function Py_BuildValue(format: PAnsiChar): pPyObject;
cdecl;
varargs;
external PythonLib;
//Note varargs allows us to simulate C variable number of arguments (...).

function PyTuple_Pack(size: c_long): pPyObject;
cdecl;
varargs;
external PythonLib;
function PyObject_CallObject(func: pPyobject; args: pPyobject): pPyObject;
cdecl;
external PythonLib;

function PyInt_FromLong(along: c_long): pPyObject;
cdecl;
external PythonLib;

function PyLong_FromLong(along: c_long): pPyObject;
cdecl;
external PythonLib;

function PyLong_FromUnsignedLong(aulong: c_ulong): pPyObject;
cdecl;
external PythonLib;

function PyBytes_FromStringAndSize(astr: PAnsiChar; aSize: c_long): pPyObject;
cdecl;
external PythonLib;
function PyUnicode_FromString(astr: PAnsiChar): pPyObject;
cdecl;
external PythonLib;
function PyUnicode_AsUTF8String(astr: pPyobject): pChar;
cdecl;
external PythonLib;

function PyDict_New: pPyobject;
cdecl;
external PythonLib;
function PyDict_SetItem(dict: pPyobject; key: pPyobject; value: pPyObject): c_int;
cdecl;
external PythonLib;

function PyList_New(len: c_int): pPyObject;
cdecl;
external PythonLib;
function PyList_Append(list: pPyobject; item: pPyobject): c_int;
cdecl;
external PythonLib;
function PySys_SetObject(objectName: pChar; toValue: pPyObject): c_int;
cdecl;
external PythonLib;

procedure   Py_INCREF   ( op: pPyObject);
procedure   Py_DECREF   ( op: pPyObject);
procedure   Py_XINCREF  ( op: ppyObject);
procedure   Py_XDECREF  ( op: pPyObject);

type 
  pPyModuleDef = ^PyModuleDef;
  PyModuleDef = packed record
    ob_refcnt: c_int;
    ob_type: ppyTypeObject;
    m_init: pointer;
    m_index: c_int;
    m_copy: pointer;
    m_name: pChar;
    m_doc: pChar;
    m_size: c_int;
    m_methods: pPyMethodDef;
    m_slots: pointer;
    m_reload: pointer;
    m_traverseproc: pointer;
    m_clear: pointer;
    m_freefunc: pointer;
  end;

const PYTHON_API_VERSION = 1013;

function PyModule_Create2(module: pPyModuleDef; version: c_int): pPyobject;
cdecl;
external PYTHONLIB;

var 
  PY_None, Py_False, Py_True: pPyObject;

implementation

uses dvwin, windows, sysutils;

procedure getObjects;

var dll: tHandle;
begin
  dll := safeloadLibrary(PYTHONLIB);
  if dll < 0 then sintWriteln('Erro ao carregar py_none');
  Py_None := getProcAddress(dll, '_Py_NoneStruct');
  Py_False := getProcAddress(dll, '_Py_FalseStruct');
  Py_True := getProcAddress(dll, '_Py_TrueStruct');
  freeLibrary(dll);
end;

procedure Py_INCREF(op: PPyObject);
begin
  Inc(op^.ob_refcnt);
end;

procedure Py_DECREF(op: PPyObject);
begin
  with op^ do
    begin
      Dec(ob_refcnt);
      if ob_refcnt = 0 then
        begin
          ob_type^.tp_dealloc(op);
        end;
    end;
end;

procedure Py_XINCREF(op: PPyObject);
begin
  if op <> nil then Py_INCREF(op);
end;

procedure Py_XDECREF(op: PPyObject);
begin
  if op <> nil then Py_DECREF(op);
end;

begin
  getObjects;
end.
