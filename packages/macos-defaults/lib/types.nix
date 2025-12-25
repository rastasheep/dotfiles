{ pkgs }:

{
  validTypes = [ "bool" "int" "string" "float" "array" "dict" ];

  isValidType = type: builtins.elem type [ "bool" "int" "string" "float" "array" "dict" ];

  validateValueType = value: type:
    if type == "bool" then
      builtins.isBool value
    else if type == "int" then
      builtins.isInt value
    else if type == "float" then
      builtins.isFloat value || builtins.isInt value  # Accept int as float
    else if type == "string" then
      builtins.isString value
    else if type == "array" then
      builtins.isList value
    else if type == "dict" then
      builtins.isAttrs value
    else
      false;

  typeDescription = type:
    if type == "bool" then
      "boolean (true/false)"
    else if type == "int" then
      "integer"
    else if type == "float" then
      "float or integer"
    else if type == "string" then
      "string"
    else if type == "array" then
      "list/array"
    else if type == "dict" then
      "attribute set/dictionary"
    else
      "unknown type";
}
